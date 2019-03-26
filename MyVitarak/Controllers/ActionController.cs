using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MyVitarak.Models;
using System.Data.SqlClient;
using PagedList;
using System.Data;
using System.IO;
using System.Data.OleDb;
using System.Xml;
using System.Web.UI;
using Newtonsoft.Json;
using System.Text;
using System.Security.Cryptography;
using System.Web.UI.WebControls;

namespace MyVitarak.Controllers
{
    public class ActionController : Controller
    {
        // GET: Action
        public ActionResult Index()
        {
            return View();
        }


        public ActionResult registrationtest()
        {
            return View();
        }

        public ActionResult PurchaseRates(string suppliername = "")
        {
            var user = Session["username"];
            if (user == null)
            {
                return RedirectToAction("Index", "Home");
            }

            using (JobDbContext context = new JobDbContext())
            {
                DataTable dt = new DataTable();
                DataSet ds = new DataSet();

                var conn = context.Database.Connection;
                var connectionState = conn.State;
                try
                {
                    if (connectionState != ConnectionState.Open) conn.Open();
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "SP_EXECUTESQL123";

                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@suppliername", suppliername));
                        using (var reader = cmd.ExecuteReader())
                        {
                            dt.Load(reader);
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
                TempData["Data"] = dt;
               
                return View(dt);
            }

        }


        public ActionResult PurchaseRatePartial(string suppliername = "")
        {

            using (JobDbContext context = new JobDbContext())
            {
                DataTable dt = new DataTable();
                DataSet ds = new DataSet();

                var conn = context.Database.Connection;
                var connectionState = conn.State;
                try
                {
                    if (connectionState != ConnectionState.Open) conn.Open();
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "SP_EXECUTESQL123";

                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@suppliername", suppliername));
                        using (var reader = cmd.ExecuteReader())
                        {
                            dt.Load(reader);
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
                TempData["Data"] = dt;
               
                return Request.IsAjaxRequest()
                      ? (ActionResult)PartialView("_PartialPurchaseRate", dt)
                      : View("_PartialPurchaseRate", dt);
            }

        }



        [HttpGet]
        [ActionName("Download")]
        public void Download()
        {
            
            DataTable emps = TempData["Data"] as DataTable;
            var gv = new GridView();
                gv.DataSource = emps;
                gv.DataBind();
                Response.ClearContent();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment; filename=ExcelSheet.xls");
                Response.ContentType = "application/ms-excel";
                Response.Charset = "";
                StringWriter objStringWriter = new StringWriter();
                HtmlTextWriter objHtmlTextWriter = new HtmlTextWriter(objStringWriter);
                gv.RenderControl(objHtmlTextWriter);
                Response.Output.Write(objStringWriter.ToString());
                Response.Flush();
                Response.End();
               
    }

        

        public ActionResult Purchase(DateTime? date)
        {
            var user = Session["username"];
            if (user == null)
            {
                return RedirectToAction("Index", "Home");
            }
            using (JobDbContext context = new JobDbContext())
            {
                DataTable dt = new DataTable();
                DataSet ds = new DataSet();

                if (date == null)
                {
                    date = DateTime.Now;
                }

                var conn = context.Database.Connection;
                var connectionState = conn.State;
                try
                {
                    if (connectionState != ConnectionState.Open) conn.Open();
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "SP_LoadPurchase";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@orderdate", date));
                        // dataAdapter.Fill(ds);
                        //using (var reader = cmd.ExecuteReader())
                        using (var reader = cmd.ExecuteReader())
                        {
                            dt.Load(reader);
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

                TempData["Data"] = dt;
                
                return View(dt);
            }

        }

        public ActionResult PurchasePartial(DateTime? date, string suppliername = "")
        {

            using (JobDbContext context = new JobDbContext())
            {
                DataTable dt = new DataTable();
                DataSet ds = new DataSet();

                if (date == null)
                {
                    date = DateTime.Now;
                }

                var conn = context.Database.Connection;
                var connectionState = conn.State;
                try
                {
                    if (connectionState != ConnectionState.Open) conn.Open();
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "SP_LoadPurchase";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@orderdate", date));
                        cmd.Parameters.Add(new SqlParameter("@suppliername", suppliername));
                        // dataAdapter.Fill(ds);
                        //using (var reader = cmd.ExecuteReader())
                        using (var reader = cmd.ExecuteReader())
                        {
                            dt.Load(reader);
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

                TempData["Data"] = dt;
               
                return Request.IsAjaxRequest()
                     ? (ActionResult)PartialView("_partialPurchaseGrid", dt)
                     : View("_partialPurchaseGrid", dt);
            }

        }

        public ActionResult Payementresponce()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Hash(string key = "Eoujo5i4", string salt = "HBStnJyXeZ", string txnid = "trasns1234", string amount = "100", string pinfo = "milk", string fname = "raghu", string email = "rmudgal23@gmail.com", string mobile = "8237175481", string udf5 = "")
        {
            byte[] hash;
            string postData = new System.IO.StreamReader(Request.InputStream).ReadToEnd();
            dynamic data = JsonConvert.DeserializeObject(postData);
            string d = key + "|" + txnid + "|" + amount + "|" + pinfo + "|" + fname + "|" + email + "|||||" + udf5 + "||||||" + salt;
            var datab = Encoding.UTF8.GetBytes(d);
            using (SHA512 shaM = new SHA512Managed())
            {
                hash = shaM.ComputeHash(datab);
            }


            string json = "{\"success\":\"" + GetStringFromHash(hash) + "\"}";
            Response.Clear();
            Response.ContentType = "application/json; charset=utf-8";
            Response.Write(json);
            Response.End();
            return View();
        }

        private static string GetStringFromHash(byte[] hash)
        {
            StringBuilder result = new StringBuilder();
            for (int i = 0; i < hash.Length; i++)
            {
                result.Append(hash[i].ToString("X2").ToLower());
            }
            return result.ToString();
        }

    }
}