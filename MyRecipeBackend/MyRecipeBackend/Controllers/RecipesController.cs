using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using MyRecipeBackend.Models;

namespace MyRecipeBackend.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class RecipesController : ControllerBase
    {

        private readonly IUnitOfWork _uow;
        private readonly IConfiguration _configuration;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ILogger<RecipesController> _log;

        public RecipesController(
            IUnitOfWork uow, 
            IConfiguration config, 
            UserManager<ApplicationUser> userManager,
            ILogger<RecipesController> log)
        {
            _uow = uow;
            _configuration = config;
            _userManager = userManager;
            _log = log;
        }

        /// <summary>
        /// Add a recipe to the users cookbook
        /// </summary>
        /// <param name="recipeModel"></param>
        /// <returns></returns>
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> CreateRecipe(RecipeModel recipeModel)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null)
                return BadRequest("User not found");

            Recipe recipe;
            try { recipe = await recipeModel.ToUserRecipe(_uow, user); }
            catch(Exception e) { return BadRequest(e.Message); }

            await _uow.Recipes.AddAsync(recipe);
            try { await _uow.SaveChangesAsync(); }
            catch(ValidationException e){ return BadRequest(e.Message); }

            return Ok();
        }

        /// <summary>
        /// Update a users recipe
        /// </summary>
        /// <param name="id"></param>
        /// <param name="recipeModel"></param>
        /// <returns></returns>
        [HttpPut("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        public async Task<ActionResult> UpdateRecipe([FromRoute]Guid id, RecipeModel recipeModel)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user is null) return BadRequest("User not found");

            if (id != recipeModel.Id) return BadRequest("Ids do not match");

            var dbUserRecipe = await _uow.Recipes.GetByIdAsync(user, id);
            if (dbUserRecipe == null) return NotFound();

            dbUserRecipe.AddToGroupPool = recipeModel.AddToGroupPool;
            dbUserRecipe.CookingTimeInMin = recipeModel.CookingTimeInMin;
            dbUserRecipe.Description = recipeModel.Description;
            dbUserRecipe.Name = recipeModel.Name;
            dbUserRecipe.Image = recipeModel.Image;

            await _uow.Recipes.RemoveIngredients(dbUserRecipe.Id);
            dbUserRecipe.Ingredients = await _uow.Ingredients.GetListByNamesAsync(
                    recipeModel.IngredientNames);

            try
            {
                await _uow.SaveChangesAsync();
            }
            catch (Exception e)
            {
                string errMsg = "Could not update Recipe";
                _log.LogError($"{errMsg}: {e}");
                return BadRequest($"{errMsg}");
            }

            return NoContent();
        }

        /// <summary>
        /// Get recipes for user with paging
        /// </summary>
        /// <param name="filter">Filters by name of recipes</param>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<RecipeModel[]>> GetPaged(
            string filter = "",
            int page = 0,
            int pageSize = 20
        )
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null)
                return BadRequest("User not found");

            Recipe[] recipes = await _uow.Recipes.GetPagedRecipesAsync(user, filter, page, pageSize);

            return recipes.Select(r => new RecipeModel(r)).ToArray();
        }

        /// <summary>
        /// Delete a users recipe
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        public async Task<ActionResult> DeleteRecipe(Guid id)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null)
                return BadRequest("User not found");

            Recipe recipe = await _uow.Recipes.GetByIdAsync(user, id);
            if(recipe == null)
            {
                return NotFound();
            }

            _uow.Recipes.Delete(recipe);

            try { await _uow.SaveChangesAsync(); }
            catch(Exception e) { return BadRequest(e.Message); }

            return NoContent();
        }

        /// <summary>
        /// Upload a image
        /// </summary>
        /// <param name="image"></param>
        /// <returns>Path to the image file</returns>
        [HttpPost("uploadImage")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> UploadImage(IFormFile image)
        {
            if (image == null)
                return BadRequest("Image is required");
            if (image.Length <= 0)
                return BadRequest("Image length is 0");

            var filename = string.Join('_',
                DateTime.Now.ToString("yy-MM-dd"),
                Guid.NewGuid().ToString(),
                Path.GetExtension(image.FileName));

            var path = Path.Combine(Directory.GetCurrentDirectory(),
                _configuration["StaticFiles:ImageBasePath"],filename);

            await using var fileStream = new FileStream(path, FileMode.Create);
            await image.CopyToAsync(fileStream);
        

            return Ok(new {uri = $"{this.Request.Scheme}://{this.Request.Host}/{_configuration["StaticFiles:ImageBasePath"]}/{filename}"});
        }

    }
}