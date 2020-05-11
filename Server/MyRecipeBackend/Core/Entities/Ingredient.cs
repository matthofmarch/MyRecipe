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
        public List<IngredientType> Types { get; set; }

        public Ingredient()
        {
            Types = new List<IngredientType>();
        }
    }
}
