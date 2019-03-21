﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace MyVitarak.Models
{
    public partial class Login
    {
        [Key]
        public Int64 RegistrationID { get; set; }
        [Required(ErrorMessage = "Please enter User Name")]
        [Display(Name = "Email")]
        public string Email { get; set; }
        [Required(ErrorMessage = "Please enter Password")]
        [Display(Name = "Password")]
        public string password { get; set; }
        public string DbName { get; set; }
        
    }

    public partial class Payment
    {
        [Key]
        public int t_id { get; set; }
        public string payment_id { get; set; }
        public Int64 registration_id { get; set; }
        public int p_id { get; set; }
        public DateTime payment_date { get; set; }
        public Decimal amount { get; set; }
        
    }

    public partial class MailCheck
    {
        [Key]
        public Int64 RegistrationID { get; set; }
        public string Email { get; set; }      
    }

    public partial class Registration
    {
        [Key] 
        public Int64 RegistrationID { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public string Email { get; set; }
        public string password { get; set; }        
        public Int64 Mobile { get; set; }
        public string ContactPerson { get; set; }
        public string SecurityCode { get; set; }
        public bool isactive { get; set; }
        public bool isreadonly { get; set; }
        public string DbName { get; set; }
    }

    public partial class RegistrationDetails
    {
        [Key]
        public Int64 RegistrationID { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public string Email { get; set; }
        public string password { get; set; }
        public string Mobile { get; set; }
        public string ContactPerson { get; set; }
        
    }


    public partial class Tenant
    {
        [Key]
        public Int64 TenantID { get; set; }
        public Int64 RegistrationID { get; set; }
        public string SecurityCode { get; set; }
        public bool isActive { get; set; }
        public bool isReadOnly { get; set; }
        public string DbName { get; set; }

    }

    public partial class CheckDbSchema
    {
        [Key]
        public Int64 TenantID { get; set; }
        public Int64 RegistrationID { get; set; }
        public Boolean isDbSchema { get; set; }
        
    }

    public partial class PlanePrice
    {
        [Key]
        public int plan_id                { get; set; }
        public string plan_name           { get; set; }
        public string plan_desc            { get; set; }
        public decimal registration_rate   { get; set; }
        public decimal plan_rate           { get; set; }
        public int isactive                { get; set; }
        public DateTime? created_date      { get; set; }
              
    }


}