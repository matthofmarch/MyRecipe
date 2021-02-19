using System;
using System.Threading.Tasks;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Common.Interfaces.Repositories
{
    public interface IMealRepository : IEntityRepository<Meal>
    {
        Task ProposeMealAsync(Meal meal);
        Task VoteMealAsync(ApplicationUser user, VoteEnum vote, Guid mealId);

        Task<Meal[]> GetMealsWithRecipeAndInitiatorAsync(Guid groupId, bool? isAccepted);
        Task<Meal> GetMealByIdAsync(Guid groupId, Guid id);
        Task<bool> UserHasAlreadyVotedAsync(MealVote mealVote);
    }
}