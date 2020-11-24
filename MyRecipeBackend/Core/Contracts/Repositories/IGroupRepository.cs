using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Core.Entities;
using Devices.Core.Contracts;

namespace Core.Contracts
{
    public interface IGroupRepository:IBaseRepository<Group>
    {
        Task<Group> GetGroupForUserAsync(string userId);
        Task<Group> GetGroupForInviteCodeAsync(string inviteCode);
        Task<Group> GetGroupForUserIncludeAllAsync(string userId);
        Task<Recipe> GetNextRecipeRecommendationForGroupAsync(string userId, Guid[] prevRecipeIds);
        Task<bool> CheckIsUserAdmin(string userId, Guid groupId);
    }
}
