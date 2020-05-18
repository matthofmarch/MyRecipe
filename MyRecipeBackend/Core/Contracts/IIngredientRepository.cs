using Core.Entities;
using System.Threading.Tasks;

namespace Core.Contracts
{
    public interface IIngredientRepository
    {
        Task<Ingredient> GetByIdentifierAsync(string identifier);

        Task<Ingredient[]> GetListByIdentifiersAsync(string[] indentifiers);

    }
}