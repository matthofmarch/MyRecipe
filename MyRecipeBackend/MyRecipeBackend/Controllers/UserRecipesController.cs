using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Contracts.Services;
using Core.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.Extensions.Configuration;
using MyRecipeBackend.Models;

namespace MyRecipeBackend.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class UserRecipesController : ControllerBase
    {

        private readonly IUnitOfWork _uow;
        private readonly IConfiguration _configuration;
        private readonly IUserService _userService;

        public UserRecipesController(IUnitOfWork uow, IConfiguration config, IUserService userService)
        {
            _uow = uow;
            _configuration = config;
            _userService = userService;
        }

        
        [HttpPost("create")]
        public async Task<ActionResult> CreateRecipe(UserRecipeModel userRecipeModel)
        {
            var user = await _userService.GetUserByClaimsPrincipalAsync(User);
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
        public async Task<ActionResult> UpdateRecipe([FromRoute]Guid id, UserRecipeModel userRecipeModel)
        {
            var user = await _userService.GetUserByClaimsPrincipalAsync(User);
            if (user == null) return BadRequest("User not found");

            if (id != userRecipeModel.Id) return BadRequest("Ids do not match");

            var dbUserRecipe = await _uow.UserRecipes.GetByIdAsync(user, id);
            if (dbUserRecipe == null) return NotFound();

            dbUserRecipe.AddToGroupPool = userRecipeModel.AddToGroupPool;
            dbUserRecipe.CookingTimeInMin = userRecipeModel.CookingTimeInMin;
            dbUserRecipe.Description = userRecipeModel.Description;
            dbUserRecipe.Name = userRecipeModel.Name;

            if (userRecipeModel.Image != null)
            {
                dbUserRecipe.Image.ImageUri = userRecipeModel.Image;
            }

            var ingredients = await _uow.Ingredients
                .GetListByIdentifiersAsync(userRecipeModel.Ingredients);


            await _uow.UserRecipes.RemoveIngredients(dbUserRecipe.Id);
            try { await _uow.SaveChangesAsync(); }
            catch (ValidationException ex) { return BadRequest(ex.Message); }

            dbUserRecipe.SetIngredients(ingredients);
            try { await _uow.SaveChangesAsync(); }
            catch (ValidationException ex) { return BadRequest(ex.Message); }

            return NoContent();
        }

        [HttpGet("paged")]
        public async Task<ActionResult<UserRecipeModel[]>> GetPaged(
            string filter,
            int page = 0,
            int pageSize = 20,
            bool loadImage = true
        )
        {
            var user = await _userService.GetUserByClaimsPrincipalAsync(User);
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
            var user = await _userService.GetUserByClaimsPrincipalAsync(User);
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


        [HttpPost("uploadImage")]
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
        

            return Ok(new {url = $"{this.Request.Scheme}://{this.Request.Host}/{_configuration["StaticFiles:ImageBasePath"]}/{filename}"});
        }

    }
}