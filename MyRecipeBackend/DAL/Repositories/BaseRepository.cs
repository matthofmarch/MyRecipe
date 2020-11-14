using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using Core.Entities;
using DAL;
using Devices.Core.Contracts;
using Microsoft.EntityFrameworkCore;

namespace Devices.Persistence.Repositories
{
    public class BaseRepository<T>: IBaseRepository<T> where T:EntityObject
    {
        protected readonly ApplicationDbContext _dbContext;

        public BaseRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }
        public async Task<T[]> AllAsync()
        {
            return await _dbContext.Set<T>().ToArrayAsync();
        }

        public async Task<T> FindAsync(int id)
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
            _dbContext.Update(entity);
        }

        public async Task<bool> AnyAsync(Expression<Func<T, bool>> lambda)
        {
            return await _dbContext.Set<T>().AnyAsync(lambda);
        }
    }
}
