using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Contracts.Services;
using Core.Entities;
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
        private readonly IConfiguration _configuration;
        private readonly IUserService _userService;

        public MealplanController(IUnitOfWork uow, IConfiguration config, IUserService userService)
        {
            _uow = uow;
            _configuration = config;
            _userService = userService;
        }


        [HttpPost("getRecommended")]
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
    }
}