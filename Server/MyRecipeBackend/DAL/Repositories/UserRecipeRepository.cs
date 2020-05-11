using System;
using System.Collections.Generic;
using System.Text;
using Core.Contracts;
using DAL.Data;

namespace DAL.Repositories
{
    class UserRecipeRepository : IUserRecipeRepository
    {
        private readonly ApplicationDbContext _dbContext;
        public UserRecipeRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }
    }
}
