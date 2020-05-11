﻿using System.Collections.Generic;
using Microsoft.AspNetCore.Identity;

namespace Core.Entities
{
    public class ApplicationUser : IdentityUser
    {
        public Group Group { get; set; }

        public List<UserRecipe> Recipes { get; set; }
    }
}
