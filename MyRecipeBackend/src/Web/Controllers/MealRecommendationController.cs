using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Models.Mealplan;
using MyRecipe.Application.Common.Models.Recipe;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Web.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class MealRecommendationController : Controller
    {
        private readonly ILogger _logger;
        private readonly IUnitOfWork _uow;
        private readonly UserManager<ApplicationUser> _userManager;

        public MealRecommendationController(IUnitOfWork uow, UserManager<ApplicationUser> userManager,
            ILogger<MealRecommendationController> logger)
        {
            _uow = uow;
            _userManager = userManager;
            _logger = logger;
        }

        /// <summary>
        ///     Get random recommendations of what to eat based on the entire recipes of a group
        /// </summary>
        /// <param name="requestModel"></param>
        /// <returns></returns>
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<RecipeModel>> GetRecommendedMeal(RecommendMealRequestModel requestModel)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null) return BadRequest("User not found");

            var recipe = await _uow.Groups
                .GetNextRecipeRecommendationForGroupAsync(user.Id, requestModel.PrevMealIds);
            if (recipe == null)
                return NotFound("No more recipes found. Please clear prev Recipes if not already done!");

            return new RecipeModel(recipe);
        }
    }
}