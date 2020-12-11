using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.AccessControl;
using System.Threading;
using System.Threading.Tasks;
using Core.Entities;

namespace MyRecipeBackend.Models
{
    public class RecipeGroupModel
    {
        public string Username { get; set; }
        public RecipeModel Recipe { get; set; }


        public RecipeGroupModel()
        {
        }

        public RecipeGroupModel(Recipe recipe)
        {
            Username = recipe.User.Email;
            Recipe = new RecipeModel(recipe);
        }
    }
}
