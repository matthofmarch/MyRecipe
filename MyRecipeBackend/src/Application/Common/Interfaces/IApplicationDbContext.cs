using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.EntityFrameworkCore.Infrastructure;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Common.Interfaces
{
    public interface IApplicationDbContext
    {
        DbSet<Meal> Meals { get; }
        DbSet<MealVote> MealVotes { get; }
        DbSet<Group> Groups { get; }
        DbSet<InviteCode> InviteCodes { get; }
        DbSet<Recipe> Recipes { get; }
        DbSet<Ingredient> Ingredients { get; }
        DbSet<ApplicationUser> Users { get; }

        ChangeTracker ChangeTracker { get; }
        DatabaseFacade Database { get; }
        DbSet<IdentityUserToken<string>> UserTokens { get; }

        DbSet<TEntity> Set<TEntity>()
            where TEntity : class;

        void Dispose();
        ValueTask DisposeAsync();
        Task<int> SaveChangesAsync(CancellationToken cancellationToken = new());
    }
}