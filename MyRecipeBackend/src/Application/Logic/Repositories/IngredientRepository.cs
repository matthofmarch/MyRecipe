using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Interfaces.Repositories;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Logic.Repositories
{
    public class IngredientRepository : EntityRepository<Ingredient>, IIngredientRepository
    {
        public IngredientRepository(IApplicationDbContext dbContext) : base(dbContext)
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