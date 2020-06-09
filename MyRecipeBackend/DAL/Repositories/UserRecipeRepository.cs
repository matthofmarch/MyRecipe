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
                .SingleOrDefaultAsync(r => r.User.Id == user.Id && r.Id == id);
        }

        public async Task<UserRecipe[]> GetPagedRecipesAsync(ApplicationUser user, string filter, int page, int pageSize)
        {
            var query = _dbContext.UserRecipes
                .Where(r => r.User.Id == user.Id);

            if(filter != null)
            {
                query = query.Where(r => r.Name.Contains(filter));
            }

            query = query.OrderBy(r => r.Name);
            
            query = query.Include(r => r.Ingredients)
                .ThenInclude(ri => ri.Ingredient);


            return await query.Skip(page * pageSize).Take(pageSize).ToArrayAsync();
        }

        public async Task RemoveIngredients(Guid recipeId)
        {
            var relations = await _dbContext.RecipeIngredientRelations
                .Where(ri => ri.RecipeId == recipeId)
                .ToArrayAsync();
            _dbContext.RecipeIngredientRelations.RemoveRange(relations);
        }
    }
}
