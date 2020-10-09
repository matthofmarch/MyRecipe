using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;
using DAL;
using Microsoft.EntityFrameworkCore;

namespace DAL.Repositories
{
    class IngredientRepository : IIngredientRepository
    {
        private readonly ApplicationDbContext _dbContext;
        public IngredientRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<Ingredient> AddAsync(Ingredient ingredient)
        {
            var inserted = await _dbContext.Ingredients.AddAsync(ingredient);
            return inserted.Entity;
        }

        public Task<Ingredient> GetByIdentifierAsync(string identifier)
        {
            return _dbContext.Ingredients.SingleAsync(i => i.Name == identifier);
        }

        public async Task<Ingredient[]> GetListByIdentifiersAsync(string[] identifiers)
        {
            return await _dbContext.Ingredients.Where(x => identifiers.Contains(x.Name)).ToArrayAsync();
        }
    }
}
