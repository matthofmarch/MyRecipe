using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Reflection.Metadata;

namespace Core.Entities
{
    public class BaseRecipe : EntityObject
    {
        [Required]
        [MaxLength(30)]
        public string Name { get; set; }
        public string Description { get; set; }
        public int CookingTimeInMin { get; set; }
        public ICollection<RecipeIngredientRelation> Ingredients { get; set; }
        public RecipeImage Image { get; set; }

        public BaseRecipe()
        {
            Ingredients = new List<RecipeIngredientRelation>();
        }

        public void SetIngredients(ICollection<Ingredient> ingredients)
        {
            //TODO 
            Ingredients = ingredients.Select(i =>
                new RecipeIngredientRelation
                {
                    Ingredient = i,
                    Recipe = this
                }).ToArray();
        }
    }
}
