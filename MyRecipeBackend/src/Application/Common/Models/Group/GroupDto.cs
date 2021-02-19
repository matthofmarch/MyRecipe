using System.Collections.Generic;
using System.Linq;
using MyRecipe.Application.Common.Models.Auth;

namespace MyRecipe.Application.Common.Models.Group
{
    public class GroupDto
    {
        public GroupDto(Domain.Entities.Group group)
        {
            Name = group.Name;
            Members = group.Members.Select(m => new MemberDto(m)).ToList();
        }

        public string Name { get; set; }

        public List<MemberDto> Members { get; set; }
    }
}