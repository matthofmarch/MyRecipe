using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using MyRecipeBackend.Models;

namespace MyRecipeBackend.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class MealRecommendationController : Controller
    {
        private readonly IUnitOfWork _uow;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ILogger _logger;

        public MealRecommendationController(IUnitOfWork uow, UserManager<ApplicationUser> userManager, ILogger<MealRecommendationController> logger)
        {
            _uow = uow;
            _userManager = userManager;
            _logger = logger;
        }


        [HttpPost]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<UserRecipeModel>> GetRecommendedMeal(RecommendMealRequestModel requestModel)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null)
            {
                return BadRequest("User not found");
            }

            var recipe = await _uow.Groups
                .GetNextRecipeRecommendationForGroupAsync(user.Id, requestModel.PrevMealIds);
            if (recipe == null)
                return NotFound("No more recipes found. Please clear prev Recipes if not already done!");

            return new UserRecipeModel(recipe);
        }
    }
}
