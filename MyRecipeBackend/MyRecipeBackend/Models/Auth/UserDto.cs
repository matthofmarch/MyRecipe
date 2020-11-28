using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Core.Entities;
using Microsoft.EntityFrameworkCore;

namespace MyRecipeBackend.Models
{
    public class UserDto
    {
        public string Email { get; set; }
        public bool IsAdmin { get; set; }

        public UserDto(ApplicationUser user)
        {
            Email = user.Email;
            IsAdmin = user.IsAdmin;
        }
    }
}
