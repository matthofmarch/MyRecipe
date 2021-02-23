using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MyRecipe.Domain.Entities
{
    public class Ingredient : EntityObject
    {
        [Required] public string Name { get; set; }

        public ICollection<Recipe> Recipes { get; set; }

        public ICollection<Tag> Tags { get; set; }
    }
}