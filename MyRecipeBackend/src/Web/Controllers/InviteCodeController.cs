using System;
using System.ComponentModel.DataAnnotations;
using System.Linq;
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
    public class InviteCodeController : ControllerBase
    {
        private readonly IUnitOfWork _uow;
        private readonly UserManager<ApplicationUser> _userManger;

        public InviteCodeController(IUnitOfWork uow, UserManager<ApplicationUser> userManger)
        {
            _uow = uow;
            _userManger = userManger;
        }

        /// <summary>
        ///     Create a new invite code for the group the user is in
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<InviteCodeDto>> CreateInviteCode()
        {
            var user = await _userManger.GetUserAsync(User);
            if (user == null) return BadRequest("User not found");

            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (group == null) return BadRequest("User not in Group");

            var inviteCode = new InviteCode
            {
                //TODO generate as often until unique
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

        /// <summary>
        ///     Accept an invite code in order to join group
        /// </summary>
        /// <param name="inviteCode"></param>
        /// <returns></returns>
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

        private static string GenerateInviteCode(int length = 6)
        {
            var rnd = new Random();
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            return new string(Enumerable.Range(1, length)
                .Select(_ => chars[rnd.Next(chars.Length)])
                .ToArray());
        }
    }
}