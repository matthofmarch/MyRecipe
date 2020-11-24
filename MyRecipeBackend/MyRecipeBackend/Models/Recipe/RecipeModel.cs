using Core.Contracts;
using Core.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace MyRecipeBackend.Models
{
    public class RecipeModel
    {

        public RecipeModel()
        {

        }

        public RecipeModel(Recipe r)
        {
            Id = r.Id;
            Name = r.Name;
            Description = r.Description;
            CookingTimeInMin = r.CookingTimeInMin;
            Image = r.Image;
            AddToGroupPool = r.AddToGroupPool;
            IngredientNames = r.Ingredients.Select(i => i.Name).ToArray();
        }


        public Guid Id { get; set; }
        [Required]
        public string Name { get; set; }
        public string Description { get; set; }
        public int CookingTimeInMin { get; set; }
        public string[] IngredientNames { get; set; }
        public Uri Image { get; set; }
        public bool AddToGroupPool { get; set; }

        public async Task<Recipe> ToUserRecipe(IUnitOfWork uow, ApplicationUser user)
        {
            var userRecipe = new Recipe
            {
                Name = Name,
                Description = Description,
                CookingTimeInMin = CookingTimeInMin,
                AddToGroupPool = AddToGroupPool,
                Image = Image,
                User = user,
                Ingredients = await uow.Ingredients.GetListByNamesAsync(IngredientNames)
            };

            return userRecipe;
        }
    }
}
