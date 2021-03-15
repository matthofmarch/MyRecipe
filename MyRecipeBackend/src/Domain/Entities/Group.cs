using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MyRecipe.Domain.Entities
{
    public class Group : EntityObject
    {
        [Required] [MaxLength(30)] public string Name { get; set; }
        public List<ApplicationUser> Members { get; set; } = new();
        public List<Meal> Meals { get; set; } = new();
        public List<InviteCode> InviteCodes { get; set; } = new();
    }
}