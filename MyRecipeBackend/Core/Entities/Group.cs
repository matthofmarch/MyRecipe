using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Core.Entities
{
    public class Group : EntityObject
    {
        [Required]
        [MaxLength(30)]
        public string Name { get; set; }

        public List<ApplicationUser> Members { get; set; }

        public List<InviteCode> InviteCodes { get; set; }

        public Group()
        {
            Members = new List<ApplicationUser>();
            InviteCodes = new List<InviteCode>();
        }
    }
}
