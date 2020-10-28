using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace MyRecipeBackend.Models
{
    public class RecommendedMealInputModel
    {
        [Required]
        public Guid[] PrevMealIds { get; set; }

        //[Required]
        //public int count { get; set; }
    }
}
