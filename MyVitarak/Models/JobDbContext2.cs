using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;

namespace MyVitarak.Models
{
    public class JobDbContext2 : DbContext
    {
        static JobDbContext2()
        {
            Database.SetInitializer<JobDbContext2>(null);

        }
        public JobDbContext2() : base("Name=JobDbContext2")
        {
        }

        public DbSet<PlanRate> PlanRate { get; set; }
        public DbSet<Login> LoginDetail { get; set; }
        public DbSet<RegistrationDetails> RegistrationDetails { get; set; }
        public DbSet<CheckDbSchema> CheckDbSchema { get; set; }
        public DbSet<MailCheck> MailCheck { get; set; }
        public DbSet<SecurityCode> SecurityCode { get; set; }
        public DbSet<SupplierMaster> SupplierMaster { get; set; }
        public DbSet<NotificationDetails> NotificationDetails { get; set; }
        public DbSet<NotoficationCount> NotoficationCount { get; set; }
        

    }
    
}