using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MyRecipeBackend.Models
{
    public class ProposeInputModel
    {
        public Guid RecipeId { get; set; }
        public DateTime Day { get; set; }
    }
}
