using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MyRecipeBackend.Entities;
using MyRecipeBackend.Models;

namespace MyRecipeBackend.Data
{
    public class ApplicationUser : IdentityUser
    {
        public Group Group { get; set; }
    }
}
