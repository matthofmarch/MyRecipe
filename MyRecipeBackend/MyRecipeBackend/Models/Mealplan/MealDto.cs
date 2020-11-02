using System;
using System.Collections.Generic;
using System.Text;
using Core.Entities;
using MyRecipeBackend.Models;

namespace Core.Model
{
    public class MealDto
    {
        public MealDto(Meal meal)
        {
            InitiatorName = meal.Initiator.NormalizedUserName;
            UserRecipe = new UserRecipeModel(meal.Recipe);
            Date = meal.DateTime;
        }

        public string InitiatorName { get; set; }
        public UserRecipeModel UserRecipe { get; set; }
        public DateTime Date { get; set; }
    }
}
