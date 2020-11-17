using System;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using MyRecipeBackend.Models;

namespace MyRecipeBackend.Controllers
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

        [HttpPost("create")]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<GroupDto>> CreateGroup(string name)
        {
            var user = await _userManger.GetUserAsync(User);
            if (user == null)
                return BadRequest("User not found");

            var group = new Group() { Name = name};
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

        [HttpGet("createInviteCode")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<InviteCode>> CreateInviteCode()
        {
            var user = await _userManger.GetUserAsync(User);
            if (user == null) return BadRequest("User not found");

            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (group == null) return BadRequest("User not in Group");

            var inviteCode = new InviteCode
            {   //TODO generate as often until unique
                Code = GenerateInviteCode(),
                CreationDate = DateTime.Now
            };

            group.InviteCodes.Add(inviteCode);

            try
            {
                await _uow.SaveChangesAsync();
            }
            catch (ValidationException ex)
            {
                return BadRequest(ex.Message);
            }

            return Ok(new InviteCodeDto(inviteCode));
        }

        [HttpGet("acceptInviteCode")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> AcceptInvite(string inviteCode)
        {
            var user = await _userManger.GetUserAsync(User);
            if (user == null) return BadRequest("User not found");

            var group = await _uow.Groups.GetGroupForInviteCodeAsync(inviteCode.ToUpper());
            if (group == null) return BadRequest("Invite Code does not belong to group");

            // TODO Review
            user.Group = group;
            user.IsAdmin = false;
            // group.Members.Add(user);
            await _uow.InviteCodes.Delete(inviteCode.ToUpper());

            try
            {
                await _uow.SaveChangesAsync();
            }
            catch (ValidationException ex)
            {
                return BadRequest(ex.Message);
            }

            return Ok();
        }

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

        private static string GenerateInviteCode(int length = 6)
        {
            var rnd = new Random();
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            return new string(Enumerable.Range(1,length)
                .Select(_ => chars[rnd.Next(chars.Length)])
                .ToArray());

        }
    }
}