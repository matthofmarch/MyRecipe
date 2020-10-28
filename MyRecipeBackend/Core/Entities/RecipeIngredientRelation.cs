using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Core.Entities
{
    public class RecipeIngredientRelation
    {
        public Guid RecipeId { get; set; }
        public BaseRecipe Recipe { get; set; }

        public Guid IngredientId { get; set; }
        public Ingredient Ingredient { get; set; }
    }
}
