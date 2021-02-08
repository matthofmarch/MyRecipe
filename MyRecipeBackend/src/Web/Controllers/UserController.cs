using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Models.User;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Web.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUnitOfWork _uow;
        private readonly UserManager<ApplicationUser> _userManger;
        private readonly ILogger _logger;


        public UserController(IUnitOfWork uow, UserManager<ApplicationUser> userManger, ILogger<UserController> logger)
        {
            _uow = uow;
            _userManger = userManger;
            _logger = logger;
        }


        /// <summary>
        /// Leave the group the user is currently in
        /// </summary>
        /// <returns></returns>
        [HttpPut("leaveGroup")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> LeaveGroup()
        {
            var user = await _userManger.GetUserAsync(User);
            if (user == null)
                return BadRequest("User not found");
            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (group == null)
                return BadRequest("User not in a Group");

            user.Group = null;
            try
            {
                await _uow.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed while trying to leave group");
                return BadRequest("Could not leave Group");
            }
            return Ok();
        }


        /// <summary>
        /// Change a users admin status and/or kick him from a group (user has to be the admin of the group)
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPut]
        [Authorize(Roles = "Admin")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> UpdateMembership(UpdateUserModel model)
        {
            var adminuser = await _userManger.GetUserAsync(User);
            if (adminuser == null || model == null)
                return BadRequest("User not found or model undefined");
            var admingroup = await _uow.Groups.GetGroupForUserAsync(adminuser.Id);
            if (admingroup == null)
                return BadRequest("User not in a Group");

            var user = await _uow.Users.GetByEmailAsync(model.Email);

            if (user == null)
                return BadRequest("User to change does not exist");

            if (user.Group.Id != admingroup.Id)
                return BadRequest("User is not in the same group as the admin");

            user.IsAdmin = model.IsAdmin;
            if (model.KickFromGroup)
                user.Group = null;

            try
            {
                await _uow.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed while trying to leave group");
                return BadRequest("Could not leave Group");
            }
            return Ok();
        }
    }
}
