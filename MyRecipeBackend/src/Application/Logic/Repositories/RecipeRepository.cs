using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Interfaces.Repositories;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Logic.Repositories
{
    public class RecipeRepository :EntityRepository<Recipe>, IRecipeRepository
    {
        public RecipeRepository(IApplicationDbContext dbContext):base(dbContext)
        {
        }

        public void Delete(Recipe recipe)
        {
            _dbContext.Recipes.Remove(recipe);
        }

        public async Task<Recipe[]> GetPagedRecipesForGroupAsync(ApplicationUser user, string filter, int page, int pageSize, Guid groupId)
        {
            var query = _dbContext.Groups
                .Where(g => g.Id == groupId)
                .SelectMany(g => g.Members)
                .SelectMany(u => u.Recipes);

            if (filter != null)
            {
                query = query.Where(r => r.Name.Contains(filter));
            }

            query = query
                .OrderBy(r => r.Name)
                .Include(r => r.Ingredients)
                .Include(r => r.User);

            return await query.Skip(page * pageSize).Take(pageSize).ToArrayAsync();
        }

        public Task<Recipe> GetByIdAsync(ApplicationUser user, Guid id)
        {
            return _dbContext.Recipes
                .Include(r => r.Ingredients)
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
