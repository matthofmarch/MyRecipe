using System;
using System.Linq;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Contracts.Services;
using Core.Entities;
using Core.Model;
using Core.Model.Response;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using MyRecipeBackend.Models;

namespace MyRecipeBackend.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class MealplanController : ControllerBase
    {

        private readonly IUnitOfWork _uow;
        private readonly IUserService _userService;

        public MealplanController(IUnitOfWork uow, IUserService userService)
        {
            _uow = uow;
            _userService = userService;
        }


        [HttpGet("requestRecommendation")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<UserRecipeModel>> GetRecommendedMeal(RecommendedMealInputModel input)
        {
            var user = await _userService.GetUserByClaimsPrincipalAsync(User);
            if (user == null) 
                return BadRequest("User not found");

            var nextRecipe = await _uow.Groups.GetNextRecipeRecommendationForGroupAsync(user.Id, input.PrevMealIds);
            if (nextRecipe == null)
                return NotFound("No more recipes found. Please clear prev Recipes if not already done!");

            return new UserRecipeModel(nextRecipe);
        }

        [HttpPost("proposeAndVoteMeal")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult> ProposeAndVoteMeal(Guid recipeId, DateTime day)
        {
            var user = await _userService.GetUserByClaimsPrincipalAsync(User);
            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (user is null || group is null)
                return BadRequest("User not found");

            var meal = new Meal
            {
                DateTime = day,
                RecipeId = recipeId,
                Initiator = user,
                Group = group
            };
            var proposeModel = new ProposeAndVoteMealModel(meal);
            await _uow.Meals.ProposeAndVoteMealAsync(proposeModel);

            try
            {
                await _uow.SaveChangesAsync();
            }
            catch
            {
                return BadRequest("Could not propose Meal");
            }

            return Ok();
        }

        [HttpPost("voteMeal")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult> VoteMeal(Guid mealId, VoteEnum vote)
        {
            var user = await _userService.GetUserByClaimsPrincipalAsync(User);
            var voteModel = new VoteMealModel(user, vote, mealId);
            await _uow.Meals.VoteMealAsync(voteModel);

            try
            {
                await _uow.SaveChangesAsync();
            }
            catch
            {
                return BadRequest();
            }

            return Ok();
        }

        [HttpGet("getProposedMeals")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<MealDtoList>> GetProposedMeals()
        {
            var user = await _userService.GetUserByClaimsPrincipalAsync(User);
            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (user is null || group is null)
                return BadRequest();
            Meal[] meals = await _uow.Meals.GetMealsWithRecipeAndInitiatorAsync(group.Id,false);

            var proposedMealList= new MealDtoList(
                meals.Select(m => new MealDto(m.Initiator.NormalizedUserName, m.Id, m.Recipe.Image)).ToArray());

            return Ok(proposedMealList);
        }

        [HttpGet("getAcceptedMeals")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<MealDtoList>> GetAcceptedMeals()
        {
            var user = await _userService.GetUserByClaimsPrincipalAsync(User);
            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (user is null || group is null)
                return BadRequest();
            Meal[] meals = await _uow.Meals.GetMealsWithRecipeAndInitiatorAsync(group.Id, true);

            var proposedMealList = new MealDtoList(
                meals.Select(m => new MealDto(m.Initiator.NormalizedUserName, m.Id, m.Recipe.Image)).ToArray());

            return Ok(proposedMealList);
        }
    }
}