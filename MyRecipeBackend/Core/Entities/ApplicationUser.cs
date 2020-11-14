using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Identity;

namespace Core.Entities
{
    public class ApplicationUser : IdentityUser
    {
        [ForeignKey(nameof(GroupId))]
        public Group Group { get; set; }
        public Guid? GroupId { get; set; } 

        public List<Recipe> Recipes { get; set; }
    }
}
