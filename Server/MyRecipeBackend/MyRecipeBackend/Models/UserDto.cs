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
        public string Username { get; set; }

        public UserDto(ApplicationUser user)
        {
            Username = user.Email;
        }
    }
}
