﻿using System;
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
    public class GroupRepository : BaseRepository<Group>,IGroupRepository
    {

        public GroupRepository(ApplicationDbContext dbContext):base(dbContext)
        {
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
    }
}
