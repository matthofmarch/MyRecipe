using System.ComponentModel.DataAnnotations;

namespace MyRecipe.Application.Common.Models.User
{
    public class UpdateUserModel
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        public bool IsAdmin { get; set; }

        [Required]
        public bool KickFromGroup { get; set; }
    }
}
