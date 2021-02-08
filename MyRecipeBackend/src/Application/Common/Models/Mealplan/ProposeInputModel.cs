using System;
using System.ComponentModel.DataAnnotations;

namespace MyRecipe.Application.Common.Models.Mealplan
{
    public class ProposeInputModel
    {
        [Required]
        public Guid RecipeId { get; set; }
        [Required]
        public DateTime Day { get; set; }
    }
}