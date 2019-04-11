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
using System.Data.Entity;

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
                        GetDbSchemaStatus(data.TenantID);
                        return Json("Live");
                    }
                    else
                    {
                        Session["RegID"] = data.UserID;
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


        public void InsertDbschemaInUSerDatabase(Int64? regid, Int64? Tenantid)
        {
          
            using (JobDbContext context = new JobDbContext())
            {
                DbContextTransaction dbTran = context.Database.BeginTransaction();
             

                var conn = context.Database.Connection;
                var connectionState = conn.State;
               
                try
                {
                    var script = System.IO.File.ReadAllText(Server.MapPath(@"~/Scripts/DBSchema.sql"));
                    IEnumerable<string> commandStrings = Regex.Split(script, @"^\s*GO\s*$", RegexOptions.Multiline | RegexOptions.IgnoreCase);
           
                    if (connectionState != ConnectionState.Open) conn.Open();
                    foreach (string commandString in commandStrings)
                    {
                        if (commandString.Trim() != "")
                        {
                            var res = 0;
                            res = context.Database.ExecuteSqlCommand(commandString);
                        }
                    }
                    dbTran.Commit();
                    updateDbShemaStatus(regid, Tenantid);
                    
                }
                catch (Exception ex)
                {
                    dbTran.Rollback();
                    var messege = ex.Message;

                }
                finally
                {
                    if (connectionState != ConnectionState.Closed) conn.Close();
                }
            }
        }


        public void updateDbShemaStatus(Int64? regid, Int64? Tenantid)
        {
            JobDbContext2 _db2 = new JobDbContext2();
            var result = _db2.Database.ExecuteSqlCommand(@"exec Usp_UpdateDbScemaStatus @RegistrationID,@Tenantid",
             new SqlParameter("@RegistrationID", regid),
              new SqlParameter("@Tenantid", Tenantid));
        }


        public void GetDbSchemaStatus(Int64? TenantID)
        {
            JobDbContext2 _db2 = new JobDbContext2();
            var result = _db2.CheckDbSchema.SqlQuery(@"exec Usp_GetDbScemaStatus @TenantID",
                new SqlParameter("@TenantID", TenantID)).ToList<CheckDbSchema>();
            CheckDbSchema data = new CheckDbSchema();
            data = result.FirstOrDefault();

            if (data.isSchemaCreated == false)
            {
                InsertDbschemaInUSerDatabase(0, TenantID);
               // updateDbShemaStatus(0, TenantID);
            }

        }

        public ActionResult Registration(int? planid)
        {
            try
            {
                if (planid > 0)
                { 
                    if(Session["RegID"]!=null)
                    {
                        Response.Redirect("PaymentCheckout",false);
                    }
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
                var outParam = new SqlParameter
                {
                    ParameterName = "@Param",
                    DbType = System.Data.DbType.Int64,
                    Size = 20,
                    Direction = System.Data.ParameterDirection.Output
                };
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
                    @pPasssword, @Param out",
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
                    new SqlParameter("@pPasssword", rs.password),
                    outParam  
                    );
                              
                Session["CName"] = rs.Name;
                Session["BusinessName"] = rs.BusinessName.Replace(" ", "_"); ;
                Session["ContactPerson"] = rs.ContactPerson;
                Session["Address"] = rs.Address;
                Session["Email"] = rs.Email;
                Session["Mobile"] = rs.Mobile;
                Session["UserName"] = rs.UserName; 
                 Session["RegID"] = outParam.Value;
                 
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
                        cmd.Parameters.Add(new SqlParameter("@pName", rs.Name));
                        cmd.Parameters.Add(new SqlParameter("@pDbname", rs.DbName));
                        cmd.Parameters.Add(new SqlParameter("@pAddress", rs.Address));
                        cmd.Parameters.Add(new SqlParameter("@pMobile", rs.Mobile));
                        cmd.Parameters.Add(new SqlParameter("@pContactPerson", rs.ContactPerson));
                        cmd.Parameters.Add(new SqlParameter("@pSecurityCode",SercurityCode));
                        cmd.Parameters.Add(new SqlParameter("@pisActive", true));
                        cmd.Parameters.Add(new SqlParameter("@pisReadOnly",false));
                        cmd.Parameters.Add(new SqlParameter("@pRegID",Convert.ToInt64(Session["RegID"].ToString())));
                        cmd.Parameters.Add(new SqlParameter("@pPlanId", rs.PlanID));
                        cmd.Parameters.Add(new SqlParameter("@pAmount", rs.PaidAmount));

                        cmd.ExecuteNonQuery();
                    }
                    InsertDbschemaInUSerDatabase(Convert.ToInt64(Session["RegID"].ToString()),0);
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
        public ActionResult Profile1()
        {
            JobDbContext2 _db = new JobDbContext2();
            var result = _db.RegistrationDetails.SqlQuery(@"exec uspGetRegDetails @RegistrationId",
                    new SqlParameter("@RegistrationId", Session["RegID"])).ToList<RegistrationDetails>();
            RegistrationDetails  data = result.FirstOrDefault();

            Session["CName"] = data.Name;
            Session["BusinessName"] = data.BusinessName.Replace(" ", "_"); ;
            Session["ContactPerson"] = data.ContactPerson;
            Session["Address"] = data.Address;
            Session["Mobile"] = data.Mobile;
            Session["UserName"] = data.UserName;
            return Request.IsAjaxRequest()
                   ? (ActionResult)PartialView("Profile", data)
                   : View("Profile", data);
           
        }


       
    }
}