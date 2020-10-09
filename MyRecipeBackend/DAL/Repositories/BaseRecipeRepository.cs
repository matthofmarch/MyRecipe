using System;
using System.Collections.Generic;
using System.Text;
using Core.Contracts;
using DAL;

namespace DAL.Repositories
{
    class BaseRecipeRepository : IBaseRecipeRepository
    {
        private readonly ApplicationDbContext _dbContext;
        public BaseRecipeRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }
    }
}
