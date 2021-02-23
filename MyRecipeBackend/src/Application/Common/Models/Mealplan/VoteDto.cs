using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Common.Models.Mealplan
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