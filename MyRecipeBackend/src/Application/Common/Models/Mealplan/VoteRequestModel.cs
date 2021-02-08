using System;
using System.ComponentModel.DataAnnotations;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Common.Models.Mealplan
{
    public class VoteRequestModel
    {
        [Required]
        public Guid MealId { get; set; }
        [Required]
        public VoteEnum VoteEnum { get; set; }
    }
}
