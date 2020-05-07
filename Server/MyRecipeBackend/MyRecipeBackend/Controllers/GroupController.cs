using System;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
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

        public GroupController(IUnitOfWork uow)
        {
            _uow = uow;
        }

        [HttpPost]
        [Route("create")]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<GroupDto>> CreateGroup(string name)
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (userId == null)
                return BadRequest("Token corrupted");
            var user = await _uow.Users.GetUserByIdAsync(userId);
            if (user == null)
                return BadRequest("User not found");

            var group = new Group() { Name = name };
            user.Group = group;

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

        [HttpGet]
        [Route("createInviteCode")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<InviteCode>> CreateInviteCode()
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (userId == null)
                return BadRequest("Token corrupted");
            var user = await _uow.Users.GetUserByIdAsync(userId);
            if (user == null)
                return BadRequest("User not found");

            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (group == null)
                return BadRequest("User not in Group");

            var inviteCode = new InviteCode
            {
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

        [HttpGet]
        [Route("acceptInviteCode")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> AcceptInvite(string inviteCode)
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (userId == null)
                return BadRequest("Token corrupted");
            var user = await _uow.Users.GetUserByIdAsync(userId);
            if (user == null)
                return BadRequest("User not found");

            var group = await _uow.Groups.GetGroupForInviteCodeAsync(inviteCode.ToUpper());
            if (group == null)
                return BadRequest("Invite Code does not belong to group");

            group.Members.Add(user);
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

        [HttpGet]
        [Route("getGroupForUser")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        public async Task<ActionResult<GroupDto>> GetGroup()
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (userId == null)
                return BadRequest("Token corrupted");
            var user = await _uow.Users.GetUserByIdAsync(userId);
            if (user == null)
                return BadRequest("User not found");

            var group = await _uow.Groups.GetGroupForUserIncludeAllAsync(user.Id);
            if (group == null)
                return NoContent();

            return new GroupDto(group);
        }

        private string GenerateInviteCode(int length = 6)
        {
            var rnd = new Random();
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            return new string(Enumerable.Range(1,length)
                .Select(_ => chars[rnd.Next(chars.Length)])
                .ToArray());

        }
    }
}