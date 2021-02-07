using System.ComponentModel.DataAnnotations;

namespace MyRecipe.Application.Common.Models.Auth
{
    public class LoginModel
    {
        [Required(ErrorMessage = "Email is required")]
        [EmailAddress]
        public string Email { get; set; }

        [Required(ErrorMessage = "Password is required")]
        public string Password { get; set; }

    }
}
