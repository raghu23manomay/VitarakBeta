using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MyVitarak.Models;
using System.Data.SqlClient;
using PagedList;
using System.Data;
using System.Configuration;
using System.Web.Configuration;
using System.IO;
using System.Text.RegularExpressions;

namespace MyVitarak.Controllers
{
    public class HomeController : Controller
    {

        
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult EstimateCost()
        {
            return View();
        }


        public ActionResult PaymentCheckout()
        {
            return View();
        }

        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Login(Login L)
        {
            try
            {

                JobDbContext2 _db = new JobDbContext2();
                var result = _db.LoginDetail.SqlQuery(@"exec usp_login 
                @username,@password",
                    new SqlParameter("@username", L.UserName),
                    new SqlParameter("@password", L.password)).ToList<Login>();
                Login data = new Login();
                data = result.FirstOrDefault();

                if (data == null)
                {
                    return Json("Please enter valid user Name password");
                }
                else
                {

                    Session["username"] = data.UserName;
                    Session["BusinessName"] = data.DbName;
                    Session["MobileNo"] = data.MobileNo;
                    Session["Name"] = data.Name;
                    Session["UserID"] = data.UserID;
                    Session["IsLiveUser"] = data.IsLiveUser;
                    if(data.IsLiveUser==1)
                    {
                        return Json("Live");
                    }
                    else
                    {
                        return Json("NonLive");
                    }
                    //  GetDbSchemaStatus(data.RegistrationID);
                    //return Json("Login Sucessfull");

                }
            }


            catch (Exception ex)
            {
                return Json(ex.Message);
            }

        }


        public void InsertDbschemaInUSerDatabase()
        {
            
            
            using (JobDbContext context = new JobDbContext())
            {
                var c=context.Database.BeginTransaction();
               
                var conn = context.Database.Connection;
                var connectionState = conn.State;
                //var temp = "";

                try
                {
                    var script = System.IO.File.ReadAllText(Server.MapPath(@"~/Scripts/DBSchema.sql"));
                    IEnumerable<string> commandStrings = Regex.Split(script, @"^\s*GO\s*$", RegexOptions.Multiline | RegexOptions.IgnoreCase);

                    if (connectionState != ConnectionState.Open) conn.Open();
                    foreach (string commandString in commandStrings)
                    {
                        if (commandString.Trim() != "")
                        {
                            using (var cmd = conn.CreateCommand())
                            {
                                cmd.CommandText = commandString;
                                cmd.CommandType = CommandType.Text;
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                    c.Commit();
                }
                catch (Exception ex)
                {
                    // error handling
                    c.Rollback();
                    var messege = ex.Message;

                }
                finally
                {
                    if (connectionState != ConnectionState.Closed) conn.Close();
                }
            }
        }


        public void updateDbShemaStatus(Int64? regid)
        {
            JobDbContext2 _db2 = new JobDbContext2();
            var result = _db2.Database.ExecuteSqlCommand(@"exec Usp_UpdateDbScemaStatus @RegistrationID",
             new SqlParameter("@RegistrationID", regid));
        }


        public void GetDbSchemaStatus(Int64? regid)
        {
            JobDbContext2 _db2 = new JobDbContext2();
            var result = _db2.CheckDbSchema.SqlQuery(@"exec Usp_GetDbScemaStatus @RegistrationID",
                new SqlParameter("@RegistrationID", regid)).ToList<CheckDbSchema>();
            CheckDbSchema data = new CheckDbSchema();
            data = result.FirstOrDefault();

            if (data.isDbSchema == false)
            {
                InsertDbschemaInUSerDatabase();
                updateDbShemaStatus(regid);
            }

        }

        public ActionResult Registration(int? planid)
        {
            try
            {
                if (planid > 0)
                {


                    JobDbContext2 _db = new JobDbContext2();
                    var result = _db.PlanRate.SqlQuery(@"exec Usp_GetplanDetailById 
                @PlanID",
                        new SqlParameter("@PlanID", planid)).ToList<PlanRate>();
                    PlanRate data = new PlanRate();
                    data = result.FirstOrDefault();

                    if (data == null)
                    {
                        return Json("No plans are available");
                    }
                    else
                    {
                        var tt = data.PlanAmount + data.OTIAmount;
                        Session["PlanName"] = data.PlanName;
                        Session["PlanDesc"] = data.PlanDesc;
                        Session["PlanAmount"] = data.PlanAmount;
                        Session["Total"] = tt;
                        Session["PlanID"] = data.PlanID;

                    }
                }
               
            }

            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);
            }
            return View();
        }

        [HttpPost]
        public ActionResult insert_Registration(Registration rs)
        {
            JobDbContext2 _db = new JobDbContext2();
            try
            {
                var res = 0;
                res = _db.Database.ExecuteSqlCommand(@"exec uspInsertRegistration
                    @pName,
                    @pBusinessName,
                    @pContactPerson,
                    @pContactPersonMobile,
                    @pAddress,
                    @pCity,
                    @pPin,
                    @pEmail,
                    @pMobile,
                    @pUserName,
                    @pPasssword",
                    new SqlParameter("@pName", rs.Name),
                    new SqlParameter("@pBusinessName", rs.BusinessName),
                    new SqlParameter("@pContactPerson", rs.ContactPerson),
                    new SqlParameter("@pContactPersonMobile", rs.ContactPersonMobile),
                    new SqlParameter("@pAddress", rs.Address),
                    new SqlParameter("@pCity", rs.City),
                    new SqlParameter("@pPin", rs.PinCode),
                    new SqlParameter("@pEmail", rs.Email),
                    new SqlParameter("@pMobile", rs.Mobile),
                    new SqlParameter("@pUserName", rs.UserName),
                    new SqlParameter("@pPasssword", rs.password)

                    );
                              
                Session["CName"] = rs.Name;
                Session["BusinessName"] = rs.BusinessName.Replace(" ", ""); ;
                Session["ContactPerson"] = rs.ContactPerson;
                Session["Address"] = rs.Address;
                Session["Mobile"] = rs.Mobile;
                Session["UserName"] = rs.UserName;
                return Json("Registration Sucessfull");
                

            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);
            }

        }

