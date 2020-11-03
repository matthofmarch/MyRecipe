using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using Core.Entities;
using MyRecipeBackend.Models;

namespace Core.Model
{
    public class MealDto
    {
        public MealDto(Meal meal)
        {
            MealId = meal.Id;
            InitiatorName = meal.Initiator.NormalizedUserName;
            Recipe = new UserRecipeModel(meal.Recipe);
            Date = meal.DateTime.ToString("R");
            Accepted = meal.Accepted;
        }

        public Guid MealId { get; set; }
        public string InitiatorName { get; set; }
        public UserRecipeModel Recipe { get; set; }
        public string Date { get; set; }
        public bool Accepted  { get; set; }
    }
}
