using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Interfaces.Repositories;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Logic.Repositories
{
    public class GroupRepository : EntityRepository<Group>, IGroupRepository
    {
        public GroupRepository(IApplicationDbContext dbContext) : base(dbContext)
        {
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

        public async Task<Recipe> GetNextRecipeRecommendationForGroupAsync(string userId, Guid[] prevRecipeIds)
        {
            IEnumerable<string> userGroup = await _dbContext.Users
                .Where(u => u.Id == userId)
                .SelectMany(u => u.Group.Members)
                .Select(u => u.Id)
                .ToArrayAsync();

            var query = _dbContext.Recipes
                .Where(r => userGroup.Contains(r.UserId) && !prevRecipeIds.Contains(r.Id))
                .Where(r => r.AddToGroupPool);
            var length = await query.CountAsync();

            if (length != 0)
            {
                query = query.Skip(new Random().Next(length));
                return await query
                    .Include(r => r.Ingredients)
                    .FirstAsync();
            }

            return null;
        }

        public async Task<bool> CheckIsUserAdmin(string userId, Guid groupId)
        {
            return await _dbContext.Users
                .AnyAsync(u => u.GroupId == groupId
                               && u.Id == userId
                               && u.IsAdmin);
        }
    }
}