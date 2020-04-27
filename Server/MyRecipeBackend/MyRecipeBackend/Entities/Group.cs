using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using MyRecipeBackend.Data;

namespace MyRecipeBackend.Entities
{
    public class Group : EntityObject
    {
        [Required]
        [MaxLength(30)]
        public string Name { get; set; }

        public List<ApplicationUser> Members { get; set; }

        public List<InviteCode> InviteCodes { get; set; }

    }
}
