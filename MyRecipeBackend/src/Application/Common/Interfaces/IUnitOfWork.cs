using System;
using System.Threading.Tasks;
using MyRecipe.Application.Common.Interfaces.Repositories;

namespace MyRecipe.Application.Common.Interfaces
{
    public interface IUnitOfWork : IAsyncDisposable
    {
        IMealRepository Meals { get; }
        IGroupRepository Groups { get; }
        IInviteCodeRepository InviteCodes { get; }
        IRecipeRepository Recipes { get; }
        IIngredientRepository Ingredients { get; }
        IApplicationUserRepository Users { get; }
        IShoppingCartRepository ShoppingCart { get; }

        Task<int> SaveChangesAsync();
        Task DeleteDatabaseAsync();
        Task MigrateDatabaseAsync();
        Task CreateDatabaseAsync();
    }
}