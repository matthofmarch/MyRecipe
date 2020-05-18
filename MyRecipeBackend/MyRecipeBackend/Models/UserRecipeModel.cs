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

        public UserRecipeModel(UserRecipe r)
        {
            Id = r.Id;
            Name = r.Name;
            Description = r.Description;
            CookingTimeInMin = r.CookingTimeInMin;
            Image = r.Image.Image;
            AddToGroupPool = r.AddToGroupPool;
        }


        public Guid Id { get; set; }
        [Required]
        public string Name { get; set; }
        public string Description { get; set; }
        public int CookingTimeInMin { get; set; }
        public string[] Ingredients { get; set; }

        public byte[] Image { get; set; }

        public bool AddToGroupPool { get; set; }

        public async Task<UserRecipe> ToUserRecipe(IUnitOfWork uow, ApplicationUser user)
        {
            Ingredient[] ingredients;
            try
            {
                ingredients = await uow.Ingredients
                    .GetListByIdentifiersAsync(Ingredients);
            }
            catch(Exception e) { throw e; }

            var userRecipe = new UserRecipe
            {

                Name = Name,
                Description = Description,
                CookingTimeInMin = CookingTimeInMin,
                AddToGroupPool = AddToGroupPool,
                Image = new RecipeImage { Image = Image },
                ApplicationUser = user
            };
            userRecipe.Ingredients = ingredients.Select(i => new RecipeIngredientRelation
            {
                Ingredient = i,
                Recipe = userRecipe
            }).ToArray();

            return userRecipe;
        }
    }
}
