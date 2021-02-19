using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Interfaces.Repositories;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Logic.Repositories
{
    public class InviteCodeRepository : EntityRepository<InviteCode>, IInviteCodeRepository
    {
        public InviteCodeRepository(IApplicationDbContext dbContext) : base(dbContext)
        {
        }

        public async Task<bool> InviteCodeExistsAsync(string inviteCode)
        {
            var dbCode = await _dbContext.InviteCodes.FirstOrDefaultAsync(i => i.Code == inviteCode);
            return dbCode != null;
        }

        public async Task Delete(string code)
        {
            var inviteCode = await _dbContext.InviteCodes
                .Where(i => i.Code == code)
                .SingleOrDefaultAsync();
            if (inviteCode != null)
                _dbContext.InviteCodes.Remove(inviteCode);
        }
    }
}