using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Core.Entities
{
    public class IngredientTagRelation
    {
        public Guid IngredientId { get; set; }
        public Ingredient Ingredient { get; set; }

        public Guid TagId { get; set; }
        public Tag Tag { get; set; }
    }
}
