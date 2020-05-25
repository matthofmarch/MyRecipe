using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MyRecipeBackend.Models;

namespace MyRecipeBackend.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class UserRecipesController : ControllerBase
    {

        private readonly IUnitOfWork _uow;
        public UserRecipesController(IUnitOfWork uow)
        {
            _uow = uow;
        }

        
        [HttpPost("create")]
        public async Task<ActionResult> CreateRecipe(UserRecipeModel userRecipeModel)
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (userId == null)
                return BadRequest("Token corrupted");
            var user = await _uow.Users.GetUserByIdAsync(userId);
            if (user == null)
                return BadRequest("User not found");

            UserRecipe userRecipe;
            try { userRecipe = await userRecipeModel.ToUserRecipe(_uow, user); }
            catch(Exception e) { return BadRequest(e.Message); }

            await _uow.UserRecipes.AddAsync(userRecipe);
            try { await _uow.SaveChangesAsync(); }
            catch(ValidationException e){ return BadRequest(e.Message); }

            return Ok();
        }

        [HttpPut("update/{id}")]
        public async Task<ActionResult> UpdateRecipe(Guid id, UserRecipeModel userRecipeModel)
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (userId == null)
                return BadRequest("Token corrupted");
            var user = await _uow.Users.GetUserByIdAsync(userId);
            if (user == null)
                return BadRequest("User not found");

            if (id != userRecipeModel.Id)
                return BadRequest("Ids do not match");

            var dbUserRecipe = await _uow.UserRecipes.GetByIdAsync(user, id);
            if (dbUserRecipe == null)
                return NotFound();

            dbUserRecipe.AddToGroupPool = userRecipeModel.AddToGroupPool;
            dbUserRecipe.CookingTimeInMin = userRecipeModel.CookingTimeInMin;
            dbUserRecipe.Description = userRecipeModel.Description;
            dbUserRecipe.Name = userRecipeModel.Name;
            dbUserRecipe.Image.Image = userRecipeModel.Image;
            var ingredients = await _uow.Ingredients.GetListByIdentifiersAsync(userRecipeModel.Ingredients);
            dbUserRecipe.SetIngredients(ingredients);
                /*ingredients.Select(i => new RecipeIngredientRelation
            {
                Ingredient = i,
                Recipe = dbUserRecipe
            }).ToArray();*/

            try
            {
                await _uow.SaveChangesAsync();
            }
            catch (ValidationException ex)
            {
                return BadRequest(ex.Message);
            }

            return NoContent();
        }

        [HttpGet]
        public async Task<ActionResult<UserRecipeModel[]>> GetRecipes(
            string filter,
            int page = 0,
            int pageSize = 20,
            bool loadImage = true
        ){
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (userId == null)
                return BadRequest("Token corrupted");
            var user = await _uow.Users.GetUserByIdAsync(userId);
            if (user == null)
                return BadRequest("User not found");

            UserRecipe[] recipes = await _uow.UserRecipes.GetPagedRecipesAsync(user, filter, page, pageSize, loadImage);

            return recipes.Select(r =>
            {
                var recipeModel = new UserRecipeModel(r);
                recipeModel.Ingredients = r.Ingredients
                    .Select(i => i.Ingredient.Name).ToArray();
                return recipeModel;
            }).ToArray();
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteRecipe(Guid id)
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (userId == null)
                return BadRequest("Token corrupted");
            var user = await _uow.Users.GetUserByIdAsync(userId);
            if (user == null)
                return BadRequest("User not found");

            UserRecipe userRecipe = await _uow.UserRecipes.GetByIdAsync(user, id);
            if(userRecipe == null)
            {
                return NotFound();
            }

            _uow.UserRecipes.Delete(userRecipe);

            try { await _uow.SaveChangesAsync(); }
            catch(Exception e) { return BadRequest(e.Message); }

            return NoContent();
        }


    }
}