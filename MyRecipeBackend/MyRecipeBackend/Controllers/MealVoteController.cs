using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using MyRecipeBackend.Models.Mealplan;
using Microsoft.AspNetCore.Authorization;

namespace MyRecipeBackend.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class MealVoteController : ControllerBase
    {

        private readonly IUnitOfWork _uow;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ILogger _logger;

        public MealVoteController(IUnitOfWork uow, UserManager<ApplicationUser> userManager, ILogger<MealProposeController> logger)
        {
            _uow = uow;
            _userManager = userManager;
            _logger = logger;
        }

        /// <summary>
        /// Vote for a meal that has been proposed
        /// </summary>
        /// <param name="voteRequestModel"></param>
        /// <returns></returns>
        [HttpPost()]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult> VoteMeal(VoteRequestModel voteRequestModel)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest();
            }

            var user = await _userManager.GetUserAsync(User);
            await _uow.Meals.VoteMealAsync(user, voteRequestModel.VoteEnum, voteRequestModel.MealId);

            try
            {
                await _uow.SaveChangesAsync();
            }
            catch (Exception e)
            {
                string errMsg = "Could not vote for meal";
                _logger.LogError($"{errMsg}: {e.Message}");
                return BadRequest(errMsg);
            }

            return Ok();
        }
    }
}
