using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Core.Contracts.Repositories;
using Core.Entities;
using Core.Model;
using Microsoft.EntityFrameworkCore;

namespace DAL.Repositories
{
    public class MealRepository : IMealRepository
    {
        private readonly ApplicationDbContext _dbContext;

        public MealRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        /// <summary>
        /// Adds a new Meal and adds the vote for the initiator
        /// </summary>
        /// <param name="proposeModel"></param>
        /// <returns></returns>
        public async Task ProposeAndVoteMealAsync(Meal mealModel)
        {
            var aloneInGroup = await _dbContext.Users
                .Where(u => u.GroupId == mealModel.Initiator.GroupId)
                .CountAsync() == 1;

            Meal meal = new Meal
            {
                Initiator = mealModel.Initiator,
                Group = mealModel.Group,
                DateTime = mealModel.DateTime,
                Recipe = await _dbContext.UserRecipes.FindAsync(mealModel.RecipeId),
                Votes = new List<MealVote>()
                {
                    new MealVote
                    {
                        User = mealModel.Initiator,
                        Vote = VoteEnum.Approved
                    }
                },
                Accepted = aloneInGroup
            };
            await _dbContext.Meals.AddAsync(meal);
        }

        public async Task VoteMealAsync(ApplicationUser user, VoteEnum vote, Guid mealId)
        {
            var meal = await _dbContext.Meals.FindAsync(mealId);

            var groupSize = await _dbContext.Users
                .Where(u => u.GroupId == user.GroupId)
                .CountAsync();

            var votes = await _dbContext.MealVotes
                .Where(mv => mv.MealId == meal.Id)
                .Where(mv => mv.Vote == VoteEnum.Approved)
                .CountAsync();

            await _dbContext.MealVotes.AddAsync(new MealVote
            {
                Meal = meal,
                User = user,
                Vote = vote,
            });

            var approved = votes >= groupSize / 2;
            meal.Accepted = approved;
        }

        public async Task<Meal[]> GetMealsWithRecipeAndInitiatorAsync(Guid groupId, bool? isAccepted)
        {
            var query = _dbContext.Meals
                .Include(m => m.Initiator)
                .Include(m => m.Recipe)
                .ThenInclude(r => r.Ingredients)
                .ThenInclude(r => r.Ingredient)
                .Include(m => m.Votes)
                .ThenInclude(v => v.User)
                .Where(m => m.GroupId == groupId);

            if (isAccepted != null)
            {
                query = query.Where(m => m.Accepted == isAccepted.Value);
            }

            query = query.OrderBy(m => m.DateTime);

            return await query.ToArrayAsync();
        }

        public async Task<Meal> GetMealByIdAsync(Guid groupId, Guid id)
        {
            return await _dbContext.Meals
                .Include(m => m.Initiator)
                .Include(m => m.Recipe)
                .ThenInclude(r => r.Ingredients)
                .ThenInclude(r => r.Ingredient)
                .Include(m => m.Votes)
                .ThenInclude(v => v.User)
                .Where(m => m.GroupId == groupId && m.Id == id)
                .SingleAsync();
        }

        public Task<bool> UserHasAlreadyVotedAsync(MealVote mealVote)
        {
            return _dbContext.MealVotes.AnyAsync(m => m.UserId == mealVote.User.Id && m.MealId == mealVote.Meal.Id);
        }
    }
}