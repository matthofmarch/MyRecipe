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
        IBaseRecipeRepository BaseRecipes { get; }
        IUserRecipeRepository UserRecipes { get; }
        IIngredientRepository Ingredients { get; }

        Task<int> SaveChangesAsync();
        Task DeleteDatabaseAsync();
        Task MigrateDatabaseAsync();
        Task CreateDatabaseAsync();
    }
}