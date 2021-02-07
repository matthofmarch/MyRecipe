using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Identity;

namespace MyRecipe.Domain.Entities
{
    public class ApplicationUser : IdentityUser
    {
        [ForeignKey(nameof(GroupId))]
        public Group Group { get; set; }
        public Guid? GroupId { get; set; }
        public bool IsAdmin { get; set; }
        public List<Recipe> Recipes { get; set; }
    }
}
