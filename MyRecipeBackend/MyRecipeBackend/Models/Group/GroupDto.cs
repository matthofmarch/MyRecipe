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

        public List<UserDto> Members { get; set; }

        public GroupDto(Core.Entities.Group group)
        {
            Name = group.Name;
            Members = group.Members.Select(m => new UserDto(m)).ToList();
        }


    }
}
