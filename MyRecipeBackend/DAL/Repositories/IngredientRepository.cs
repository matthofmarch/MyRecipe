using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;
using DAL;
using Devices.Persistence.Repositories;
using Microsoft.EntityFrameworkCore;

namespace DAL.Repositories
{
    class IngredientRepository :EntityRepository<Ingredient>, IIngredientRepository
    {
        public IngredientRepository(ApplicationDbContext dbContext):base(dbContext)
        {
        }

        public Task<Ingredient> GetByNameAsync(string identifier)
        {
            return _dbContext.Ingredients.SingleAsync(i => i.Name == identifier);
        }

        public async Task<Ingredient[]> GetListByNamesAsync(string[] identifiers)
        {
            return await _dbContext.Ingredients.Where(x => identifiers.Contains(x.Name)).ToArrayAsync();
        }

        public async Task<Ingredient[]> GetListByIdsAsync(Guid[] ids)
        {
            return await _dbContext.Ingredients
                .Where(i => ids.Contains(i.Id)).ToArrayAsync();
        }
    }
}
