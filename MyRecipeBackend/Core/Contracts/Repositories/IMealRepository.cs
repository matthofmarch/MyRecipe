using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Core.Entities;
using Core.Model;

namespace Core.Contracts.Repositories
{
    public interface IMealRepository
    {
        Task ProposeAndVoteMealAsync(ProposeAndVoteMealModel proposeModel);
        Task VoteMealAsync(VoteMealModel voteModel);

        Task<Meal[]> GetMealsWithRecipeAndInitiatorAsync(Guid groupId, bool? isAccepted);
        Task<Meal> GetMealByIdAsync(Guid groupId, Guid id);
        Task<bool> UserHasAlreadyVotedAsync(MealVote mealVote);
    }
}
