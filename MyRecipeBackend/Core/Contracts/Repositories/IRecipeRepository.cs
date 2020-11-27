using Core.Entities;
using System;
using System.Threading.Tasks;
using Devices.Core.Contracts;

namespace Core.Contracts
{
    public interface IRecipeRepository:IBaseRepository<Recipe>
    {
        Task<Recipe[]> GetPagedRecipesAsync(ApplicationUser user, string filter, int page, int pageSize);
        Task<Recipe> GetByIdAsync(ApplicationUser user, Guid id);
        void Delete(Recipe recipe);
    }
}