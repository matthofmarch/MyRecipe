using System;
using System.Collections.Generic;
using System.Text;
using Core.Contracts;
using DAL.Data;

namespace DAL.Repositories
{
    class IngredientRepository : IIngredientRepository
    {
        private readonly ApplicationDbContext _dbContext;
        public IngredientRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }
    }
}
