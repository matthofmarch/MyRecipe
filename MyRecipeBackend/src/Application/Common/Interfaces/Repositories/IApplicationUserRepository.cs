using System.Threading.Tasks;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Common.Interfaces.Repositories
{
    public interface IApplicationUserRepository
    {
        Task<ApplicationUser> GetByEmailAsync(string email);
    }
}
