﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;
using Core.Model;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using MyRecipeBackend.Models.Mealplan;

namespace MyRecipeBackend.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class MealPollController : Controller
    {
        private readonly IUnitOfWork _uow;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ILogger _logger;

        public MealPollController(IUnitOfWork uow, UserManager<ApplicationUser> userManager, ILogger<MealPollController> logger)
        {
            _uow = uow;
            _userManager = userManager;
            _logger = logger;
        }

        [HttpPost("propose")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult> ProposeMeal(ProposeInputModel model)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user is null)
            {
                string errMsg = "User not found";
                _logger.LogError(errMsg);
                return Forbid(errMsg);
            }

            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (group is null)
            {
                string errMsg = "No group found for user";
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
            await _uow.Meals.ProposeAndVoteMealAsync(meal);

            try
            {
                await _uow.SaveChangesAsync();
            }
            catch (Exception e)
            {
                string errMsg = "Could not propose Meal";
                _logger.LogError($"{errMsg}: {e.Message}");
                return BadRequest("Could not propose Meal");
            }

            return Ok();
        }

        [HttpPost("vote")]
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

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<MealDto[]>> GetProposedMeals()
        {
            var user = await _userManager.GetUserAsync(User);
            var group = await _uow.Groups.GetGroupForUserAsync(user.Id);
            if (user is null || group is null)
            {
                return BadRequest();
            }

            Meal[] meals = await _uow.Meals.GetMealsWithRecipeAndInitiatorAsync(group.Id, false);

            var proposedMealList =
                meals.Select(m => new MealDto(m)).ToArray();

            return Ok(proposedMealList);
        }
    }
}
