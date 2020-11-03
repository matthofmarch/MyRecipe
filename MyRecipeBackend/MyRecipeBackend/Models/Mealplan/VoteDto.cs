using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Core.Entities;

namespace MyRecipeBackend.Models.Mealplan
{
    public class VoteDto
    {
        public VoteDto(MealVote vote)
        {
            Username = vote.User.NormalizedUserName;
            Vote = vote.Vote;
        }
        public string Username { get; set; }
        public VoteEnum Vote { get; set; }
    }
}
