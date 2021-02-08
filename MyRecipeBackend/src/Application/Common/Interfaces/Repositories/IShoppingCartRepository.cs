using System;
using System.Threading.Tasks;

namespace MyRecipe.Application.Common.Interfaces.Repositories
{
    public interface IShoppingCartRepository
    {
        public Task<String[]> GetRequiredIngredientsForHouseholdMealAsync(DateTime from, DateTime to, Guid householdId);
    }
}
