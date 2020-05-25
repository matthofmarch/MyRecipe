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
    class UserRecipeRepository : IUserRecipeRepository
    {
        private readonly ApplicationDbContext _dbContext;
        public UserRecipeRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task AddAsync(UserRecipe userRecipe )
        {
            await _dbContext.UserRecipes.AddAsync(userRecipe);
        }

        public void Delete(UserRecipe userRecipe)
        {
            _dbContext.UserRecipes.Remove(userRecipe);
        }

        public Task<UserRecipe> GetByIdAsync(ApplicationUser user, Guid id)
        {
            return _dbContext.UserRecipes
                .SingleOrDefaultAsync(r => r.ApplicationUser.Id == user.Id && r.Id == id);
        }

        public async Task<UserRecipe[]> GetPagedRecipesAsync(ApplicationUser user, string filter, int page, int pageSize, bool loadImage)
        {
            var query = _dbContext.UserRecipes
                .Where(r => r.ApplicationUser.Id == user.Id);

            if (loadImage)
            {
                query = query.Include(r => r.Image);
            }

            if(filter != null)
            {
                query = query.Where(r => r.Name.Contains(filter));
            }

            query = query.OrderBy(r => r.Name);
            
            query = query.Include(r => r.Ingredients)
                .ThenInclude(ri => ri.Ingredient);


            return await query.Skip(page * pageSize).Take(pageSize).ToArrayAsync();
        }
    }
}
