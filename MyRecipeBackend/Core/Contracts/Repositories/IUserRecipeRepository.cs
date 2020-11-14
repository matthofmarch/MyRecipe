using Core.Entities;
using System;
using System.Threading.Tasks;
using Devices.Core.Contracts;

namespace Core.Contracts
{
    public interface IUserRecipeRepository:IBaseRepository<UserRecipe>
    {
        Task<UserRecipe[]> GetPagedRecipesAsync(ApplicationUser user, string filter, int page, int pageSize);
        Task<UserRecipe> GetByIdAsync(ApplicationUser user, Guid id);
        void Delete(UserRecipe userRecipe);
        public Task RemoveIngredients(Guid recipeId);
    }
}