using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Core.Contracts
{
    public interface IUnitOfWork : IAsyncDisposable
    {
        IGroupRepository Groups { get; }
        IInviteCodeRepository InviteCodes { get; }
        IUserRepository Users { get; }
        IBaseRecipeRepository BaseRecipes { get; }
        IUserRecipeRepository UserRecipes { get; }

        IIngredientRepository Ingredients { get; }

        Task<int> SaveChangesAsync();
        Task DeleteDatabaseAsync();
        Task MigrateDatabaseAsync();
        Task CreateDatabaseAsync();
    }
}
