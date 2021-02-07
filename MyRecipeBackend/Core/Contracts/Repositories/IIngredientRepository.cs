using System;
using Core.Entities;
using System.Threading.Tasks;
using Devices.Core.Contracts;

namespace Core.Contracts
{
    public interface IIngredientRepository:IEntityRepository<Ingredient>
    {
        Task<Ingredient> GetByNameAsync(string identifier);

        Task<Ingredient[]> GetListByNamesAsync(string[] identifiers);

        Task<Ingredient[]> GetListByIdsAsync(Guid[] ids);
    }
}