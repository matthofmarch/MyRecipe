using System;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Common.Models.Recipe
{
    public class RecipeModel
    {

        public RecipeModel()
        {

        }

        public RecipeModel(Domain.Entities.Recipe r)
        {
            Id = r.Id;
            Name = r.Name;
            Description = r.Description;
            CookingTimeInMin = r.CookingTimeInMin;
            Image = r.Image;
            AddToGroupPool = r.AddToGroupPool;
            IngredientNames = r.Ingredients.Select(i => i.Name).ToArray();
            Username = r.User?.Email;
        }


        public Guid Id { get; set; }
        [Required]
        public string Name { get; set; }
        public string Description { get; set; }
        public int CookingTimeInMin { get; set; }
        public string[] IngredientNames { get; set; }
        public Uri Image { get; set; }
        public bool AddToGroupPool { get; set; }
        public string Username { get; set; }


        public async Task<Domain.Entities.Recipe> ToUserRecipe(IUnitOfWork uow, ApplicationUser user)
        {
            var userRecipe = new Domain.Entities.Recipe
            {
                Name = Name,
                Description = Description,
                CookingTimeInMin = CookingTimeInMin,
                AddToGroupPool = AddToGroupPool,
                Image = Image,
                User = user
            };
            if (IngredientNames != null)
            {
                userRecipe.Ingredients = await uow.Ingredients.GetListByNamesAsync(IngredientNames);
            }
            return userRecipe;
        }
    }
}
