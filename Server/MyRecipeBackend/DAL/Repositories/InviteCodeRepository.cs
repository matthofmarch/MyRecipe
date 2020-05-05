using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;
using DAL.Data;
using Microsoft.EntityFrameworkCore;

namespace DAL.Repositories
{
    public class InviteCodeRepository: IInviteCodeRepository
    {
        private readonly ApplicationDbContext _dbContext;
        public InviteCodeRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
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
