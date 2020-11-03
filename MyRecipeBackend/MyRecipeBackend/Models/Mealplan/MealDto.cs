using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using Core.Entities;
using MyRecipeBackend.Models;
using MyRecipeBackend.Models.Mealplan;

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
            Votes = meal.Votes.Select(mv => new VoteDto(mv)).ToArray();
        }

        public Guid MealId { get; set; }
        public string InitiatorName { get; set; }
        public UserRecipeModel Recipe { get; set; }
        public string Date { get; set; }
        public bool Accepted  { get; set; }
        public IEnumerable<VoteDto> Votes { get; set; }
    }
}
