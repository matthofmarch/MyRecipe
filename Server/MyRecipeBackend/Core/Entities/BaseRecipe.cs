using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
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
        public List<Ingredient> Ingredients { get; set; }
        public RecipeImage Image { get; set; }

        public BaseRecipe()
        {
            Ingredients = new List<Ingredient>();
        }
    }
}
