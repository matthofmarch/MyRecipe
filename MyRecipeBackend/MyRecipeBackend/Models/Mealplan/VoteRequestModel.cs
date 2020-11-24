using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using Core.Entities;

namespace MyRecipeBackend.Models.Mealplan
{
    public class VoteRequestModel
    {
        [Required]
        public Guid MealId { get; set; }
        [Required]
        public VoteEnum VoteEnum { get; set; }
    }
}
