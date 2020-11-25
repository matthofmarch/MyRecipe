using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Devices.Core.Contracts
{
    public interface IBaseRepository<T>
    {
        Task<T[]> AllAsync();
        Task<T> FindAsync(Guid id);
        Task AddAsync(T entity);
        void Remove(T entity);
        void Update(T entity);
        Task<bool> AnyAsync(Expression<Func<T, bool>> lambda);
    }

}
