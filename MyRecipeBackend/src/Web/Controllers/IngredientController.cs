using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MyRecipe.Application.Common.Interfaces;

namespace MyRecipe.Web.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class IngredientController:ControllerBase
    {
        private readonly IUnitOfWork _uow;

        public IngredientController(IUnitOfWork uow)
        {
            _uow = uow;
        }

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<String[]>> GetNames()
        {
            return (await _uow.Ingredients.AllAsync()).Select(i => i.Name).ToArray();
        }
    }
}
