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
using System.Web.UI.WebControls;

namespace MyVitarak.Controllers
{
    public class MasterController : Controller
    {

        public ActionResult Dashboard()
        {
            var user = Session["username"];

            if (user == null)
            {
                return RedirectToAction("Index", "Home");
            }
            return View();
        }
        
        public ActionResult ColumnChart()
        {
            JobDbContext _db = new JobDbContext(); 

            IEnumerable<Chart> result = _db.Chart.SqlQuery(@"exec GetSalesChart").ToList<Chart>(); 
           
            return Request.IsAjaxRequest()
                    ? (ActionResult)PartialView("ColumnChart", result)
                    : View("ColumnChart", result);

        }
        // GET: Master
        public ActionResult ProductList(int? page)
        {
            var user = Session["username"];
            if (user == null)
            {
                return RedirectToAction("Index", "Home");
            }
            StaticPagedList<ProductDetails> itemsAsIPagedList;
            itemsAsIPagedList = ProductGridList(page);

            Session["MasterName"] = "ProductMaster";
            return Request.IsAjaxRequest()
                    ? (ActionResult)PartialView("ProductList", itemsAsIPagedList)
                    : View("ProductList", itemsAsIPagedList);
        }

        //================================== Fill Product Grid Code ===========================================

        public StaticPagedList<ProductDetails> ProductGridList(int? page, string pname = "")
        {

            JobDbContext _db = new JobDbContext();
            // _db.Database.Connection.ConnectionString = "Data Source=103.67.236.131,4433;Initial Catalog="+Session["dbname"].ToString()+";User ID=sa;Password=Sunil@123";
            var pageIndex = (page ?? 1);
            const int pageSize = 11;
            int totalCount = 11;
            ProductDetails Ulist = new ProductDetails();

            IEnumerable<ProductDetails> result = _db.ProductDetails.SqlQuery(@"exec GetProductList
                   @pPageIndex, @pPageSize,@pname",
               new SqlParameter("@pPageIndex", pageIndex),
               new SqlParameter("@pPageSize", pageSize),
               new SqlParameter("@pname", pname)

               ).ToList<ProductDetails>();

            totalCount = 0;
            if (result.Count() > 0)
            {
                totalCount = Convert.ToInt32(result.FirstOrDefault().TotalRows);
            }
            var itemsAsIPagedList = new StaticPagedList<ProductDetails>(result, pageIndex, pageSize, totalCount);
            return itemsAsIPagedList;

        }

        public ActionResult LoadDataForProduct(int? page, string pname = "")
        {
            StaticPagedList<ProductDetails> itemsAsIPagedList;
            itemsAsIPagedList = ProductGridList(page, pname);

            return Request.IsAjaxRequest()
                    ? (ActionResult)PartialView("ProductGrid", itemsAsIPagedList)
                    : View("ProductGrid", itemsAsIPagedList);
        }



        [HttpPost]
        [ValidateInput(false)]
        public ActionResult SaveProductExcelData(List<ProductMaster> SaveLaneRate)
        {
            try
            {
                JobDbContext _db = new JobDbContext();

                if (SaveLaneRate.Count > 0)
                {
                    DataTable dt = new DataTable();

                    dt.Columns.Add("ProductID", typeof(int));
                    dt.Columns.Add("Product", typeof(string));
                    dt.Columns.Add("ProductBrandID", typeof(int));
                    dt.Columns.Add("CreateDate", typeof(DateTime));
                    dt.Columns.Add("CreatedBy", typeof(int));
                    dt.Columns.Add("LastUpdatedDate", typeof(DateTime));
                    dt.Columns.Add("LastUpdatedBy", typeof(int));
                    dt.Columns.Add("isActive", typeof(int));
                    dt.Columns.Add("CrateSize", typeof(int));
                    dt.Columns.Add("GST", typeof(decimal));

                    foreach (var item in SaveLaneRate)
                    {
                        DataRow dr = dt.NewRow();
                        dr["ProductID"] = 1;
                        dr["Product"] = item.Product;
                        dr["ProductBrandID"] = item.ProductBrandID;
                        dr["CreateDate"] = DateTime.Now;
                        dr["CreatedBy"] = 1;
                        dr["LastUpdatedDate"] = DateTime.Now;
                        dr["LastUpdatedBy"] = 1;
                        dr["isActive"] = 1;
                        dr["CrateSize"] = item.CrateSize;
                        dr["GST"] = item.GST;

                        string pbid = item.ProductBrandID.ToString();
                        Int64 Num = 0;
                        bool isNum = Int64.TryParse(pbid, out Num);

                        string caret = item.CrateSize.ToString();
                        Int64 CaretNum = 0;
                        bool CaretisNum = Int64.TryParse(caret, out CaretNum);

                        if (item.Product == null)
                        {
                            return Json("Enter Product Name");

                        }
                        else if (item.ProductBrandID == 0 || isNum == false)
                        {
                            return Json("Enter Sequence Number In Numaric");
                        }
                        else if (item.CrateSize == 0 || CaretisNum == false)
                        {
                            return Json("Enter Caret Size In Numaric ");
                        }
                        else
                        {
                            dt.Rows.Add(dr);
                        }
                    }

                    SqlParameter tvpParam = new SqlParameter();
                    tvpParam.ParameterName = "@ProductParameters";
                    tvpParam.SqlDbType = System.Data.SqlDbType.Structured;
                    tvpParam.Value = dt;
                    tvpParam.TypeName = "UT_ProductMaster";

                    var res = _db.Database.ExecuteSqlCommand(@"exec USP_InsertExcelData_ProductMaster @ProductParameters",
                     tvpParam);

                }
                // return Request.IsAjaxRequest() ? (ActionResult)PartialView("ImportLaneRate")
                //: View();
                return Request.IsAjaxRequest() ? (ActionResult)Json("Excel Imported Sucessfully")
                : Json("Excel Imported Sucessfully");
            }
            catch (Exception e)

            {
                var messege = e.Message;
                return Request.IsAjaxRequest() ? (ActionResult)Json(messege)
               : Json(messege);
            }

        }

        [HttpGet]
        public ActionResult Add_Product()
        {
            return View();
        }

        [HttpPost]
        public ActionResult AddProduct(ProductMaster pm)
        {
            JobDbContext _db = new JobDbContext();
            try
            {

                var res = _db.Database.ExecuteSqlCommand(@"exec [UC_InsertProductMast] @Product,@ProductBrandID,@StockCount,@SalePrice,@CrateSize,@GST",
                    new SqlParameter("@Product", pm.Product),
                    new SqlParameter("@ProductBrandID", pm.ProductBrandID),
                    new SqlParameter("@StockCount", 1),
                    new SqlParameter("@SalePrice", pm.SalePrice == null ? (object)DBNull.Value : pm.SalePrice),
                    new SqlParameter("@CrateSize", pm.CrateSize),
                    new SqlParameter("@GST", pm.GST));

                if (res == 0)
                {
                    return Json("Product Already Exist");
                }
                else
                {
                    return Json("Data Added Sucessfully");
                }


            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }

        }


        //========================================== Edit Product ================================================

        public ActionResult EditProduct()
        {
            return View();

        }

        public ActionResult FetchProductForUpdate(int? ProductID)
        {
            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.ProductMaster.SqlQuery(@"exec [UC_FetchDataForUpdate_ProductMaster] @ProductID",
                    new SqlParameter("@ProductID", ProductID)
                   ).ToList<ProductMaster>();

                ProductMaster rs = new ProductMaster();
                rs = res.FirstOrDefault();
                return View("EditProduct", rs);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }

        }

        [HttpPost]
        public ActionResult Updateproduct(ProductMaster rm)
        {

            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec UC_UpdateProductMast @ProductID ,@Product ,@ProductBrandID ,@StockCount ,@SalePrice,@CrateSize ,@GST",
                    new SqlParameter("@ProductID", rm.ProductID),
                    new SqlParameter("@Product", rm.Product),
                    new SqlParameter("@ProductBrandID", rm.ProductBrandID),
                    new SqlParameter("@StockCount", rm.StockCount),
                    new SqlParameter("@SalePrice", rm.SalePrice == null ? (object)DBNull.Value : rm.SalePrice),
                    new SqlParameter("@CrateSize", rm.CrateSize),
                    new SqlParameter("@GST", rm.GST));

