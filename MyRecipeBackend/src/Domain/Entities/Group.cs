using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MyRecipe.Domain.Entities
{
    public class Group : EntityObject
    {
        public Group()
        {
            Members = new List<ApplicationUser>();
            InviteCodes = new List<InviteCode>();
            Meals = new List<Meal>();
        }

        [Required] [MaxLength(30)] public string Name { get; set; }

        public List<ApplicationUser> Members { get; set; }

        public List<Meal> Meals { get; set; }

        public List<InviteCode> InviteCodes { get; set; }
    }
}