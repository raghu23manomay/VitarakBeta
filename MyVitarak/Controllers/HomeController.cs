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

        public ActionResult Reg()
        {
            return View();
        }

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult EstimateCost()
        {
            return View();
        }


        public ActionResult Login()
        {
            return View();
        }

        public ActionResult _PartialLogin()
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
                @Email,@password",
                    new SqlParameter("@Email", L.Email),
                    new SqlParameter("@password", L.password)).ToList<Login>();
                Login data = new Login();
                data = result.FirstOrDefault();

                if (data == null)
                {
                    return Json("Please enter valid user Name password");
                }
                else
                {

                    Session["username"] = data.Email;
                    Session["RegId"] = data.RegistrationID;
                    Session["dbname"] = data.DbName;
                    GetDbSchemaStatus(data.RegistrationID);
                    return Json("Login Sucessfull");

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
                }
                catch (Exception ex)
                {
                    // error handling
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

        public ActionResult Registration()
        {
            return View();
        }

        [HttpPost]
        public ActionResult insert_Registration(Registration rs)
        {
            JobDbContext2 _db = new JobDbContext2();
            try
            {

                var res = _db.Database.ExecuteSqlCommand(@"exec [uspInsertRegistration] @mName,@mAddress,@mContactPerson,@mEmail,@mpassword,@mMobile,@mRegistrationDate",
                    new SqlParameter("@mName", rs.Name),
                    new SqlParameter("@mAddress", rs.Address),
                    new SqlParameter("@mContactPerson", rs.ContactPerson),
                    new SqlParameter("@mEmail", rs.Email),
                    new SqlParameter("@mpassword", rs.password),
                    new SqlParameter("@mMobile", rs.Mobile),
                    new SqlParameter("@mRegistrationDate", DateTime.Now)
                    );

                if (res == 0)
                {
                    return Json("Registration Fail");
                }
                else
                {
                    JobDbContext2 _db2 = new JobDbContext2();
                    var result = _db2.RegistrationDetails.SqlQuery(@"exec Usp_GetRegistrationdetailfortenant").ToList<RegistrationDetails>();
                    RegistrationDetails data = new RegistrationDetails();
                    data = result.FirstOrDefault();

                    Session["username"] = data.Email;
                    Session["RegId"] = data.RegistrationID;
                    return Json("Registration Sucessfull");
                }


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
                    if (connectionState != ConnectionState.Open) conn.Open();
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "[uspInsertTenant]";

                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@mRegistrationID", rs.RegistrationID));
                        cmd.Parameters.Add(new SqlParameter("@mSecurityCode", "SDGh1452"));
                        cmd.Parameters.Add(new SqlParameter("@misActive", true));
                        cmd.Parameters.Add(new SqlParameter("@misReadOnly", false));
                        cmd.Parameters.Add(new SqlParameter("@mDbName", "testdb"));
                        cmd.Parameters.Add(new SqlParameter("@isDbSchema", false));
                        cmd.ExecuteNonQuery();

                    }


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

                return Json("Application deployied sucessfull");
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
                var result = _db.MailCheck.SqlQuery(@"exec Usp_CheckMobileExistance 
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


        public ActionResult LoginForPayment(int? planid)
        {
            try
            {
                JobDbContext2 _db = new JobDbContext2();
                var result = _db.PlanePrice.SqlQuery(@"exec Usp_GetplanDetails 
                @plan_id",
                    new SqlParameter("@plan_id", planid)).ToList<PlanePrice>();
                PlanePrice data = new PlanePrice();
                data = result.FirstOrDefault();

                if (data == null)
                {
                    return Json("No plans are available");
                }
                else
                {
                    var tt = data.plan_rate + data.registration_rate;
                    Session["planename"] = data.plan_name;
                    Session["plandesc"] = data.plan_desc;
                    Session["regrate"] = data.registration_rate;
                    Session["planrate"] = data.plan_rate;
                    Session["total"] = tt;
                    Session["pid"] = planid;
                    return View();

                }
            }

            catch (Exception ex)
            {
                return Json(ex.Message);
            }

        }

        [HttpPost]
        public ActionResult Loginforpayment(Login L)
        {
            try
            {
                JobDbContext2 _db = new JobDbContext2();
                var result = _db.LoginDetail.SqlQuery(@"exec usp_loginforpayment 
                @username,@password",
                    new SqlParameter("@username", L.Email),
                    new SqlParameter("@password", L.password)).ToList<Login>();
                Login data = new Login();
                data = result.FirstOrDefault();

                if (data == null)
                {
                    return Json("Please enter valid user Name password");
                }
                else
                {
                    //return RedirectToAction("Dashboard", "Master");
                    Session["username"] = data.Email;
                    Session["RegId"] = data.RegistrationID;
                    return Json("Login Sucessfull");

                }
            }

            catch (Exception ex)
            {
                return Json(ex.Message);
            }

        }
    }
}