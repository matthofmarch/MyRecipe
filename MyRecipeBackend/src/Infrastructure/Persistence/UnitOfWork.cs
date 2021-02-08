using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Interfaces.Repositories;
using MyRecipe.Application.Logic.Repositories;

namespace MyRecipe.Infrastructure.Persistence
{
    /// <summary>
    /// 
    /// </summary>
    public class UnitOfWork : IUnitOfWork
    {
        private readonly IApplicationDbContext _dbContext;
        private bool _disposed;

        public UnitOfWork(IApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
            Groups = new GroupRepository(_dbContext);
            InviteCodes = new InviteCodeRepository(_dbContext);
            Recipes = new RecipeRepository(_dbContext);
            Ingredients = new IngredientRepository(_dbContext);
            Meals = new MealRepository(_dbContext);
            Users = new ApplicationUserRepository(_dbContext);
            ShoppingCart = new ShoppingCartRepository(_dbContext);
        }

        public IMealRepository Meals { get; }
        public IGroupRepository Groups { get; }
        public IInviteCodeRepository InviteCodes { get; }
        public IRecipeRepository Recipes { get; }
        public IIngredientRepository Ingredients { get; }
        public IApplicationUserRepository Users { get;  }
        public IShoppingCartRepository ShoppingCart { get; }

        public async Task<int> SaveChangesAsync()
        {
            var entities = _dbContext.ChangeTracker.Entries()
                .Where(entity => entity.State == EntityState.Added
                                 || entity.State == EntityState.Modified)
                .Select(e => e.Entity)
                .ToArray();  // Geänderte Entities ermitteln
            foreach (var entity in entities)
            {
                var validationContext = new ValidationContext(entity, null, null);
                if (entity is IValidatableObject)
                {     // UnitOfWork injizieren, wenn Interface implementiert ist
                    validationContext.InitializeServiceProvider(serviceType => this);
                }

                var validationResults = new List<ValidationResult>();
                var isValid = Validator.TryValidateObject(entity, validationContext, validationResults,
                    validateAllProperties: true);
                if (!isValid)
                {
                    var memberNames = new List<string>();
                    List<ValidationException> validationExceptions = new List<ValidationException>();
                    foreach (ValidationResult validationResult in validationResults)
                    {
                        validationExceptions.Add(new ValidationException(validationResult, null, null));
                        memberNames.AddRange(validationResult.MemberNames);
                    }

                    if (validationExceptions.Count == 1)  // eine Validationexception werfen
                    {
                        throw validationExceptions.Single();
                    }
                    else  // AggregateException mit allen ValidationExceptions als InnerExceptions werfen
                    {
                        throw new ValidationException($"Entity validation failed for {string.Join(", ", memberNames)}",
                            new AggregateException(validationExceptions));
                    }
                }
            }
            return await _dbContext.SaveChangesAsync();
        }

        public async Task DeleteDatabaseAsync() => await _dbContext.Database.EnsureDeletedAsync();
        public async Task MigrateDatabaseAsync() => await _dbContext.Database.MigrateAsync();
        public async Task CreateDatabaseAsync() => await _dbContext.Database.EnsureCreatedAsync();

        public async ValueTask DisposeAsync()
        {
            await DisposeAsync(true);
            GC.SuppressFinalize(this);
        }

        protected virtual async ValueTask DisposeAsync(bool disposing)
        {
            if (!_disposed)
            {
                if (disposing)
                {
                    await _dbContext.DisposeAsync();
                }
            }
            _disposed = true;
        }

        public void Dispose()
        {
            _dbContext?.Dispose();
        }
    }
}
