using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Core.Entities;
using Devices.Core.Contracts;

namespace Core.Contracts.Repositories
{
    public interface IMealRepository:IEntityRepository<Meal>
    {
        Task ProposeMealAsync(Meal meal);
        Task VoteMealAsync(ApplicationUser user, VoteEnum vote, Guid mealId);

        Task<Meal[]> GetMealsWithRecipeAndInitiatorAsync(Guid groupId, bool? isAccepted);
        Task<Meal> GetMealByIdAsync(Guid groupId, Guid id);
        Task<bool> UserHasAlreadyVotedAsync(MealVote mealVote);
    }
}
