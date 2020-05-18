using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;
using DAL.Data;
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

        public Task<Ingredient> GetByIdentifierAsync(string identifier)
        {
            return _dbContext.Ingredients.SingleAsync(i => i.Name == identifier);
        }

        public Task<Ingredient[]> GetListByIdentifiersAsync(string[] indentifiers)
        {
            return Task.WhenAll(indentifiers.Select(i => GetByIdentifierAsync(i)));
        } 
    }
}
