using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace MyRecipeBackend.Models.Mealplan
{
    public class ProposeInputModel
    {
        [Required]
        public Guid RecipeId { get; set; }
        [Required]
        public DateTime Day { get; set; }
    }
}