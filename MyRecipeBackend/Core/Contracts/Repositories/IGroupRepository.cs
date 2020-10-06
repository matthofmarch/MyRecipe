using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Core.Entities;

namespace Core.Contracts
{
    public interface IGroupRepository
    {
        Task AddAsync(Group group);
        Task<Group> GetGroupForUserAsync(string userId);
        Task<Group> GetGroupForInviteCodeAsync(string inviteCode);
        Task<Group> GetGroupForUserIncludeAllAsync(string userId);
        Task<UserRecipe> GetNextRecipeRecommendationForGroupAsync(string userId, Guid[] prevRecipeIds);
    }
}
