using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Core.Contracts.Repositories;
using Devices.Core.Contracts;
using Microsoft.EntityFrameworkCore;

namespace DAL.Repositories
{
    class ShoppingCartRepository: IShoppingCartRepository
    {
        private readonly ApplicationDbContext _dbContext;

        public ShoppingCartRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<string[]> GetRequiredIngredientsForHouseholdMealAsync(DateTime from, DateTime to, Guid householdId)
        {
            return await _dbContext.Groups
                .Where(group => group.Id == householdId)
                .SelectMany(household => household.Meals)
                .Where(meal => from > meal.DateTime && meal.DateTime > to)
                .Select(meal => meal.Recipe)
                .Distinct()
                .SelectMany(recipe => recipe.Ingredients)
                .Distinct()
                .Select(ingredient => ingredient.Name)
                .ToArrayAsync();
        }
    }

}
