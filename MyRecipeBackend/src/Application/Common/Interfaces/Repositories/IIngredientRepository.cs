using System;
using System.Threading.Tasks;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Common.Interfaces.Repositories
{
    public interface IIngredientRepository : IEntityRepository<Ingredient>
    {
        Task<Ingredient> GetByNameAsync(string identifier);

        Task<Ingredient[]> GetListByNamesAsync(string[] identifiers);

        Task<Ingredient[]> GetListByIdsAsync(Guid[] ids);
    }
}