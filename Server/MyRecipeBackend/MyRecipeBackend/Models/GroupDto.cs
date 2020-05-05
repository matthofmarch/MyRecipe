using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Core.Entities;

namespace MyRecipeBackend.Models
{
    public class GroupDto
    {
        public string Name { get; set; }

        public List<ApplicationUser> Members { get; set; }

        public GroupDto(Group group)
        {
            Name = group.Name;
            Members = group.Members;
        }


    }
}
