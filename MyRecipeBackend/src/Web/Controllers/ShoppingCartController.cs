using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Web.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ShoppingCartController : ControllerBase
    {
        private readonly IUnitOfWork _uow;
        private readonly UserManager<ApplicationUser> _userManager;

        public ShoppingCartController(IUnitOfWork uow, UserManager<ApplicationUser> userManager)
        {
            _uow = uow;
            _userManager = userManager;
        }

        [HttpGet]
        public async Task<String[]> GetRequiredIngredients(GetRequiredMealsRequest request)
        {
            var user = await _userManager.GetUserAsync(User);
            var groupId = user.GroupId.Value;
            return await _uow.ShoppingCart.GetRequiredIngredientsForHouseholdMealAsync(DateTime.Now,
                    DateTime.Now.AddDays(3), groupId);
        }

        public class GetRequiredMealsRequest
        {
            public DateTime To { get; set; } = DateTime.Now;
            public DateTime From { get; set; } = DateTime.Now.AddDays(3);
        }
    }
}
