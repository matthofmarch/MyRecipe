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
    public class MealplanController : ControllerBase
    {
        private readonly ILogger _logger;
        private readonly IUnitOfWork _uow;
        private readonly UserManager<ApplicationUser> _userManager;

        public MealplanController(IUnitOfWork uow, UserManager<ApplicationUser> userManager,
            ILogger<MealplanController> logger)
        {
            _uow = uow;
            _userManager = userManager;
            _logger = logger;
        }

        /// <summary>
        ///     Get all the meals that have been accepted
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<MealDto[]>> GetMeals(bool? accepted)
        {
            var user = await _userManager.GetUserAsync(User);
            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (user is null || group is null) return BadRequest();

            var meals = await _uow.Meals.GetMealsWithRecipeAndInitiatorAsync(group.Id, accepted);

            var proposedMealList =
                meals.Select(m => new MealDto(m)).ToArray();

            return Ok(proposedMealList);
        }

        /// <summary>
        ///     Get a meal by its id (has to be owned by the users group of course).
        ///     Does not matter if it is accepted or not
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<MealDto>> GetMealById(Guid id)
        {
            var user = await _userManager.GetUserAsync(User);
            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (user is null || group is null) return BadRequest();

            var meal = await _uow.Meals.GetMealByIdAsync(group.Id, id);

            if (meal == null)
                return NotFound($"Meal with id {id} does not exist");

            return new MealDto(meal);
        }

        /// <summary>
        ///     Accept a meal as an admin (probably the one with the highest vote count
        /// </summary>
        /// <param name="mealId"></param>
        /// <param name="accepted"></param>
        /// <returns></returns>
        [HttpPut("accept/{mealId}")]
        [Authorize(Roles = "Admin")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<ActionResult<MealDto>> AcceptMealById(Guid mealId, bool accepted)
        {
            var user = await _userManager.GetUserAsync(User);
            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (user is null || group is null) return BadRequest();

            if (!await _uow.Groups.CheckIsUserAdmin(user.Id, group.Id))
            {
                var errMsg = "User is not an Admin";
                return Forbid(errMsg);
            }

            var meal = await _uow.Meals.GetMealByIdAsync(group.Id, mealId);
            if (meal == null)
                return BadRequest("Meal with given id not found");
            meal.Accepted = accepted;
            try
            {
                await _uow.SaveChangesAsync();
            }
            catch (Exception e)
            {
                _logger.LogError(e.Message);

                return BadRequest("Could not accept meal");
            }

            return new MealDto(meal);
        }


        /// <summary>
        ///     Delete a meal as an admin (doesnt matter if it is accepted or not)
        /// </summary>
        /// <param name="id">Id of the meal to delete</param>
        /// <returns></returns>
        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<ActionResult> DeleteMeal(Guid id)
        {
            var user = await _userManager.GetUserAsync(User);
            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (user is null || group is null) return BadRequest();

            if (!await _uow.Groups.CheckIsUserAdmin(user.Id, group.Id))
            {
                var errMsg = "User is not an Admin";
                return Forbid(errMsg);
            }

            var meal = await _uow.Meals.FindAsync(id);
            if (meal == null) return NotFound();

            _uow.Meals.Remove(meal);

            try
            {
                await _uow.SaveChangesAsync();
            }
            catch (Exception e)
            {
                _logger.LogError(e, "Error when trying to delete meal");
                return BadRequest("Could not delete meal");
            }

            return NoContent();
        }
    }
}