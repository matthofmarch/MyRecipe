using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace MyRecipe.Domain.Entities
{
    public class Tag : EntityObject
    {
        [Required]
        public string Label { get; set; }
        public ICollection<Ingredient> Ingredients { get; set; }
    }
}
