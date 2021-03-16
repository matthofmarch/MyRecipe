using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Microsoft.Extensions.Logging;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Models.Mealplan;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Web.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class MealVoteController : ControllerBase
    {
        private readonly ILogger _logger;

        private readonly IUnitOfWork _uow;
        private readonly UserManager<ApplicationUser> _userManager;

        public MealVoteController(IUnitOfWork uow, UserManager<ApplicationUser> userManager, ILogger<MealVoteController> logger)
        {
            _uow = uow;
            _userManager = userManager;
            _logger = logger;
        }

        /// <summary>
        ///     Vote for a meal that has been proposed
        /// </summary>
        /// <param name="voteRequestModel"></param>
        /// <returns></returns>
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult> VoteMeal(VoteRequestModel voteRequestModel)
        {
            if (!ModelState.IsValid) return BadRequest();

            var user = await _userManager.GetUserAsync(User);
            await _uow.Meals.VoteMealAsync(user.Id, voteRequestModel.VoteEnum, voteRequestModel.MealId);

            try
            {
                await _uow.SaveChangesAsync();
            }
            catch (Exception e)
            {
                var errMsg = "Could not vote for meal";
                _logger.LogError($"{errMsg}: {e.Message}");
                return BadRequest(errMsg);
            }

            return Ok();
        }
    }
}