using System;
using System.ComponentModel.DataAnnotations;
using System.Linq;
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
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IUnitOfWork _uow;

        public GroupController(UserManager<ApplicationUser> userManager, IUnitOfWork uow)
        {
            _userManager = userManager;
            _uow = uow;
        }

        [HttpPost]
        [Route("create")]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<GroupDto>> CreateGroup(string name)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null)
                return BadRequest("User not found");

            var group = new Group() { Name = name };
            group.Members.Add(user);
            await _uow.Groups.AddAsync(group);

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
            var user = await _userManager.GetUserAsync(User);
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

            return Ok(inviteCode);
        }

        [HttpGet]
        [Route("acceptInviteCode")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> AcceptInvite(string inviteCode)
        {
            var user = await _userManager.GetUserAsync(User);
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
        public async Task<ActionResult<GroupDto>> GetGroup()
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null)
                return BadRequest("User not found");

            var group = await _uow.Groups.GetGroupForUserIncludeAllAsync(user.Id);

            //TODO Member Dto
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