using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Core.Entities;
using Microsoft.EntityFrameworkCore;

namespace MyRecipeBackend.Models
{
    public class MemberDto
    {
        public string Email { get; set; }
        public bool IsAdmin { get; set; }

        public MemberDto(ApplicationUser user)
        {
            Email = user.Email;
            IsAdmin = user.IsAdmin;
        }
    }
}
