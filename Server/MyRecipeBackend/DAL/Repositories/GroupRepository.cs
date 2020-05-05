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
    public class GroupRepository: IGroupRepository
    {
        private readonly ApplicationDbContext _dbContext;
        public GroupRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task AddAsync(Group group)
        {
            await _dbContext.AddAsync(group);
        }

        public Task<Group> GetGroupForUserAsync(string userId)
        {
            return _dbContext.Users
                .Where(u => u.Id == userId)
                .Select(u => u.Group)
                .SingleOrDefaultAsync();

        }

        public Task<Group> GetGroupForInviteCodeAsync(string inviteCode)
        {
            return _dbContext.InviteCodes
                .Where(i => i.Code == inviteCode)
                .Select(i => i.Group)
                .SingleOrDefaultAsync();

        }

        public Task<Group> GetGroupForUserIncludeAllAsync(string userId)
        {
            return _dbContext.Users
                .Include(u => u.Group)
                .ThenInclude(g => g.Members)
                .Where(u => u.Id == userId)
                .Select(u => u.Group)
                .SingleOrDefaultAsync();
        }
    }
}