        [HttpPost]
        public ActionResult insert_tenant(Tenant rs)
        {

            using (JobDbContext2 context = new JobDbContext2())
            {

                var conn = context.Database.Connection;
                var connectionState = conn.State;
                try
                {
                    //==================  Get Security Code ==========================
                   var SercurityCode = "";
                    SecurityCode SC = new SecurityCode();
                   var res = context.SecurityCode.SqlQuery(@"exec uspGenerateSecurityCode");
                    SC = res.FirstOrDefault();
                    SercurityCode = SC.Code;

                    //==================  Insert Into Teanant ==========================

                    if (connectionState != ConnectionState.Open) conn.Open();
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "uspInsertTenant";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@mName", rs.Name));
                        cmd.Parameters.Add(new SqlParameter("@mDbname", rs.DbName));
                        cmd.Parameters.Add(new SqlParameter("@mAddress", rs.Address));
                        cmd.Parameters.Add(new SqlParameter("@mMobile", rs.Mobile));
                        cmd.Parameters.Add(new SqlParameter("@mContactPerson", rs.ContactPerson));
                        cmd.Parameters.Add(new SqlParameter("@mSecurityCode",SercurityCode));
                        cmd.Parameters.Add(new SqlParameter("@misActive", true));
                        cmd.Parameters.Add(new SqlParameter("@misReadOnly",false));
                        
                        cmd.ExecuteNonQuery();
                    }
                    InsertDbschemaInUSerDatabase();
                }
                catch (Exception ex)
                {
                    // error handling
                    var messege = ex.Message;
                    return Json(messege);
                }
                finally
                {
                    if (connectionState != ConnectionState.Closed) conn.Close();
                }

                return Json("Application deployed sucessfull");
            }

        }


