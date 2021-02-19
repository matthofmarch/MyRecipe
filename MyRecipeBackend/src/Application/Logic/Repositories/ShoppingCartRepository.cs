using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Interfaces.Repositories;

namespace MyRecipe.Application.Logic.Repositories
{
    public class ShoppingCartRepository : IShoppingCartRepository
    {
        private readonly IApplicationDbContext _dbContext;

        public ShoppingCartRepository(IApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<string[]> GetRequiredIngredientsForHouseholdMealAsync(DateTime from, DateTime to,
            Guid householdId)
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