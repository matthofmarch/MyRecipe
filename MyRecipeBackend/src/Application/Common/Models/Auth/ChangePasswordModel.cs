using System.ComponentModel.DataAnnotations;

namespace MyRecipe.Application.Common.Models.Auth
{
    public class ChangePasswordModel
    {
        [Required]
        public string CurrentPassword { get; set; }
        [Required]
        public string NewPassword { get; set; }
    }
}
