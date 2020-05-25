using Core.Entities;
using System;
using System.Threading.Tasks;

namespace Core.Contracts
{
    public interface IUserRecipeRepository
    {
        Task AddAsync(UserRecipe userRecipe);
        Task<UserRecipe[]> GetPagedRecipesAsync(ApplicationUser user, string filter, int page, int pageSize, bool loadImage);
        Task<UserRecipe> GetByIdAsync(ApplicationUser user, Guid id);
        void Delete(UserRecipe userRecipe); 
    }
}