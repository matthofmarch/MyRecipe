using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MyRecipe.Domain.Entities
{
    public class Recipe : EntityObject
    {
        [Required] [MaxLength(30)] public string Name { get; set; }

        public string Description { get; set; }
        public int CookingTimeInMin { get; set; }
        public Uri Image { get; set; }
        public List<Meal> Meals { get; set; }
        public ICollection<Ingredient> Ingredients { get; set; }


        [Required] public string UserId { get; set; }

        [ForeignKey(nameof(UserId))] public ApplicationUser User { get; set; }

        [Required] public bool AddToGroupPool { get; set; }
    }
}