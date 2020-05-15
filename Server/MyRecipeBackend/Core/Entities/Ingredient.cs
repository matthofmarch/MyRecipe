using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace Core.Entities
{
    public class Ingredient : EntityObject
    {
        [Required]
        public string Name { get; set; }

        [Required]
        public List<IngredientTag> Tags { get; set; }



        public Ingredient()
        {
            Tags = new List<IngredientTag>();

        }
    }
}
