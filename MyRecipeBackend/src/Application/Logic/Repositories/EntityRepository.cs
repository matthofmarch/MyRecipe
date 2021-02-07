using System;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Interfaces.Repositories;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Logic.Repositories
{
    public class EntityRepository<T>: IEntityRepository<T> where T:EntityObject
    {
        protected readonly IApplicationDbContext _dbContext;

        public EntityRepository(IApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }
        public async Task<T[]> AllAsync()
        {
            return await _dbContext.Set<T>().ToArrayAsync();
        }

        public async Task<T> FindAsync(Guid id)
        {
            return await _dbContext.Set<T>().FindAsync(id);
        }

        public async Task AddAsync(T entity)
        {
            await _dbContext.Set<T>().AddAsync(entity);
        }

        public void Remove(T entity)
        {
            _dbContext.Set<T>().Remove(entity);
        }

        public void Update(T entity)
        {
            _dbContext.Set<T>().Update(entity);
        }

        public async Task<bool> AnyAsync(Expression<Func<T, bool>> lambda)
        {
            return await _dbContext.Set<T>().AnyAsync(lambda);
        }
    }
}
