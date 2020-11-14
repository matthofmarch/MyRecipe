using Core.Contracts;
using Core.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace MyRecipeBackend.Models
{
    public class UserRecipeModel
    {

        public UserRecipeModel()
        {

        }

        public UserRecipeModel(Recipe r)
        {
            Id = r.Id;
            Name = r.Name;
            Description = r.Description;
            CookingTimeInMin = r.CookingTimeInMin;
            Image = r.Image;
            AddToGroupPool = r.AddToGroupPool;
            IngredientIds = r.Ingredients.Select(i => i.Id).ToArray();
        }


        public Guid Id { get; set; }
        [Required]
        public string Name { get; set; }
        public string Description { get; set; }
        public int CookingTimeInMin { get; set; }
        public Guid[] IngredientIds { get; set; }
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
                Ingredients = await uow.Ingredients.GetListByIdsAsync(IngredientIds)
            };

            return userRecipe;
        }
    }
}
