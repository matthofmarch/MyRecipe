using System;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Contracts.Services;
using Core.Entities;
using Core.Model;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
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
        private readonly IUserService _userService;
        private readonly ILogger _logger;

        public MealplanController(IUnitOfWork uow, IUserService userService, ILogger<MealplanController> logger)
        {
            _uow = uow;
            _userService = userService;
            _logger = logger;
        }


        [HttpPost("requestRecommendation")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<UserRecipeModel>> GetRecommendedMeal(RecommendedMealInputModel input)
        {
            var user = await _userService.GetUserByClaimsPrincipalAsync(User);
            if (user == null)
            {
                return BadRequest("User not found");
            }

            var nextRecipe = await _uow.Groups.GetNextRecipeRecommendationForGroupAsync(user.Id, input.PrevMealIds);
            if (nextRecipe == null)
                return NotFound("No more recipes found. Please clear prev Recipes if not already done!");

            return new UserRecipeModel(nextRecipe);
        }

        [HttpPost("proposeAndVoteMeal")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult> ProposeAndVoteMeal(ProposeInputModel model)
        {
            var user = await _userService.GetUserByClaimsPrincipalAsync(User);
            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (user is null || group is null)
            {
                return BadRequest("User not found");
            }

            var meal = new Meal
            {
                DateTime = model.Day,
                RecipeId = model.RecipeId,
                Initiator = user,
                Group = group
            };
            var proposeModel = new ProposeAndVoteMealModel(meal);
            await _uow.Meals.ProposeAndVoteMealAsync(proposeModel);

            try
            {
                await _uow.SaveChangesAsync();
            }
            catch (Exception e)
            {
                _logger.LogError("Proposing meal did not work: " + e.Message);
                return BadRequest("Could not propose Meal");
            }

            return Ok();
        }

        [HttpPost("voteMeal")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult> VoteMeal(VoteInputModel input)
        {
            var user = await _userService.GetUserByClaimsPrincipalAsync(User);

            var voteModel = new VoteMealModel(user, input.VoteEnum, input.MealId);
            await _uow.Meals.VoteMealAsync(voteModel);

            try
            {
                await _uow.SaveChangesAsync();
            }
            catch (ValidationException ex)
            {
                return BadRequest(ex.Message);
            }
            catch(Exception e)
            {
                _logger.LogError($"Voting meal did not work {e.Message}");
                return BadRequest();
            }

            return Ok();
        }

        [HttpGet("getMeals")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<MealDto[]>> GetProposedMeals(bool? accepted)
        {
            var user = await _userService.GetUserByClaimsPrincipalAsync(User);
            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (user is null || group is null)
            {
                return BadRequest();
            }

            Meal[] meals = await _uow.Meals.GetMealsWithRecipeAndInitiatorAsync(group.Id, accepted);

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
            var user = await _userService.GetUserByClaimsPrincipalAsync(User);
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
    }
}