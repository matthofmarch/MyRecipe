using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using MyRecipeBackend.Data;
using MyRecipeBackend.Entities;

namespace MyRecipeBackend.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class GroupController : ControllerBase
    {
        private readonly ApplicationDbContext _dbContext;
        private readonly UserManager<ApplicationUser> _userManager;

        public GroupController(ApplicationDbContext dbContext, UserManager<ApplicationUser> userManager)
        {
            _dbContext = dbContext;
            _userManager = userManager;
        }

        [HttpPost]
        [Route("create")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> Create(string name)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null)
                return BadRequest("User not found");

            var group = new Group() {Name = name};
            group.Members.Add(user);

            await _dbContext.Groups.AddAsync(group);
            await _dbContext.SaveChangesAsync();

            return Ok("Created group and added user to group");
        }

        [HttpGet]
        [Route("generateInviteCode")]
        public async Task<ActionResult<InviteCode>> GenerateInviteCode()
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null)
                return BadRequest("User not found");

            throw new NotImplementedException();
            
        }


    }
}