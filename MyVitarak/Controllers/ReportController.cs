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

namespace MyVitarak.Controllers
{
    public class ReportController : Controller
    {
        // GET: Report
        public ActionResult Index()
        {
            var user = Session["username"];
            if (user == null)
            {
                return RedirectToAction("Index", "Home");
            }
            return View();
        }


        public List<SelectListItem> binddropdown(string action, int val = 0)
        {
            JobDbContext _db = new JobDbContext();

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


        public ActionResult RptCustomer_Ladger(int? custid,DateTime? date)
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
                        cmd.CommandText = "Rpt_CustomerWiseQtyAmount";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@pDate", custid));
                        cmd.Parameters.Add(new SqlParameter("@pCustomerID",date));
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
                DownloadExcelForCustomerLedger();

                ViewData["CustomerList"] = binddropdown("CustomerList", 0);
                return View(dt);
            }

        }

        public ActionResult LoadCustomerLedger(int? custid, DateTime? date)
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
                        cmd.CommandText = "Rpt_CustomerWiseQtyAmount";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@pDate", date));
                        cmd.Parameters.Add(new SqlParameter("@pCustomerID", custid));
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
                DownloadExcelForCustomerLedger();

                //ViewData["CustomerList"] = binddropdown("CustomerList", 0);
                return Request.IsAjaxRequest()
                     ? (ActionResult)PartialView("_partialCustomerLedgerGrid", dt)
                     : View("_partialCustomerLedgerGrid", dt);
            }
        }

        [HttpGet]
        [ActionName("DownloadExcelForCustomerLedger")]
        public void DownloadExcelForCustomerLedger()
        {
            DataTable emps = TempData["Data"] as DataTable;
            var grid = new System.Web.UI.WebControls.GridView();
            grid.DataSource = emps;
            grid.DataBind();
            Response.ClearContent();
            Response.Buffer = true;
            Response.Charset = "";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);
            grid.RenderControl(htw);
            string filePath = Server.MapPath("~/CustomerLedgerXLSheet/" + 1 + "/generated/");

            bool isExists = System.IO.Directory.Exists(filePath);
            if (!isExists) { System.IO.Directory.CreateDirectory(filePath); }

            string fileName = "CustomerLedgerReport" + ".xls";
            // Write the rendered content to a file.
            string renderedGridView = sw.ToString();
            System.IO.File.WriteAllText(filePath + fileName, renderedGridView);

        }

        public ActionResult RptSupplier_Ladger(int? vendid, DateTime? date)
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
                        cmd.CommandText = "uspVendorLedgerMonthly";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@pVendorID", vendid));
                        cmd.Parameters.Add(new SqlParameter("@mMonthNo", date.Value.Month));
                        cmd.Parameters.Add(new SqlParameter("@mYear", date.Value.Year));
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
                DownloadExcelForSupplierLedger();

                ViewData["VendorList"] = binddropdown("VendorList", 0);
                return View(dt);
            }

        }

        public ActionResult LoadSupplierLedger(int? vendid, DateTime? date)
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
                        cmd.CommandText = "uspVendorLedgerMonthly";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@pVendorID", vendid));
                        cmd.Parameters.Add(new SqlParameter("@mMonthNo", date.Value.Month));
                        cmd.Parameters.Add(new SqlParameter("@mYear", date.Value.Year));
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
                DownloadExcelForSupplierLedger();

                //ViewData["CustomerList"] = binddropdown("CustomerList", 0);
                return Request.IsAjaxRequest()
                     ? (ActionResult)PartialView("_partialSupplierLedgerGrid", dt)
                     : View("_partialSupplierLedgerGrid", dt);
            }
        }

        [HttpGet]
        [ActionName("DownloadExcelForSupplierLedger")]
        public void DownloadExcelForSupplierLedger()
        {
            DataTable emps = TempData["Data"] as DataTable;
            var grid = new System.Web.UI.WebControls.GridView();
            grid.DataSource = emps;
            grid.DataBind();
            Response.ClearContent();
            Response.Buffer = true;
            Response.Charset = "";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);
            grid.RenderControl(htw);
            string filePath = Server.MapPath("~/SupplierLedgerXLSheet/" + 1 + "/generated/");

            bool isExists = System.IO.Directory.Exists(filePath);
            if (!isExists) { System.IO.Directory.CreateDirectory(filePath); }

            string fileName = "SupplierLedgerReport" + ".xls";
            // Write the rendered content to a file.
            string renderedGridView = sw.ToString();
            System.IO.File.WriteAllText(filePath + fileName, renderedGridView);

        }

    }
}