using System.Threading.Tasks;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Common.Interfaces.Repositories
{
    public interface IInviteCodeRepository:IEntityRepository<InviteCode>
    {
        Task<bool> InviteCodeExistsAsync(string inviteCode);
        Task Delete(string code);
    }
}
