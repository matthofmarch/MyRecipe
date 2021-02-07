using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.Contracts.Repositories
{
    public interface IShoppingCartRepository
    {
        public Task<String[]> GetRequiredIngredientsForHouseholdMealAsync(DateTime from, DateTime to, Guid householdId);
    }
}