        [HttpPost]
        public ActionResult insert_Payment(Payment rs)
        {
            JobDbContext2 _db = new JobDbContext2();
            try
            {

                var res = _db.Database.ExecuteSqlCommand(@"exec [uspInsertPayment] @mpayment_id,@mregistration_id,@mp_id,@mamount,@mpayment_date",
                    new SqlParameter("@mpayment_id", rs.payment_id),
                    new SqlParameter("@mregistration_id", rs.registration_id),
                    new SqlParameter("@mp_id", rs.p_id),
                    new SqlParameter("@mamount", rs.amount),
                    new SqlParameter("@mpayment_date", DateTime.Now)
                    );


                if (res == 0)
                {
                    return Json("need to contact support team");
                }
                else
                {
                    return Json("Payment sucessfull");
                }


            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);
            }

        }



        public ActionResult EmailCheck(string email = "")
        {
            try
            {
                JobDbContext2 _db = new JobDbContext2();
                var result = _db.MailCheck.SqlQuery(@"exec Usp_CheckEmailExistance 
                @Email",
                    new SqlParameter("@Email", email)).ToList<MailCheck>();
                MailCheck data = new MailCheck();
                data = result.FirstOrDefault();

                if (data == null)
                {
                    return Json("Email id is available");
                }
                else
                {

                    return Json("Email id already exist");

                }
            }

            catch (Exception ex)
            {
                return Json(ex.Message);
            }

        }

                     
        public ActionResult MobileCheck(string Mobile = "")
        {
            try
            {
                JobDbContext2 _db = new JobDbContext2();
                var result = _db.MailCheck.SqlQuery(@"exec Usp_CheckMobileExistance 
                @Mobile",
                    new SqlParameter("@Mobile", Mobile)).ToList<MailCheck>();
                MailCheck data = new MailCheck();
                data = result.FirstOrDefault();

                if (data == null)
                {
                   return Json("");
                }
                else
                {

                    return Json("Mobile no already exist");

                }
            }

            catch (Exception ex)
            {
                return Json(ex.Message);
            }

        }


        public ActionResult UserNameCheck(string UserName = "")
        {
            try
            {
                JobDbContext2 _db = new JobDbContext2();
                var result = _db.MailCheck.SqlQuery(@"exec Usp_CheckUserNameExistance 
                @UserName",
                new SqlParameter("@UserName", UserName)).ToList<MailCheck>();
                MailCheck data = new MailCheck();
                data = result.FirstOrDefault();

                if (data == null)
                {
                    return Json("");
                }
                else
                {

                    return Json("User Name already exist");

                }
            }

            catch (Exception ex)
            {
                return Json(ex.Message);
            }

        }


        public ActionResult BusinessNameCheck(string BusinessName = "")
        {
            try
            {
                JobDbContext2 _db = new JobDbContext2();
                var result = _db.MailCheck.SqlQuery(@"exec Usp_CheckBusinessNameExistance 
                @BusinessName",
                new SqlParameter("@BusinessName", BusinessName)).ToList<MailCheck>();
                MailCheck data = new MailCheck();
                data = result.FirstOrDefault();

                if (data == null)
                {
                    return Json("");
                }
                else
                {

                    return Json("Business Name already exist");

                }
            }

            catch (Exception ex)
            {
                return Json(ex.Message);
            }

        }


        public ActionResult LoginForPayment(int? planid)
        {
            try
            {
                JobDbContext2 _db = new JobDbContext2();
                var result = _db.PlanRate.SqlQuery(@"exec Usp_GetplanDetailById 
                @PlanID",
                    new SqlParameter("@PlanID", planid)).ToList<PlanRate>();
                PlanRate data = new PlanRate();
                data = result.FirstOrDefault();

                if (data == null)
                {
                    return Json("No plans are available");
                }
                else
                {
                    var tt = data.PlanAmount + data.OTIAmount;
                    Session["PlanName"] = data.PlanName;
                    Session["PlanDesc"] = data.PlanDesc;
                    Session["PlanAmount"] = data.PlanAmount; 
                    Session["Total"] = tt;
                    Session["PlanID"] = data.PlanID;
                    return View();

                }
            }

            catch (Exception ex)
            {
                return Json(ex.Message);
            }

        }

        //[HttpPost]
        //public ActionResult Loginforpayment(Login L)
        //{
        //    try
        //    {
        //        JobDbContext2 _db = new JobDbContext2();
        //        var result = _db.LoginDetail.SqlQuery(@"exec usp_loginforpayment 
        //        @username,@password",
        //            new SqlParameter("@username", L.Email),
        //            new SqlParameter("@password", L.password)).ToList<Login>();
        //        Login data = new Login();
        //        data = result.FirstOrDefault();

        //        if (data == null)
        //        {
        //            return Json("Please enter valid user Name password");
        //        }
        //        else
        //        {
        //            //return RedirectToAction("Dashboard", "Master");
        //            Session["username"] = data.Email;
        //            Session["RegId"] = data.RegistrationID;
        //            return Json("Login Sucessfull");

        //        }
        //    }

        //    catch (Exception ex)
        //    {
        //        return Json(ex.Message);
        //    }

        //}
         
        public ActionResult PlanRate(int id=0 )
        {
            JobDbContext2 _db = new JobDbContext2();
            var result = _db.PlanRate.SqlQuery(@"exec usp_GetPlanRate").ToList<PlanRate>();
            IEnumerable<PlanRate> data = result; 

            return Request.IsAjaxRequest()
                   ? (ActionResult)PartialView("PlanRate",data)
                   : View("PlanRate",data);
        }


        public List<SelectListItem> binddropdown(string action, int val = 0)
        {
            JobDbContext2 _db = new JobDbContext2();

            var res = _db.Database.SqlQuery<SelectListItem>("exec USP_BindDropDown @action , @val",
                   new SqlParameter("@action", action),
                    new SqlParameter("@val", val))
                   .ToList()
                   .AsEnumerable()
                   .Select(r => new SelectListItem
                   {
                       Text = r.Text.ToString(),
                       Value = r.Value.ToString(),
                       Selected = r.Value.Equals(Convert.ToString(val))
                   }).ToList();

            return res;
        }



        public JsonResult GetCity()
        {
            JobDbContext2 _db = new JobDbContext2();
            var lstItem = binddropdown("City", 0).Select(i => new { i.Value, i.Text }).ToList();
            //_spService.BindDropdown("PricingUser", "", "").Select(i => new { i.Value, i.Text }).ToList();
            return Json(lstItem, JsonRequestBehavior.AllowGet);
        }
        public ActionResult Profile()
        {
            JobDbContext2 _db = new JobDbContext2();
            var result = _db.RegistrationDetails.SqlQuery(@"exec uspGetRegDetails @RegistrationId",
                    new SqlParameter("@RegistrationId", Session["UserID"])).ToList<RegistrationDetails>();
            RegistrationDetails  data = result.FirstOrDefault();

            return Request.IsAjaxRequest()
                   ? (ActionResult)PartialView("Profile", data)
                   : View("Profile", data);
           
        }
    }
}