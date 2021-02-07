using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Models.Group;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Web.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class GroupController : ControllerBase
    {
        private readonly IUnitOfWork _uow;
        private readonly UserManager<ApplicationUser> _userManger;

        public GroupController(IUnitOfWork uow, UserManager<ApplicationUser> userManger)
        {
            _uow = uow;
            _userManger = userManger;
        }

        /// <summary>
        /// Create a new group
        /// </summary>
        /// <param name="input">Name of the new group</param>
        /// <returns>group</returns>
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<GroupDto>> CreateGroup(CreateGroupModel input)
        {
            var user = await _userManger.GetUserAsync(User);
            if (user == null)
                return BadRequest("User not found");

            var group = new Group() { Name = input.Name};
            user.Group = group;
            user.IsAdmin = true;

            try
            {
                await _uow.SaveChangesAsync();
            }
            catch (ValidationException ex)
            {
                return BadRequest(ex.Message);
            }

            return CreatedAtAction(nameof(GetGroup), new GroupDto(group));
        }

        /// <summary>
        /// Get group for user
        /// </summary>
        /// <returns>Group for the loggend in user</returns>
        [HttpGet("getGroupForUser")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        public async Task<ActionResult<GroupDto>> GetGroup()
        {
            var user = await _userManger.GetUserAsync(User);
            if (user == null) return BadRequest("User not found");

            var group = await _uow.Groups.GetGroupForUserIncludeAllAsync(user.Id);
            if (group == null) return NoContent();

            return new GroupDto(group);
        }

    }
}