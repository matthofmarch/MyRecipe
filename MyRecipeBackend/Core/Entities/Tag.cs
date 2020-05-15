using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Core.Entities
{
    public class Tag : EntityObject
    {
        [Required]
        public string Descriptor { get; set; }

        
        public ICollection<IngredientTagRelation> Ingredients { get; set; }


        public Tag()
        {
            Ingredients = new List<IngredientTagRelation>();
        }
    }
}
