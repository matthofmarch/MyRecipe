using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Models.Mealplan;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Web.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class MealProposeController : Controller
    {
        private readonly ILogger _logger;
        private readonly IUnitOfWork _uow;
        private readonly UserManager<ApplicationUser> _userManager;

        public MealProposeController(IUnitOfWork uow, UserManager<ApplicationUser> userManager,
            ILogger<MealProposeController> logger)
        {
            _uow = uow;
            _userManager = userManager;
            _logger = logger;
        }

        /// <summary>
        ///     Propose a recipe to be used in the selection process
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<ActionResult> ProposeMeal(ProposeInputModel model)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user is null)
            {
                var errMsg = "User not found";
                _logger.LogError(errMsg);
                return Forbid(errMsg);
            }

            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (group is null)
            {
                var errMsg = "No group found for user";
                _logger.LogError(errMsg);
                return Forbid(errMsg);
            }

            var meal = new Meal
            {
                DateTime = model.Day,
                RecipeId = model.RecipeId,
                Initiator = user,
                Group = group
            };
            await _uow.Meals.ProposeMealAsync(meal);

            try
            {
                await _uow.SaveChangesAsync();
            }
            catch (Exception e)
            {
                var errMsg = "Could not propose Meal";
                _logger.LogError($"{errMsg}: {e.Message}");
                return BadRequest("Could not propose Meal");
            }

            return Ok();
        }

        /// <summary>
        ///     Gets all the meals that have been proposed but not accepted
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<MealDto[]>> GetProposedMeals()
        {
            var user = await _userManager.GetUserAsync(User);
            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (user is null || group is null) return BadRequest();

            var meals = await _uow.Meals.GetMealsWithRecipeAndInitiatorAsync(group.Id, false);

            var proposedMealList =
                meals.Select(m => new MealDto(m)).ToArray();

            return Ok(proposedMealList);
        }
    }
}