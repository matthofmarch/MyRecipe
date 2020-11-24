using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;
using DAL;
using Devices.Persistence.Repositories;
using Microsoft.EntityFrameworkCore;

namespace DAL.Repositories
{
    public class InviteCodeRepository: BaseRepository<InviteCode>, IInviteCodeRepository
    {
        public InviteCodeRepository(ApplicationDbContext dbContext):base(dbContext)
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
            if(inviteCode != null)
                _dbContext.Remove(inviteCode);
        }

    }
}
