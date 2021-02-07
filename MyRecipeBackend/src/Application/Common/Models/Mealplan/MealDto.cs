using System;
using System.Collections.Generic;
using System.Linq;
using MyRecipe.Application.Common.Models.Recipe;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Common.Models.Mealplan
{
    public class MealDto
    {
        public MealDto(Meal meal)
        {
            MealId = meal.Id;
            InitiatorName = meal.Initiator.NormalizedUserName;
            Recipe = new RecipeModel(meal.Recipe);
            Date = meal.DateTime.ToString("R");
            Accepted = meal.Accepted;
            Votes = meal.Votes.Select(mv => new VoteDto(mv)).ToArray();
        }

        public Guid MealId { get; set; }
        public string InitiatorName { get; set; }
        public RecipeModel Recipe { get; set; }
        public string Date { get; set; }
        public bool Accepted  { get; set; }
        public IEnumerable<VoteDto> Votes { get; set; }
    }
}
