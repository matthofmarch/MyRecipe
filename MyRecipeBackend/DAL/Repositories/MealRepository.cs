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
        public async Task ProposeAndVoteMealAsync(ProposeAndVoteMealModel proposeModel)
        {
            var aloneInGroup = await _dbContext.Users
                .Where(u => u.GroupId == proposeModel.Meal.Initiator.GroupId)
                .CountAsync() == 1;
            Meal meal = new Meal
            {
                Initiator = proposeModel.Meal.Initiator,
                Group = proposeModel.Meal.Group,
                DateTime = proposeModel.Meal.DateTime,
                Recipe = await _dbContext.UserRecipes.FindAsync(proposeModel.Meal.RecipeId),
                Votes = new List<MealVote>()
                {
                    new MealVote
                    {
                        User = proposeModel.Meal.Initiator,
                        Vote = VoteEnum.Approved
                    }
                },
                Accepted = aloneInGroup
            };
            await _dbContext.Meals.AddAsync(meal);
        }

        public async Task VoteMealAsync(VoteMealModel voteModel)
        {
            var meal = await _dbContext.Meals.FindAsync(voteModel.MealId);
            var groupSize = await _dbContext.Users.Where(u => u.GroupId == voteModel.User.GroupId).CountAsync();
            var votes = await _dbContext.MealVotes
                .Where(mv => mv.MealId == meal.Id)
                .Where(mv => mv.Vote == VoteEnum.Approved)
                .CountAsync();
            if(meal is null || voteModel.User is null)
                throw new ArgumentNullException();

            await _dbContext.MealVotes.AddAsync(new MealVote
            {
                Meal = meal,
                User = voteModel.User,
                Vote = voteModel.Vote,
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
                .Where(m => m.GroupId == groupId);

            if (isAccepted != null)
            {
                query = query.Where(m => m.Accepted == isAccepted.Value);
            }

            query = query.OrderBy(m => m.DateTime);

            return await query.ToArrayAsync();
        }
    }
}