using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace Core.Entities
{
    public class Ingredient : EntityObject
    {
        [Required]
        public string Name { get; set; }

        public ICollection<RecipeIngredientRelation> Recipes { get; set; }

        public ICollection<IngredientTagRelation> Tags { get; set; }



        public Ingredient()
        {
            Tags = new List<IngredientTagRelation>();
            Recipes = new List<RecipeIngredientRelation>();

        }
    }
}
