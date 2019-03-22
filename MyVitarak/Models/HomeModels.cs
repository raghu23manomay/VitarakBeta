using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace MyVitarak.Models
{
    public class HomeModels
    {

    }
    public  class PlanRate
    {
        [Key]
    public Int32 PlanID          { get; set; }
    public string  PlanName      { get; set; }
    public string  PlanDesc      { get; set; }
    public decimal  OTIAmount     { get; set; }
    public decimal  PlanAmount    { get; set; } 
    public bool  IsActive        { get; set; }
    public DateTime CreatedDate   { get; set; } 
    }
}