using System;
using System.ComponentModel.DataAnnotations;

namespace MyRecipe.Application.Common.Models.Mealplan
{
    public class RecommendMealRequestModel
    {
        [Required] public Guid[] PrevMealIds { get; set; }

        //[Required]
        //public int count { get; set; }
    }
}