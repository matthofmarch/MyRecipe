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
    class RecipeRepository :BaseRepository<Recipe>, IRecipeRepository
    {
        public RecipeRepository(ApplicationDbContext dbContext):base(dbContext)
        {
        }

        public void Delete(Recipe recipe)
        {
            _dbContext.Recipes.Remove(recipe);
        }

        public Task<Recipe> GetByIdAsync(ApplicationUser user, Guid id)
        {
            return _dbContext.Recipes
                .SingleOrDefaultAsync(r => r.User.Id == user.Id && r.Id == id);
        }

        public async Task<Recipe[]> GetPagedRecipesAsync(ApplicationUser user, string filter, int page, int pageSize)
        {
            var query = _dbContext.Recipes
                .Where(r => r.User.Id == user.Id);
                


            if (filter != null)
            {
                query = query.Where(r => r.Name.Contains(filter));
            }

            query = query
                .OrderBy(r => r.Name)
                .Include(r => r.Ingredients);

            return await query.Skip(page * pageSize).Take(pageSize).ToArrayAsync();
        }
    }
}
