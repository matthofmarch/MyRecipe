using System;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;
using Core.Model;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using MyRecipeBackend.Models;
using MyRecipeBackend.Models.Mealplan;

namespace MyRecipeBackend.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class MealplanController : ControllerBase
    {
        private readonly IUnitOfWork _uow;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ILogger _logger;

        public MealplanController(IUnitOfWork uow, UserManager<ApplicationUser> userManager, ILogger<MealplanController> logger)
        {
            _uow = uow;
            _userManager = userManager;
            _logger = logger;
        }

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<MealDto[]>> GetPlannedMeals()
        {
            var user = await _userManager.GetUserAsync(User);
            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (user is null || group is null)
            {
                return BadRequest();
            }

            Meal[] meals = await _uow.Meals.GetMealsWithRecipeAndInitiatorAsync(group.Id, true);

            var proposedMealList =
                meals.Select(m => new MealDto(m)).ToArray();

            return Ok(proposedMealList);
        }

        [HttpGet("getMeals/{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<MealDto>> GetMealById(Guid id)
        {
            var user = await _userManager.GetUserAsync(User);
            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (user is null || group is null)
            {
                return BadRequest();
            }

            var meal = await _uow.Meals.GetMealByIdAsync(group.Id, id);

            if (meal == null)
                return NotFound($"Meal with id {id} does not exist");

            return new MealDto(meal);
        }


        [HttpPut("accept/{mealId}")]
        public async Task<ActionResult<MealDto>> AcceptMealById(Guid mealId, bool accepted)
        {
            var user = await _userManager.GetUserAsync(User);
            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (user is null || group is null)
            {
                return BadRequest();
            }

            if (!await _uow.Groups.CheckIsUserAdmin(user.Id, group.Id))
            {
                var errMsg = "User is not an Admin";
                return Forbid(errMsg);
            }

            var meal = await _uow.Meals.GetMealByIdAsync(group.Id, mealId);
            meal.Accepted = accepted;
            try
            {
                await _uow.SaveChangesAsync();
            }
            catch(Exception e)
            {
                _logger.LogError(e.Message);

                return BadRequest("Could not accept meal");
            }
            return new MealDto(meal);
        }

        
    }
}