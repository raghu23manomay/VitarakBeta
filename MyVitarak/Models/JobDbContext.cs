using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;

namespace MyVitarak.Models
{
    public class JobDbContext : DbContext
    {
        static JobDbContext()
        {
            Database.SetInitializer<JobDbContext>(null);
           
        }
        public JobDbContext() : base("Name=JobDbContext")
        {
            
            Database.Connection.ConnectionString = "Data Source=103.67.238.75,1433;Initial Catalog=" + HttpContext.Current.Session["BusinessName"] + ";User ID=sa;Password=Sunil@123";
        }

        public DbSet<ProductDetails> ProductDetails { get; set; }
        public DbSet<ProductMaster> ProductMaster { get; set; }
        public DbSet<RouteDetails> RouteDetails { get; set; }
        public DbSet<Employee> Employee { get; set; }
        public DbSet<EmployeeDetails> EmployeeDetails { get; set; }
        public DbSet<Vehical> Vehical { get; set; }
        public DbSet<VehicalDetails> VehicalDetails { get; set; }
        public DbSet<SupplierDetails> SupplierDetails { get; set; }
        public DbSet<SupplierMaster> SupplierMaster { get; set; }
        public DbSet<EditRoute> EditRoute { get; set; }
        public DbSet<copyrate> copyrate { get; set; }

        
        public DbSet<Customer> Customer { get; set; }
        public DbSet<CustomerDetails> CustomerDetails { get; set; }
        public DbSet<CustomerList> CustomerList { get; set; }
        public DbSet<EmployeeList> EmployeeList { get; set; }
        public DbSet<OpeningBalance> OpeningBalance { get; set; }
        public DbSet<OpeningBalanceDeatils> OpeningBalanceDeatils { get; set; }
        public DbSet<Login> LoginDetail { get; set; }
        public DbSet<CustomerProductDetails> CustomerProductDetails { get; set; }
        public DbSet<DashboardCounts> DashboardCounts { get; set; }
        public DbSet<Chart> Chart { get; set; }

    }
}