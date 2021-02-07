using System;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace MyRecipe.Application.Common.Interfaces.Repositories
{
    public interface IEntityRepository<T>
    {
        Task<T[]> AllAsync();
        Task<T> FindAsync(Guid id);
        Task AddAsync(T entity);
        void Remove(T entity);
        void Update(T entity);
        Task<bool> AnyAsync(Expression<Func<T, bool>> lambda);
    }

}
