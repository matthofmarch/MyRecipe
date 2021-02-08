using System;
using System.Threading.Tasks;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Common.Interfaces.Repositories
{
    public interface IGroupRepository:IEntityRepository<Group>
    {
        Task<Group> GetGroupForUserAsync(string userId);
        Task<Group> GetGroupForInviteCodeAsync(string inviteCode);
        Task<Group> GetGroupForUserIncludeAllAsync(string userId);
        Task<Recipe> GetNextRecipeRecommendationForGroupAsync(string userId, Guid[] prevRecipeIds);
        Task<bool> CheckIsUserAdmin(string userId, Guid groupId);
    }
}
