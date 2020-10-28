using System;
using System.Collections.Generic;
using System.Text;
using Core.Entities;

namespace Core.Model
{
    public class VoteMealModel
    {
        public VoteMealModel(ApplicationUser user, VoteEnum vote, Guid mealId)
        {
            User = user;
            Vote = vote;
            MealId = mealId;
        }

        public ApplicationUser User { get; set; }
        public VoteEnum Vote { get; set; }
        public Guid MealId { get; set; }

    }
}
