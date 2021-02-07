using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Core.Contracts.Repositories;

namespace Core.Contracts
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