                return Json("Data Updated Sucessfully");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }

        }


        [HttpPost]
        public ActionResult DeleteProduct(ProductMaster rm)
        {

            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec UC_DeleteProductMast @ProductID",
                    new SqlParameter("@ProductID", rm.ProductID));

                return Json("Data Deleted Sucessfully");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }

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
        public JsonResult GetArea()
        {
            JobDbContext _db = new JobDbContext();
            var lstItem = binddropdown("Area", 0).Select(i => new { i.Value, i.Text }).ToList();
            return Json(lstItem, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetEmployee()
        {
            JobDbContext _db = new JobDbContext();
            var lstItem = binddropdown("Employee", 0).Select(i => new { i.Value, i.Text }).ToList();
            return Json(lstItem, JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetVehicle()
        {
            JobDbContext _db = new JobDbContext();
            var lstItem = binddropdown("Vehicle", 0).Select(i => new { i.Value, i.Text }).ToList();
            return Json(lstItem, JsonRequestBehavior.AllowGet);
        }

        // GET: Master
        public ActionResult EmployeeIndex()
        {
            return View();
        }
        public ActionResult Home()
        {
            return View();
        }

        public ActionResult LoadData(int? page, String Name)
        {
            StaticPagedList<EmployeeDetails> itemsAsIPagedList;
            itemsAsIPagedList = GridList(page, Name);

            Session["MasterName"] = "EmployeeMaster";
            return Request.IsAjaxRequest()
                    ? (ActionResult)PartialView("Partial_EmployeeGridList", itemsAsIPagedList)
                    : View("Partial_EmployeeGridList", itemsAsIPagedList);
        }

        public StaticPagedList<EmployeeDetails> GridList(int? page, String Name)
        {

            JobDbContext _db = new JobDbContext();
            var pageIndex = (page ?? 1);
            const int pageSize = 8;
            int totalCount = 8;
            EmployeeDetails Ulist = new EmployeeDetails();
            if (Name == null) Name = "";

            IEnumerable<EmployeeDetails> result = _db.EmployeeDetails.SqlQuery(@"exec GetEmployeeList
                   @pPageIndex, @pPageSize,@pName",
               new SqlParameter("@pPageIndex", pageIndex),
               new SqlParameter("@pPageSize", pageSize),
               new SqlParameter("@pName", Name)

               ).ToList<EmployeeDetails>();

            totalCount = 0;
            if (result.Count() > 0)
            {
                totalCount = Convert.ToInt32(result.FirstOrDefault().TotalRows);
            }
            var itemsAsIPagedList = new StaticPagedList<EmployeeDetails>(result, pageIndex, pageSize, totalCount);
            return itemsAsIPagedList;



        }


        /************************************************Add Employee************************************************************/

        [HttpGet]
        public ActionResult Add_Employee()
        {
            ViewData["Area"] = binddropdown("Area", 0);

            return View();
        }
        public ActionResult Add_Customer1()
        {
            ViewData["Area"] = binddropdown("Area", 0);

            return View();
        }
        

        [HttpPost]
        public ActionResult AddEmployee(Employee pm)
        {
            JobDbContext _db = new JobDbContext();
            try
            {

                var res = _db.Database.ExecuteSqlCommand(@"exec uspInsertEmployee @EmployeeName,@Address,@AreaID,@Mobile",
                    new SqlParameter("@EmployeeName", pm.EmployeeName),
                    new SqlParameter("@Address", pm.Address),
                    new SqlParameter("@AreaID", pm.AreaID),
                    new SqlParameter("@Mobile", pm.Mobile));

                return Json("Data Added Sucessfully");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }

        }



        [HttpPost]
        public ActionResult DeleteEmployee(EmployeeList md)
        {

            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec [UC_DeleteEmployeeMast] @EmployeeID",
                    new SqlParameter("@EmployeeID", md.EmployeeID));

                return Json("Employee Deleted Sucessfully");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }

        }


        public ActionResult EmployeeList(int? page, String Name)
        {
            var user = Session["username"];
            if (user == null)
            {
                return RedirectToAction("Index", "Home");
            }

            StaticPagedList<EmployeeDetails> itemsAsIPagedList;
            itemsAsIPagedList = EmployeeGridList(page, Name);

            Session["MasterName"] = "EmployeeMaster";
            return Request.IsAjaxRequest()
                    ? (ActionResult)PartialView("EmployeeList", itemsAsIPagedList)
                    : View("EmployeeList", itemsAsIPagedList);
        }

        public StaticPagedList<EmployeeDetails> EmployeeGridList(int? page, String Name)
        {

            JobDbContext _db = new JobDbContext();
            var pageIndex = (page ?? 1);
            const int pageSize = 11;
            int totalCount = 8;
            EmployeeDetails Ulist = new EmployeeDetails();
            if (Name == null) Name = "";

            IEnumerable<EmployeeDetails> result = _db.EmployeeDetails.SqlQuery(@"exec GetEmployeeList
                   @pPageIndex, @pPageSize,@pName",
               new SqlParameter("@pPageIndex", pageIndex),
               new SqlParameter("@pPageSize", pageSize),
               new SqlParameter("@pName", Name)

               ).ToList<EmployeeDetails>();

            totalCount = 0;
            if (result.Count() > 0)
            {
                totalCount = Convert.ToInt32(result.FirstOrDefault().TotalRows);
            }
            var itemsAsIPagedList = new StaticPagedList<EmployeeDetails>(result, pageIndex, pageSize, totalCount);
            return itemsAsIPagedList;
        
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult SaveEmployeeExcelData(List<Employee> SaveEmployeeData)
        {
            try
            {
                JobDbContext _db = new JobDbContext();

                if (SaveEmployeeData.Count > 0)
                {
                    DataTable dt = new DataTable();

                    dt.Columns.Add("EmployeeID", typeof(int));
                    dt.Columns.Add("EmployeeName", typeof(string));
                    dt.Columns.Add("Address", typeof(string));
                    dt.Columns.Add("AreaID", typeof(int));
                    dt.Columns.Add("Mobile", typeof(string));
                    dt.Columns.Add("UserId", typeof(int));

                    foreach (var item in SaveEmployeeData)
                    {
                        DataRow dr = dt.NewRow();
                        dr["EmployeeID"] = 1;
                        dr["EmployeeName"] = item.EmployeeName;
                        dr["Address"] = item.Address;
                        dr["AreaID"] = 2;
                        dr["Mobile"] = item.Mobile;
                        dr["UserId"] = 1;

                        if (item.EmployeeName == null)
                        {
                            return Json("Employee Name Missing");
                        }
                        if (item.Address == null)
                        {
                            return Json("Address missing");
                        }
                        if (item.AreaID == 0)
                        {
                            return Json("Area Id Missing");
                        }
                        if (item.Mobile == null)
                        {
                            return Json("Mobile number Missing");
                        }

                        if (item.EmployeeName != null)
                        {
                            dt.Rows.Add(dr);
                        }
                    }

                    SqlParameter tvpParam = new SqlParameter();
                    tvpParam.ParameterName = "@EmployeeParameters";
                    tvpParam.SqlDbType = System.Data.SqlDbType.Structured;
                    tvpParam.Value = dt;
                    tvpParam.TypeName = "UT_EmployeeMasters";

                    var res = _db.Database.ExecuteSqlCommand(@"exec USP_InsertExcelData_EmployeeMaster @EmployeeParameters",
                    tvpParam);

                }
                // return Request.IsAjaxRequest() ? (ActionResult)PartialView("ImportLaneRate")
                //: View();
                return Request.IsAjaxRequest() ? (ActionResult)Json("Excel Imported Sucessfully")
                : Json("Excel Imported Sucessfully");
            }
            catch (Exception e)

            {
                var messege = e.Message;
                return Request.IsAjaxRequest() ? (ActionResult)Json(messege)
                : Json(messege);
            }

        }



        /*******************************************EditEmployee*****************************************************/

        public ActionResult EditEmployee(int EmployeeID)
        {
            JobDbContext _db = new JobDbContext();
            EmployeeList md = new EmployeeList();
            ViewData["Area"] = binddropdown("Area", 0);
            var result = _db.EmployeeList.SqlQuery(@"exec uspSelectEmployeeMastByEmployeeID @EmployeeID
                ",
                new SqlParameter("@EmployeeID", EmployeeID)).ToList<EmployeeList>();
            md = result.FirstOrDefault();

            return Request.IsAjaxRequest()
               ? (ActionResult)PartialView("EditEmployee", md)
               : View("EditEmployee", md);
        }

        [HttpPost]
        public ActionResult UpdateEmployee(Employee up)
        {
            JobDbContext _db = new JobDbContext();

            try
            {
                var result = _db.Database.ExecuteSqlCommand(@"exec uspUpdateEmployee @EmployeeID,@EmployeeName,@Address,@AreaID,@Mobile",
                    new SqlParameter("@EmployeeID", up.EmployeeID),
                     new SqlParameter("@EmployeeName", up.EmployeeName),
                    new SqlParameter("@Address", up.Address),
                    new SqlParameter("@AreaID", up.AreaID),
                    new SqlParameter("@Mobile", up.Mobile));
                return Json("Data Updated Sucessfully");
            }
            catch (Exception ex)
            {
                string message = string.Format("<b>Message:</b> {0}<br /><br />", ex.Message);
                return Json(up, JsonRequestBehavior.AllowGet);

            }

        }



        /*******************************************EditEmployee*****************************************************/

        public ActionResult LoadVehicle(int? page, String Name)
        {
            StaticPagedList<VehicalDetails> itemsAsIPagedList;
            itemsAsIPagedList = GridListVehicle(page, Name);
            return Request.IsAjaxRequest()
                    ? (ActionResult)PartialView("Partial_VehicalGridList", itemsAsIPagedList)
                    : View("Partial_VehicalGridList", itemsAsIPagedList);
        }

        public StaticPagedList<VehicalDetails> GridListVehicle(int? page, String Name)
        {

            JobDbContext _db = new JobDbContext();
            var pageIndex = (page ?? 1);
            const int pageSize = 8;
            int totalCount = 8;
            VehicalDetails Ulist = new VehicalDetails();
            if (Name == null) Name = "";

            IEnumerable<VehicalDetails> result = _db.VehicalDetails.SqlQuery(@"exec GetVehicalList
                   @pPageIndex, @pPageSize,@pVehicle",
               new SqlParameter("@pPageIndex", pageIndex),
               new SqlParameter("@pPageSize", pageSize),
               new SqlParameter("@pVehicle", Name)

               ).ToList<VehicalDetails>();

            totalCount = 0;
            if (result.Count() > 0)
            {
                totalCount = Convert.ToInt32(result.FirstOrDefault().TotalRows);
            }
            var itemsAsIPagedList = new StaticPagedList<VehicalDetails>(result, pageIndex, pageSize, totalCount);
            return itemsAsIPagedList;



        }


        /************************************************Add Vehical************************************************************/

        public ActionResult Add_Vehical()
        {
            return View();
        }

        [HttpPost]
        public ActionResult AddVehical(Vehical pm)
        {
            JobDbContext _db = new JobDbContext();
            try
            {

                var res = _db.Database.ExecuteSqlCommand(@"exec UC_VehicleMast_Insert @Transport,@Owner,@Address,@Mobile,@VechicleNo,@RatePerTrip,@Marathi,@PrintOrder",
                    new SqlParameter("@Transport", pm.Transport),
                    new SqlParameter("@Owner", pm.Owner),
                    new SqlParameter("@Address", pm.Address),
                    new SqlParameter("@Mobile", pm.Mobile),
                    new SqlParameter("@VechicleNo", pm.VechicleNo),
                    new SqlParameter("@RatePerTrip", pm.RatePerTrip),
                    new SqlParameter("@Marathi", pm.Marathi),
                    new SqlParameter("@PrintOrder", pm.PrintOrder)
                    );

                return Json("Data Added Sucessfully");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }
        }

        public ActionResult IndexForVehicalMaster(int? page)
        {

            var user = Session["username"];
            if (user == null)
            {
                return RedirectToAction("Index", "Home");
            }

            StaticPagedList<VehicalDetails> itemsAsIPagedList;
            itemsAsIPagedList = VehicalGridList(page);

            Session["MasterName"] = "VehicalMaster";
            return Request.IsAjaxRequest()
                    ? (ActionResult)PartialView("IndexForVehicalMaster", itemsAsIPagedList)
                    : View("IndexForVehicalMaster", itemsAsIPagedList);
        }

        public StaticPagedList<VehicalDetails> VehicalGridList(int? page)
        {

            JobDbContext _db = new JobDbContext();
            var pageIndex = (page ?? 1);
            const int pageSize = 8;
            int totalCount = 8;
            VehicalDetails Ulist = new VehicalDetails();

            IEnumerable<VehicalDetails> result = _db.VehicalDetails.SqlQuery(@"exec GetVehicalList
                   @pPageIndex, @pPageSize",
               new SqlParameter("@pPageIndex", pageIndex),
               new SqlParameter("@pPageSize", pageSize)

               ).ToList<VehicalDetails>();

            totalCount = 0;
            if (result.Count() > 0)
            {
                totalCount = Convert.ToInt32(result.FirstOrDefault().TotalRows);
            }
            var itemsAsIPagedList = new StaticPagedList<VehicalDetails>(result, pageIndex, pageSize, totalCount);
            return itemsAsIPagedList;



        }
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult SaveVehicalExcelData(List<Vehical> SaveVehicalData)
        {
            try
            {
                JobDbContext _db = new JobDbContext();

                if (SaveVehicalData.Count > 0)
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("VechicleID", typeof(int));
                    dt.Columns.Add("Transport", typeof(string));
                    dt.Columns.Add("Owner", typeof(string));
                    dt.Columns.Add("Address", typeof(string));
                    dt.Columns.Add("Mobile", typeof(string));
                    dt.Columns.Add("VechicleNo", typeof(string));
                    dt.Columns.Add("RatePerTrip", typeof(decimal));
                    dt.Columns.Add("Marathi", typeof(string));
                    dt.Columns.Add("PrintOrder", typeof(int));
                    foreach (var item in SaveVehicalData)
                    {
                        DataRow dr = dt.NewRow();
                        dr["VechicleID"] = 1;
                        dr["Transport"] = item.Transport;
                        dr["Owner"] = item.Owner;
                        dr["Address"] = item.Address;
                        dr["Mobile"] = item.Mobile;
                        dr["VechicleNo"] = item.VechicleNo;
                        dr["RatePerTrip"] = item.RatePerTrip;
                        dr["Marathi"] = item.Marathi;
                        dr["PrintOrder"] = item.PrintOrder;
                        if (item.Transport != null)
                        {
                            dt.Rows.Add(dr);
                        }
                    }

                    SqlParameter tvpParam = new SqlParameter();
                    tvpParam.ParameterName = "@VehicalParameters";
                    tvpParam.SqlDbType = System.Data.SqlDbType.Structured;
                    tvpParam.Value = dt;
                    tvpParam.TypeName = "UT_VehicalMaster";

                    var res = _db.Database.ExecuteSqlCommand(@"exec USP_InsertExcelData_VehicalMaster @VehicalParameters",
                     tvpParam);

                }
                // return Request.IsAjaxRequest() ? (ActionResult)PartialView("ImportLaneRate")
                //: View();
                return Request.IsAjaxRequest() ? (ActionResult)Json("Excel Imported Sucessfully")
                : Json("Excel Imported Sucessfully");
            }
            catch (Exception e)

            {
                var messege = e.Message;
                return Request.IsAjaxRequest() ? (ActionResult)Json(messege)
               : Json(messege);
            }

        }

        /*******************************************EditEmployee*****************************************************/

        public ActionResult EditVehical(int VechicleID)
        {
            JobDbContext _db = new JobDbContext();
            Vehical md = new Vehical();
            var result = _db.Vehical.SqlQuery(@"exec UC_VehicleMast_GetByPK @VechicleID
                ",
                new SqlParameter("@VechicleID", VechicleID)).ToList<Vehical>();
            md = result.FirstOrDefault();
            return Request.IsAjaxRequest()
               ? (ActionResult)PartialView("EditVehical", md)
               : View("EditVehical", md);
        }

        [HttpPost]
        public ActionResult UpdateVehical(Vehical up)
        {
            JobDbContext _db = new JobDbContext();

            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec UC_VehicleMast_UpdateByPK @VechicleID, @Transport,@Owner,@Address,@Mobile,@VechicleNo,@RatePerTrip,@Marathi,@PrintOrder",
                     new SqlParameter("@VechicleID", up.VechicleID),
                    new SqlParameter("@Transport", up.Transport),
                    new SqlParameter("@Owner", up.Owner),
                    new SqlParameter("@Address", up.Address),
                    new SqlParameter("@Mobile", up.Mobile),
                    new SqlParameter("@VechicleNo", up.VechicleNo),
                    new SqlParameter("@RatePerTrip", up.RatePerTrip),
                    new SqlParameter("@Marathi", up.Marathi),
                    new SqlParameter("@PrintOrder", up.PrintOrder)
                    );

                return Json("Data Updated Sucessfully");

            }
            catch (Exception ex)
            {
                string message = string.Format("<b>Message:</b> {0}<br /><br />", ex.Message);
                return Json(up, JsonRequestBehavior.AllowGet);

            }

        }


        [HttpPost]
        public ActionResult DeleteVehicle(int? VechicleID)
        {

            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec UC_DeleteVehicleMast_ByPk @VechicleID",
                    new SqlParameter("@VechicleID", VechicleID));

                return Json("Data Deleted Sucessfully");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }


        }

        public ActionResult OpeningBalanceIndex(int? page)
        {
            var user = Session["username"];
            if (user == null)
            {
                return RedirectToAction("Index", "Home");
            }
            StaticPagedList<OpeningBalanceDeatils> itemsAsIPagedList;
            itemsAsIPagedList = OpeningBalanceList(page);

            Session["MasterName"] = "OpeningBalance";
            return Request.IsAjaxRequest()
                    ? (ActionResult)PartialView("OpeningBalanceIndex", itemsAsIPagedList)
                    : View("OpeningBalanceIndex", itemsAsIPagedList);
        }

        //================================== Fill Product Grid Code ===========================================

        public StaticPagedList<OpeningBalanceDeatils> OpeningBalanceList(int? page, string pname = "")
        {

            JobDbContext _db = new JobDbContext();
            var pageIndex = (page ?? 1);
            const int pageSize = 11;
            int totalCount = 5;
            OpeningBalanceDeatils Ulist = new OpeningBalanceDeatils();

            IEnumerable<OpeningBalanceDeatils> result = _db.OpeningBalanceDeatils.SqlQuery(@"exec OpeningBalanceList
                   @pPageIndex, @pPageSize,@pname",
               new SqlParameter("@pPageIndex", pageIndex),
               new SqlParameter("@pPageSize", pageSize),
               new SqlParameter("@pname", pname)

               ).ToList<OpeningBalanceDeatils>();

            totalCount = 0;
            if (result.Count() > 0)
            {
                totalCount = Convert.ToInt32(result.FirstOrDefault().TotalRows);
            }
            var itemsAsIPagedList = new StaticPagedList<OpeningBalanceDeatils>(result, pageIndex, pageSize, totalCount);
            return itemsAsIPagedList;

        }



        public ActionResult LoadOpeningBalance(int? page, String Name)
        {
            var user = Session["username"];
            if (user == null)
            {
                return RedirectToAction("Index", "Home");
            }
            StaticPagedList<OpeningBalanceDeatils> itemsAsIPagedList;
            itemsAsIPagedList = GridOpeningBalanceList(page, Name);
            return Request.IsAjaxRequest()
                    ? (ActionResult)PartialView("Partial_OpeningBalanceList", itemsAsIPagedList)
                    : View("Partial_OpeningBalanceList", itemsAsIPagedList);
        }

        public StaticPagedList<OpeningBalanceDeatils> GridOpeningBalanceList(int? page, String Name)
        {

            JobDbContext _db = new JobDbContext();
            var pageIndex = (page ?? 1);
            const int pageSize = 11;
            int totalCount = 8;
            OpeningBalanceDeatils Ulist = new OpeningBalanceDeatils();
            if (Name == null) Name = "";

            IEnumerable<OpeningBalanceDeatils> result = _db.OpeningBalanceDeatils.SqlQuery(@"exec OpeningBalanceList
                   @pPageIndex, @pPageSize,@pName",
               new SqlParameter("@pPageIndex", pageIndex),
               new SqlParameter("@pPageSize", pageSize),
               new SqlParameter("@pName", Name)

               ).ToList<OpeningBalanceDeatils>();

            totalCount = 0;
            if (result.Count() > 0)
            {
                totalCount = Convert.ToInt32(result.FirstOrDefault().TotalRows);
            }
            var itemsAsIPagedList = new StaticPagedList<OpeningBalanceDeatils>(result, pageIndex, pageSize, totalCount);
            return itemsAsIPagedList;

        }


        [HttpPost]
        [ValidateInput(false)]
        public ActionResult SaveOpeningBalance(List<OpeningBalance> SaveLaneRate)
        {
            try
            {
                JobDbContext _db = new JobDbContext();

                if (SaveLaneRate.Count > 0)
                {
                    foreach (var item in SaveLaneRate)
                    {
                        _db.Database.ExecuteSqlCommand(@"exec uspUpdateOpeniningBalance @PreviousBalance,@CustomerId",
                              new SqlParameter("@PreviousBalance", item.PreviousBalance), new SqlParameter("@CustomerId", item.CustomerID));

                    }

                }
                return Json("Opening Balance Added Sucessfully");
            }
            catch (Exception e)


            {
                var messege = e.Message;
                return Request.IsAjaxRequest() ? (ActionResult)Json(messege)
               : Json(messege);

            }
        }

        public ActionResult OpeningBalance()
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
                        cmd.CommandText = "OpeningBalanceList";
                        cmd.CommandType = CommandType.StoredProcedure;
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

                return View(dt);
            }

        }

        //================================================= User Logout ==================================================

        public ActionResult logout()
        {
            Session.Clear();
            Session.Abandon();
            Session.RemoveAll();
            return RedirectToAction("Index", "Home");
        }

        //=================================================  Supplier Master ==================================================


        public ActionResult IndexForSupplierMaster(int? page, string sname = "")
        {
            var user = Session["username"];
            if (user == null)
            {
                return RedirectToAction("Index", "Home");
            }

            StaticPagedList<SupplierDetails> itemsAsIPagedList;
            itemsAsIPagedList = SupplierGridList(page, sname);

            string abc = Session["username"].ToString();

            Session["MasterName"] = "SupplierMaster";
            return Request.IsAjaxRequest()
                    ? (ActionResult)PartialView("IndexForSupplierMaster", itemsAsIPagedList)
                    : View("IndexForSupplierMaster", itemsAsIPagedList);
        }


        public ActionResult LoadDataForSuppier(int? page, string sname = "")
        {
            StaticPagedList<SupplierDetails> itemsAsIPagedList;
            itemsAsIPagedList = SupplierGridList(page, sname);

            //   Session["MasterName"] = "SupplierMaster";
            return Request.IsAjaxRequest()
                    ? (ActionResult)PartialView("_partialGridSupplierMaster", itemsAsIPagedList)
                    : View("_partialGridSupplierMaster", itemsAsIPagedList);
        }



        //================================== Fill Supplier Grid Code ===========================================

        public StaticPagedList<SupplierDetails> SupplierGridList(int? page, string sname = "")
        {

            JobDbContext _db = new JobDbContext();
            var pageIndex = (page ?? 1);
            const int pageSize = 11;
            int totalCount = 11;
            SupplierDetails Ulist = new SupplierDetails();

            IEnumerable<SupplierDetails> result = _db.SupplierDetails.SqlQuery(@"exec GetSupplierList
                   @pPageIndex, @pPageSize,@sname",
               new SqlParameter("@pPageIndex", pageIndex),
               new SqlParameter("@pPageSize", pageSize),
               new SqlParameter("@sname", sname)

               ).ToList<SupplierDetails>();

            totalCount = 0;
            if (result.Count() > 0)
            {
                totalCount = Convert.ToInt32(result.FirstOrDefault().TotalRows);
            }
            var itemsAsIPagedList = new StaticPagedList<SupplierDetails>(result, pageIndex, pageSize, totalCount);
            return itemsAsIPagedList;

        }

        [HttpGet]
        public ActionResult Add_Supplier()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Add_Supplier(SupplierMaster pm)
        {
            JobDbContext _db = new JobDbContext();
            try
            {

                var res = _db.Database.ExecuteSqlCommand(@"exec UC_InsertVendorMast @VendorName,@Address,@AreaID,@CityID,@EmailID,@OfficePhone,@FaxNo,@ContactPerson,@PersonMobileNo,@IsActive,@CreatedBy",
                    new SqlParameter("@VendorName", pm.VendorName),
                    new SqlParameter("@Address", pm.Address == null ? (object)DBNull.Value : pm.Address),
                    new SqlParameter("@AreaID", 1),
                    new SqlParameter("@CityID", 1),
                    new SqlParameter("@EmailID", pm.EmailID == null ? (object)DBNull.Value : pm.EmailID),
                    new SqlParameter("@OfficePhone", pm.OfficeNumber == null ? (object)DBNull.Value : pm.OfficeNumber),
                    new SqlParameter("@FaxNo", pm.FaxNumber == null ? (object)DBNull.Value : pm.FaxNumber),
                    new SqlParameter("@ContactPerson", pm.ContactPerson == null ? (object)DBNull.Value : pm.ContactPerson),
                    new SqlParameter("@PersonMobileNo", pm.PersonMobileNo == null ? (object)DBNull.Value : pm.PersonMobileNo),
                    new SqlParameter("@IsActive", pm.IsActive),
                    new SqlParameter("@CreatedBy", 1)
                    );

                return Json("Data Added Sucessfully");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }

        }


        //========================================== Edit Supplier ================================================

        public ActionResult EditSupplier()
        {
            return View();

        }

        public ActionResult FetchSupplierForUpdate(int? VendorID)
        {
            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.SupplierMaster.SqlQuery(@"exec [UC_FetchDataForUpdate_VendorMaster] @VendorID",
                    new SqlParameter("@VendorID", VendorID)
                   ).ToList<SupplierMaster>();

                SupplierMaster rs = new SupplierMaster();
                rs = res.FirstOrDefault();
                return View("EditSupplier", rs);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }
        }


        public ActionResult DeleteSupplier(int? VendorID)
        {

            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec UC_DeleteVendorMast @VendorID",
                    new SqlParameter("@VendorID", VendorID));

                return Json("Data Deleted Sucessfully");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }

        }

        [HttpPost]
        public ActionResult UpdateSupplier(SupplierMaster rm)
        {

            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec [UC_UpdateVendorMast] @VendorID,@VendorName,@Address,@EmailID,@OfficePhone,@FaxNo,@ContactPerson,@PersonMobileNo,@IsActive,@LastUpdatedBy",
                    new SqlParameter("@VendorID", rm.VendorID),
                    new SqlParameter("@VendorName", rm.VendorName),
                    new SqlParameter("@Address", rm.Address == null ? (object)DBNull.Value : rm.Address),
                    new SqlParameter("@EmailID", rm.EmailID == null ? (object)DBNull.Value : rm.EmailID),
                    new SqlParameter("@OfficePhone", rm.OfficeNumber == null ? (object)DBNull.Value : rm.OfficeNumber),
                    new SqlParameter("@FaxNo", rm.FaxNumber == null ? (object)DBNull.Value : rm.FaxNumber),
                    new SqlParameter("@ContactPerson", rm.ContactPerson == null ? (object)DBNull.Value : rm.ContactPerson),
                    new SqlParameter("@PersonMobileNo", rm.PersonMobileNo == null ? (object)DBNull.Value : rm.PersonMobileNo),
                    new SqlParameter("@IsActive", rm.IsActive),
                    new SqlParameter("@LastUpdatedBy", 1));

                return Json("Data Updated Sucessfully");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }

        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult SaveSupplierExcelData(List<SupplierMaster> SaveSupplierData)
        {
            try
            {
                JobDbContext _db = new JobDbContext();

                if (SaveSupplierData.Count > 0)
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("VendorID", typeof(int));
                    dt.Columns.Add("VendorName", typeof(string));
                    dt.Columns.Add("Address", typeof(string));
                    dt.Columns.Add("AreaID", typeof(int));
                    dt.Columns.Add("CityID", typeof(int));
                    dt.Columns.Add("EmailID", typeof(string));
                    dt.Columns.Add("OfficePhone", typeof(string));
                    dt.Columns.Add("FaxNo", typeof(string));
                    dt.Columns.Add("ContactPerson", typeof(string));
                    dt.Columns.Add("PersonMobileNo", typeof(string));
                    dt.Columns.Add("IsActive", typeof(Boolean));
                    dt.Columns.Add("CreatedBy", typeof(int));
                    dt.Columns.Add("CreateDate", typeof(DateTime));
                    dt.Columns.Add("LastUpdatedDate", typeof(DateTime));
                    dt.Columns.Add("LastUpdatedBy", typeof(int));

                    foreach (var item in SaveSupplierData)
                    {
                        DataRow dr = dt.NewRow();
                        dr["VendorID"] = 1;
                        dr["VendorName"] = item.VendorName;
                        dr["Address"] = item.Address;
                        dr["AreaID"] = 1;
                        dr["CityID"] = 1;
                        dr["EmailID"] = item.EmailID;
                        dr["OfficePhone"] = item.OfficeNumber;
                        dr["ContactPerson"] = item.ContactPerson;
                        dr["PersonMobileNo"] = item.PersonMobileNo;
                        dr["IsActive"] = item.IsActive;
                        dr["CreatedBy"] = 1;
                        dr["CreateDate"] = DateTime.Now;
                        dr["LastUpdatedDate"] = DateTime.Now;
                        dr["LastUpdatedBy"] = 1;

                        string temp = item.PersonMobileNo;
                        Int64 Num = 0;
                        bool isNum = Int64.TryParse(temp, out Num); //c is your variable


                        if (item.VendorName == null)
                        {
                            return Json("Vendor Name Is Missing");
                        }
                        else if (item.Address == null)
                        {
                            return Json("Address Is Missing");
                        }
                        else if (item.PersonMobileNo.Length == 10 && isNum == true)
                        {
                            dt.Rows.Add(dr);
                        }
                        else
                        {
                            return Json("Enter 10 Digit Mobile Number");
                        }

                    }

                    SqlParameter tvpParam = new SqlParameter();
                    tvpParam.ParameterName = "@SupplierParameters";
                    tvpParam.SqlDbType = System.Data.SqlDbType.Structured;
                    tvpParam.Value = dt;
                    tvpParam.TypeName = "UT_SupplierMaster";

                    var res = _db.Database.ExecuteSqlCommand(@"exec USP_InsertExcelData_SupplierMaster @SupplierParameters",
                     tvpParam);

                }
                // return Request.IsAjaxRequest() ? (ActionResult)PartialView("ImportLaneRate")
                //: View();
                return Request.IsAjaxRequest() ? (ActionResult)Json("Excel Imported Sucessfully")
                : Json("Excel Imported Sucessfully");
            }
            catch (Exception e)

            {
                var messege = e.Message;
                return Request.IsAjaxRequest() ? (ActionResult)Json(messege)
               : Json(messege);
            }

        }

        [HttpGet]
        public ActionResult importexcel(string MasterName = "")
        {
            Session["MasterName"] = MasterName;
            return View();
        }

        [HttpPost]
        public ActionResult importexcel(HttpPostedFileBase file, Route L)
        {
            DataTable dt1 = new DataTable();
            DataSet ds = new DataSet();
            if (Request.Files["file"].ContentLength > 0)
            {
                string fileExtension = System.IO.Path.GetExtension(Request.Files["file"].FileName);

                if (fileExtension == ".xls" || fileExtension == ".xlsx")
                {
                    string fileLocation = Server.MapPath("~/uploads/") + Request.Files["file"].FileName;
                    if (System.IO.File.Exists(fileLocation))
                    {
                        System.IO.File.SetAttributes(fileLocation, FileAttributes.Normal);
                        //   System.IO.File.Delete(fileLocation);
                    }
                    Request.Files["file"].SaveAs(fileLocation);

                    string excelConnectionString = string.Empty;
                    excelConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" +
                    fileLocation + ";Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=2\"";
                    //connection String for xls file format.
                    if (fileExtension == ".xls")
                    {
                        excelConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" +
                        fileLocation + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=2\"";
                    }
                    //connection String for xlsx file format.
                    else if (fileExtension == ".xlsx")
                    {
                        excelConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" +
                        fileLocation + ";Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=2\"";
                    }
                    //Create Connection to Excel work book and add oledb namespace
                    OleDbConnection excelConnection = new OleDbConnection(excelConnectionString);
                    excelConnection.Open();
                    DataTable dt = new DataTable();

                    dt = excelConnection.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                    if (dt == null)
                    {
                        return null;
                    }

                    String[] excelSheets = new String[dt.Rows.Count];
                    int t = 0;
                    //excel data saves in temp file here.
                    foreach (DataRow row in dt.Rows)
                    {
                        excelSheets[t] = row["TABLE_NAME"].ToString();
                        t++;
                    }
                    if (excelConnection.State == ConnectionState.Open)
                    {
                        excelConnection.Close();
                    }
                    OleDbConnection excelConnection1 = new OleDbConnection(excelConnectionString);

                    string query = string.Format("Select * from [{0}]", excelSheets[0]);
                    using (OleDbDataAdapter dataAdapter = new OleDbDataAdapter(query, excelConnection1))
                    {
                        dataAdapter.Fill(ds);
                    }
                    if (excelConnection1.State == ConnectionState.Open)
                    {
                        excelConnection1.Close();
                    }
                }
                if (fileExtension.ToString().ToLower().Equals(".xml"))
                {
                    string fileLocation = Server.MapPath("~/uploads/") + Request.Files["FileUpload"].FileName;
                    if (System.IO.File.Exists(fileLocation))
                    {
                        System.IO.File.Delete(fileLocation);
                    }
                    Request.Files["FileUpload"].SaveAs(fileLocation);
                    XmlTextReader xmlreader = new XmlTextReader(fileLocation);
                    ds.ReadXml(xmlreader);
                    xmlreader.Close();
                }
                dt1 = ds.Tables[0] as DataTable;
                Session.Add("dt1", dt1);
                L.dtTable = dt1;

            }

            ViewBag.error = "show";
            return Request.IsAjaxRequest() ? (ActionResult)PartialView("importexcel", L)
                : View(L);
        }



        public ActionResult IndexForAreaMaster(int? page, string aname = "")
        {
            var user = Session["username"];
            if (user == null)
            {
                return RedirectToAction("Index", "Home");
            }
            StaticPagedList<RouteDetails> itemsAsIPagedList;
            itemsAsIPagedList = AeraGridList(page, aname);
            //Session["MasterName"] = "AreaMaster";
            return Request.IsAjaxRequest()
                    ? (ActionResult)PartialView("IndexForAreaMaster", itemsAsIPagedList)
                    : View("IndexForAreaMaster", itemsAsIPagedList);
        }

        public ActionResult LoadDataForArea(int? page, string aname = "")
        {
            StaticPagedList<RouteDetails> itemsAsIPagedList;
            itemsAsIPagedList = AeraGridList(page, aname);
            //  Session["MasterName"] = "AreaMaster";
            return Request.IsAjaxRequest()
                    ? (ActionResult)PartialView("_partialGridAreaMaster", itemsAsIPagedList)
                    : View("_partialGridAreaMaster", itemsAsIPagedList);
        }

        [HttpGet]
        public ActionResult AddArea_Route()
        {
            return View();
        }

        [HttpPost]
        public ActionResult AddArea_Route(Route md)
        {
            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec UC_InsertAreaMast @Area,@CityID",
                    new SqlParameter("@Area", md.Area),
                    new SqlParameter("@CityID", 1));
                return Json("Data Added Sucessfully");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }

        }


        public StaticPagedList<RouteDetails> AeraGridList(int? page, string aname = "")
        {

            JobDbContext _db = new JobDbContext();
            var pageIndex = (page ?? 1);
            const int pageSize = 10;
            int totalCount = 10;
            RouteDetails Ulist = new RouteDetails();

            IEnumerable<RouteDetails> result = _db.RouteDetails.SqlQuery(@"exec GetAreaList
                   @pPageIndex, @pPageSize,@aname",
               new SqlParameter("@pPageIndex", pageIndex),
               new SqlParameter("@pPageSize", pageSize),
               new SqlParameter("@aname", aname)

               ).ToList<RouteDetails>();

            totalCount = 0;
            if (result.Count() > 0)
            {
                totalCount = Convert.ToInt32(result.FirstOrDefault().TotalRows);
            }
            var itemsAsIPagedList = new StaticPagedList<RouteDetails>(result, pageIndex, pageSize, totalCount);
            return itemsAsIPagedList;

        }

        public ActionResult EditArea_Route()
        {
            return View();

        }

        public ActionResult FetchEditArea(int? AreaID)
        {
            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.EditRoute.SqlQuery(@"exec UC_FetchDataForUpdate_AreaMast @AreaID",
                    new SqlParameter("@AreaID", AreaID)
                   ).ToList<EditRoute>();

                EditRoute rs = new EditRoute();
                rs = res.FirstOrDefault();
                return View("EditArea_Route", rs);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }
        }

        [HttpPost]
        public ActionResult UpdateArea_Route(EditRoute md)
        {

            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec UC_UpdateAreaMast @AreaID,@Area,@CityID",
                    new SqlParameter("@Area", md.Area),
                    new SqlParameter("@CityID", 1),
                    new SqlParameter("@AreaID", md.AreaID));

                if (res == 0)
                {
                    return Json("Area is already exist");
                }
                else
                {
                    return Json("Data Updated Sucessfully");
                }


            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }

        }

        [HttpPost]
        public ActionResult DeleteArea_Route(EditRoute md)
        {

            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec UC_DeleteAreaMast @AreaID",
                    new SqlParameter("@AreaID", md.AreaID));

                return Json("Data Deleted Sucessfully");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }

        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult SaveAreaExcelData(List<Route> SaveLaneRate)
        {

            try
            {
                JobDbContext _db = new JobDbContext();

                if (SaveLaneRate.Count > 0)
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("AreaID", typeof(int));
                    dt.Columns.Add("Area", typeof(string));
                    dt.Columns.Add("CityId", typeof(int));
                    dt.Columns.Add("LastUpdatedDate", typeof(DateTime));

                    foreach (var item in SaveLaneRate)
                    {
                        DataRow dr = dt.NewRow();
                        dr["AreaID"] = 1;
                        dr["Area"] = item.Area;
                        dr["CityId"] = item.CityId;
                        dr["LastUpdatedDate"] = DateTime.Now;

                        if (item.Area == null)
                        {
                            return Json("Enter Area Name");
                        }
                        else
                        {
                            dt.Rows.Add(dr);

                        }
                    }

                    SqlParameter tvpParam = new SqlParameter();
                    tvpParam.ParameterName = "@Area_name";
                    tvpParam.SqlDbType = System.Data.SqlDbType.Structured;
                    tvpParam.Value = dt;
                    tvpParam.TypeName = "UT_AeraMaster1";

                    var res = _db.Database.ExecuteSqlCommand(@"exec USP_InsertExcelData_AeraMaster @Area_name",
                     tvpParam);

                }
                // return Request.IsAjaxRequest() ? (ActionResult)PartialView("ImportLaneRate")
                //: View();
                return Request.IsAjaxRequest() ? (ActionResult)Json("Excel Imported Sucessfully")
                : Json("Excel Imported Sucessfully");
            }
            catch (Exception e)

            {
                var messege = e.Message;
                return Request.IsAjaxRequest() ? (ActionResult)Json(messege)
               : Json(messege);

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
        public ActionResult CustomerRates()
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


                        cmd.CommandText = "CustomersRate";
                        cmd.CommandType = CommandType.StoredProcedure;


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


        public ActionResult LoadCustomerRates(String Name)
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


                        cmd.CommandText = "CustomersRate";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@pName", Name));


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
               
                return View("Partial_CustomerRates", dt);
            }

        }



        public ActionResult IndexForCustomerMaster(int? page)
        {
            var user = Session["username"];
            if (user == null)
            {
                return RedirectToAction("Index", "Home");
            }
            StaticPagedList<CustomerDetails> itemsAsIPagedList;

            if (Session["areaid"] == null) { Session["areaid"] = 0; }

            itemsAsIPagedList = CustomerGridList(page,Convert.ToInt32(Session["areaid"].ToString()));
            ViewData["Area"] = binddropdown("Area", 0);

            Session["MasterName"] = "CustomerMaster";
            return Request.IsAjaxRequest()
                    ? (ActionResult)PartialView("IndexForCustomerMaster", itemsAsIPagedList)
                    : View("IndexForCustomerMaster", itemsAsIPagedList);
        }

        public StaticPagedList<CustomerDetails> CustomerGridList(int? page,int? areaid)
        {

            JobDbContext _db = new JobDbContext();
            var pageIndex = (page ?? 1);
            const int pageSize = 10;
            int totalCount = 8;
            CustomerDetails Ulist = new CustomerDetails();

            IEnumerable<CustomerDetails> result = _db.CustomerDetails.SqlQuery(@"exec GetCustomerList
                   @pPageIndex, @pPageSize,@pName,@area",
                new SqlParameter("@pPageIndex", pageIndex),
                new SqlParameter("@pPageSize", pageSize),
                new SqlParameter("@pName",""),
                new SqlParameter("@area", areaid)

               ).ToList<CustomerDetails>();

            totalCount = 0;
            if (result.Count() > 0)
            {
                totalCount = Convert.ToInt32(result.FirstOrDefault().TotalRows);
            }
            var itemsAsIPagedList = new StaticPagedList<CustomerDetails>(result, pageIndex, pageSize, totalCount);
            return itemsAsIPagedList;



        }

        [HttpGet]
        public ActionResult Add_Customer()
        {
            ViewData["Area"] = binddropdown("Area", 0);
            ViewData["Employee"] = binddropdown("Employee", 0);
            ViewData["Vehicle"] = binddropdown("Vehicle", 0);

            return View();
        }

        [HttpPost]
        public ActionResult AddCustomer(Customer pm)
        {
            JobDbContext _db = new JobDbContext();

            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec UC_CustomerMast_Insert @CustomerName,@Address,@AreaID,@Mobile,@EmployeeId,@VehicleID,@isActive,@BillRequired,@DeliveryCharges",
                    new SqlParameter("@CustomerName", pm.CustomerName),
                    new SqlParameter("@Address", pm.Address),
                      new SqlParameter("@AreaID", pm.AreaID),
                    new SqlParameter("@Mobile", pm.Mobile),
                    new SqlParameter("@EmployeeId", pm.SalesPersonID),
                    new SqlParameter("@VehicleID", pm.VehicleID),
                    new SqlParameter("@isActive", pm.isActive),
                    new SqlParameter("@BillRequired", pm.isBillRequired),
                    new SqlParameter("@DeliveryCharges", pm.DeliveryCharges)
                    );

                return Json("Data Added Sucessfully");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);
            }
        }

        public ActionResult EditCustomer(int CustomerID)
        {
            JobDbContext _db = new JobDbContext();
            CustomerList md = new CustomerList();
            var result = _db.CustomerList.SqlQuery(@"exec UC_Select_CustomerMast_By_CustomerID @CustomerID
                ",
                new SqlParameter("@CustomerID", CustomerID)).ToList<CustomerList>();
            md = result.FirstOrDefault();
            ViewData["Area"] = binddropdown("Area", 0);
            ViewData["Employee"] = binddropdown("Employee", 0);
            ViewData["Vehicle"] = binddropdown("Vehicle", 0);
            return Request.IsAjaxRequest()
               ? (ActionResult)PartialView("EditCustomer", md)
               : View("EditCustomer", md);
        }

        [HttpPost]
        public ActionResult UpdateCustomer(CustomerList pm)
        {
            JobDbContext _db = new JobDbContext();

            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec UC_UpdateCustomerMast @CustomerID,@CustomerName,@Address,@AreaID,@Mobile,@EmployeeId,@VehicleID,@isActive,@BillRequired,@DeliveryCharges",
                     new SqlParameter("@CustomerID", pm.CustomerID),
                    new SqlParameter("@CustomerName", pm.CustomerName),
                    new SqlParameter("@Address", pm.Address),
                      new SqlParameter("@AreaID", pm.AreaID),
                    new SqlParameter("@Mobile", pm.Mobile),
                    new SqlParameter("@EmployeeId", pm.SalesPersonID),
                    new SqlParameter("@VehicleID", pm.VehicleID),
                    new SqlParameter("@isActive", pm.isActive),
                    new SqlParameter("@BillRequired", pm.isBillRequired),
                    new SqlParameter("@DeliveryCharges", pm.DeliveryCharges == null ? 0 : pm.DeliveryCharges)
                    );

                return Json("Data Updated Sucessfully");
            }
            catch (Exception ex)
            {
                string message = string.Format("<b>Message:</b> {0}<br /><br />", ex.Message);
                return Json(pm, JsonRequestBehavior.AllowGet);

            }



        }

        [HttpPost]
        public ActionResult DeleteCustomer(int? CustomerID)
        {

            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec UC_CustomerMast_DeleteByPK @CustomerID",
                    new SqlParameter("@CustomerID", CustomerID));

                return Json("Data Deleted Sucessfully");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }

        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult SaveCustomerExcelData(List<Customer> SaveCustomerData)
        {
            try
            {
                JobDbContext _db = new JobDbContext();

                if (SaveCustomerData.Count > 0)
                {

                    DataTable dt = new DataTable();
                    dt.Columns.Add("CustomerID", typeof(int));
                    dt.Columns.Add("CustomerName", typeof(string));
                    dt.Columns.Add("Address", typeof(string));
                    dt.Columns.Add("Mobile", typeof(string));
                    dt.Columns.Add("AreaID", typeof(int));
                    dt.Columns.Add("SalesPersonID", typeof(int));
                    dt.Columns.Add("VehicleID", typeof(int));
                    dt.Columns.Add("CustomerTypeId", typeof(int));
                    dt.Columns.Add("CustomerNameEnglish", typeof(string));
                    dt.Columns.Add("LastUpdatedDate", typeof(DateTime));
                    dt.Columns.Add("isBillRequired", typeof(Boolean));
                    dt.Columns.Add("isActive", typeof(Boolean));
                    dt.Columns.Add("DeliveryCharges", typeof(decimal));
                    foreach (var item in SaveCustomerData)
                    {
                        DataRow dr = dt.NewRow();
                        dr["CustomerID"] = 105;
                        dr["CustomerName"] = item.CustomerName;
                        dr["Address"] = item.Address;
                        dr["Mobile"] = item.Mobile;
                        dr["AreaID"] = item.AreaID;
                        dr["SalesPersonID"] = item.SalesPersonID;
                        dr["VehicleID"] = item.VehicleID;
                        dr["CustomerTypeId"] = item.CustomerTypeId;
                        dr["CustomerNameEnglish"] = item.CustomerNameEnglish;
                        dr["LastUpdatedDate"] = System.DateTime.Now;
                        dr["isBillRequired"] = item.isBillRequired;
                        dr["isActive"] = item.isActive;
                        dr["DeliveryCharges"] = item.DeliveryCharges;
                        if (item.CustomerName != null)
                        {
                            dt.Rows.Add(dr);
                        }
                    }

                    SqlParameter tvpParam = new SqlParameter();
                    tvpParam.ParameterName = "@CustomerParameters";
                    tvpParam.SqlDbType = System.Data.SqlDbType.Structured;
                    tvpParam.Value = dt;
                    tvpParam.TypeName = "UT_CustomerMaster";

                    var res = _db.Database.ExecuteSqlCommand(@"exec USP_InsertExcelData_CustomerMaster @CustomerParameters",
                     tvpParam);

                }
                // return Request.IsAjaxRequest() ? (ActionResult)PartialView("ImportLaneRate")
                //: View();
                return Request.IsAjaxRequest() ? (ActionResult)Json("Excel Imported Sucessfully")
                : Json("Excel Imported Sucessfully");
            }
            catch (Exception e)

            {
                var messege = e.Message;
                return Request.IsAjaxRequest() ? (ActionResult)Json(messege)
               : Json(messege);
            }

        }



        public ActionResult LoadDataCustomer(int? page, String Name, int? area)
        {
            var user = Session["username"];
            if (user == null)
            {
                return RedirectToAction("Index", "Home");
            }
            
            if (area == null) { Session["areaid"] = 0; } else { Session["areaid"] = area; }
            StaticPagedList<CustomerDetails> itemsAsIPagedList;
            itemsAsIPagedList = GridListCustomer(page, Name, area = Convert.ToInt32(Session["areaid"].ToString()));



            return Request.IsAjaxRequest()
                    ? (ActionResult)PartialView("Partial_CustomerGridList", itemsAsIPagedList)
                    : View("Partial_CustomerGridList", itemsAsIPagedList);
        }

        public StaticPagedList<CustomerDetails> GridListCustomer(int? page, String Name, int? area)
        {

            JobDbContext _db = new JobDbContext();
            var pageIndex = 1;//(page ?? 1);
            const int pageSize = 20;
            int totalCount = 8;
            CustomerDetails Ulist = new CustomerDetails();
            if (Name == null) Name = "";
            if (area == null) area = 0;
            IEnumerable<CustomerDetails> result = _db.CustomerDetails.SqlQuery(@"exec GetCustomerList
                   @pPageIndex, @pPageSize,@pName,@area",
               new SqlParameter("@pPageIndex", pageIndex),
               new SqlParameter("@pPageSize", pageSize),
               new SqlParameter("@pName", Name),
               new SqlParameter("@area", area)

               ).ToList<CustomerDetails>();

            totalCount = 0;
            if (result.Count() > 0)
            {
                totalCount = Convert.ToInt32(result.FirstOrDefault().TotalRows);
            }
            var itemsAsIPagedList = new StaticPagedList<CustomerDetails>(result, pageIndex, pageSize, totalCount);
            return itemsAsIPagedList;



        }


        public ActionResult Sales(DateTime? date)
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
                    date = System.DateTime.Now;
                }
                var conn = context.Database.Connection;
                var connectionState = conn.State;
                try
                {
                    if (connectionState != ConnectionState.Open) conn.Open();
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "SalesOrder";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@pDate", date));
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
                //return Redirect("Home/SalesOrder");
                //TempData["Data"] = dt;
                //DownloadSalesExcelSheet();

                return View(dt);
            }

        }



        public ActionResult LoadSalesOrder(DateTime? date, string customername = "")
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
                        cmd.CommandText = "SalesOrder";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(new SqlParameter("@pDate", date));
                        cmd.Parameters.Add(new SqlParameter("@customername", customername));

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

                //TempData["Data"] = dt;
                //DownloadSalesExcelSheet();
                return PartialView("Partial_LoadSalesOrder", dt);
                // return View(dt);
            }
        }

        [HttpGet]
        [ActionName("Download")]
        public void DownloadSalesExcelSheet()
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
            string filePath = Server.MapPath("~/SalesOrderXLSheet/" + 1 + "/generated/");

            bool isExists = System.IO.Directory.Exists(filePath);
            if (!isExists) { System.IO.Directory.CreateDirectory(filePath); }

            string fileName = "SalesOrder" + ".xls";
            // Write the rendered content to a file.
            string renderedGridView = sw.ToString();
            System.IO.File.WriteAllText(filePath + fileName, renderedGridView);

        }


        public ActionResult CustomerCopyRates()
        {
            ViewData["CustomerRateCopyList"] = binddropdown("CustomerRateCopyList", 0);

            ViewData["ProductList"] = binddropdown("ProductList", 0);

            JobDbContext _db = new JobDbContext();
            copyrate rs = new copyrate();
            var res = _db.copyrate.SqlQuery(@"exec CustomerListCopy").ToList<copyrate>();

            rs = res.FirstOrDefault();
            return PartialView("Partial_CustomerCopyRates", res);               
           
        }
       

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult CopyRate(int[] copyrate, int? CustomerId, int? ProductId, DateTime? pdate)
        {

            JobDbContext _db = new JobDbContext();
            try
            {

                foreach (var item in copyrate)
                {

                    var res = _db.Database.ExecuteSqlCommand(@"exec CustomerRateCopy @CustomerId,@ProductId,@CheckCustomerID,@pdate",
                    new SqlParameter("@CustomerId", CustomerId),
                    new SqlParameter("@ProductId", ProductId),
                    new SqlParameter("@CheckCustomerID", item),
                    new SqlParameter("@pdate", pdate)
                   );

                }

                return Json("Data Copied Sucessfully");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);
            }

        }

        public ActionResult SearchSupplier()
        {
            return View();
        }

        [HttpPost]
        public ActionResult SearchSupplier(String val="")
        {
            JobDbContext2 _db = new JobDbContext2();
            try
            {
                var res = _db.SupplierMaster.SqlQuery(@"exec usp_SearchUser @Val",
                    new SqlParameter("@Val", val)
                   ).ToList<SupplierMaster>();

                SupplierMaster rs = new SupplierMaster();
                rs = res.FirstOrDefault();
               // return View("SearchSupplier", rs);
                return Request.IsAjaxRequest()
                ? (ActionResult)PartialView("SearchSupplier",rs)
                : View("SearchSupplier",rs);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }
        }


        [HttpPost]
        public ActionResult AddVendor(int? NotificationId)
        {
            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec USPAddVendor @NotificationId", 
                    new SqlParameter("@NotificationId", NotificationId));

                UpdateNotificationStatus(NotificationId); //update notification status after opration

                return Json("Request Accepted");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }
        }
        
      
        
        public ActionResult CustomerProductRates(String Mobile = "")
        {
            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.CustomerProductDetails.SqlQuery(@"exec uspGetCustomerRate @pMobileNo",
                    new SqlParameter("@pMobileNo", Mobile)
                   ).ToList<CustomerProductDetails>();

                //SupplierMaster rs = new SupplierMaster();
               
                return Request.IsAjaxRequest()
                ? (ActionResult)PartialView("_VendorProductDetails", res)
                : View("_VendorProductDetails", res);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                string errormsg = "No Product Record Found";
                return Json(errormsg);

            }
        }

        [HttpPost]
        public ActionResult SaveCustomerProductRates(String Mobile = "", String Values="")
        {
            JobDbContext _db = new JobDbContext();
            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec USPPullSupplierRate @pMobileNo,@Values ",
                    new SqlParameter("@pMobileNo", Mobile),
                    new SqlParameter("@Values", Values)
                   );

                
                return Json("product rates added sucessfully");
                
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }
        }
        public ActionResult DashboardCounts(int id=0 )
        {
            JobDbContext _db = new JobDbContext();
            DashboardCounts result = _db.DashboardCounts.SqlQuery(@"exec USPGetDashboardCounts").ToList<DashboardCounts>().FirstOrDefault();
            

            return Request.IsAjaxRequest()
                   ? (ActionResult)PartialView("DashboardCounts", result)
                   : View("DashboardCounts", result);
        }

        public ActionResult _Notification()
        {
            try
            {
                JobDbContext2 _db = new JobDbContext2();
                var result = _db.NotificationDetails.SqlQuery(@"exec UspUserNotification 
                @UserId",
                new SqlParameter("@UserId", Session["UserID"])).ToList<NotificationDetails>();
                //NotificationDetails data = new NotificationDetails();
                //data = result.FirstOrDefault();

                return Request.IsAjaxRequest()
                   ? (ActionResult)PartialView("_Notification", result)
                   : View("_Notification", result);


            }

            catch (Exception ex)
            {
                return Json(ex.Message);
            }

        }


        public ActionResult NotificationCount()
        {
            try
            {
                JobDbContext2 _db = new JobDbContext2();
                var result = _db.NotoficationCount.SqlQuery(@"exec UspUserNotificationCount 
                @UserId",
                new SqlParameter("@UserId", Session["UserID"])).ToList<NotoficationCount>();
                NotoficationCount data = new NotoficationCount();
                data = result.FirstOrDefault();
                int count = data.CountAll;

                return Json(count);
                //return Request.IsAjaxRequest()
                //   ? (ActionResult)PartialView("_Notification", data)
                //   : View("_Notification", data);

            }

            catch (Exception ex)
            {
                return Json(ex.Message);
            }

        }


        [HttpPost]
        public ActionResult AddNotification(String Mobile="")
        {
            JobDbContext2 _db = new JobDbContext2();
            try
            {

                var res = _db.Database.ExecuteSqlCommand(@"exec USPAddNotification @pUserID,@pMobileNo",
                    new SqlParameter("@pUserID",Session["UserID"]),
                    new SqlParameter("@pMobileNo", Mobile));

                if(res > 0)
                {
                    return Json("Request has been send");
                }
                else
                {
                    return Json("Request fail");
                }
                
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }
        }
         

      public ActionResult  UpdateNotificationStatus(int? NotificationId)
        {
            JobDbContext2 _db = new JobDbContext2();
            try
            {

                var res = _db.Database.ExecuteSqlCommand(@"exec USPupdateNotificationStatus @pNotificationID",
                    new SqlParameter("@pNotificationID", NotificationId));

                return Json("Notification Removed");

            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }
        }





        [HttpPost]
        public ActionResult OnSeenNotificationUpdate()
        {
            JobDbContext2 _db = new JobDbContext2();
            try
            {
                var res = _db.Database.ExecuteSqlCommand(@"exec UspSeenNotificationUpdate @pUserID",
                     new SqlParameter("@pUserID", Session["UserID"]));

                return Json("");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                return Json(message);

            }
        }
        public ActionResult DashboardData()
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
                        cmd.CommandText = "uspDailyBussinessReport";

                        cmd.CommandType = CommandType.StoredProcedure;

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
                DataTable    dt_clone= AddStockBalance(dt);
                return Request.IsAjaxRequest()
                  ? (ActionResult)PartialView("DashboardData", dt_clone)
                  : View("DashboardData", dt);
            }

        }
        public DataTable AddStockBalance(DataTable dtData)
        {
           
           DateTime _mdate = DateTime.Parse(DateTime.Now.ToShortDateString());
            String.Format("{0:MM/dd/yyyy}", _mdate);
            String.Format("{0:G}", _mdate);
            // _mdate = dateEdit1.DateTime.ToString("MM-dd-yyyy");
            Decimal Gridco = 0;
            Decimal Barbil = 0;
            Decimal Total = 0;
            Decimal mLickage = 0;
            int j = 0;

            DataTable dtStockBal = new DataTable();
            DataTable dt1 = new DataTable();
            using (JobDbContext context = new JobDbContext())
            {
               
                DataSet ds = new DataSet();

                var conn = context.Database.Connection;
                var connectionState = conn.State;
                
                    if (connectionState != ConnectionState.Open) conn.Open();
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = "uspDayStockBalanceForDashoard";

                        cmd.CommandType = CommandType.StoredProcedure;

                        using (var reader = cmd.ExecuteReader())
                        {
                            dt1.Load(reader);
                        }
                    } 
            }
            dtStockBal = dt1; 
            int mColCount = dtStockBal.Columns.Count;
            DataTable dt_clone = new DataTable();
            dt_clone.TableName = "CloneStockTable";
            dt_clone = dtStockBal.Clone();
            DataRow drStockBal = dt_clone.NewRow();
            drStockBal[0] = 0;
            drStockBal["daytrans"] = "Stock CF";

            if (dtStockBal.Rows.Count > 1)
            {
                for (int i = 2; i <= dtStockBal.Columns.Count - 1; i++)
                {
                    Gridco = decimal.Parse(dtStockBal.Rows[j][i].ToString());
                    Barbil = decimal.Parse(dtStockBal.Rows[j + 1][i].ToString());

                    mLickage = decimal.Parse(dtStockBal.Rows[j + 2][i].ToString());

                    Total = Gridco - (Barbil + mLickage);
                    drStockBal[i] = Total;
                   
                }
                 
                dt_clone.Rows.Add(drStockBal);  
            }
            try
            {
                dt_clone.Merge(dtData, true);
            }
            catch { }
            //mColCount = dtData.Columns.Count;

            //drStockBal = dt_clone.NewRow();
            //drStockBal[0] = 7;
            //drStockBal[1] = "Purchase";
            //if (dtData.Rows.Count > 1)
            //{
            //    for (int i = 2; i <= dtData.Columns.Count - 1; i++)
            //    {
            //        Gridco = decimal.Parse(dtData.Rows[j][i].ToString());
            //        drStockBal[i] = Gridco;
            //    }
            //    dt_clone.Rows.Add(drStockBal);

            //} 

            DataRow drBal = dt_clone.NewRow();
            drBal[0] = 8;
            drBal[1] = "Bal";
            if (dtData.Rows.Count > 1)
            {
                for (int i = 2; i <= dtData.Columns.Count - 1; i++)
                {
                    Gridco = decimal.Parse(dtData.Rows[j][i].ToString());
                    Barbil = decimal.Parse(dtData.Rows[j + 1][i].ToString());

                    mLickage = decimal.Parse(dtData.Rows[j + 2][i].ToString());

                    Total = decimal.Parse(dt_clone.Rows[0][i].ToString()) + Gridco - (Barbil + mLickage);
                    drBal[i] = Total;
                 
                }
                dt_clone.Rows.Add(drBal);

            }

        ///    DataView dv = dt_clone.DefaultView;
     //       dv.Sort = "No asc";
       //    DataTable sortedDT = dv.ToTable();
            return dt_clone;
        }
        

    }
}