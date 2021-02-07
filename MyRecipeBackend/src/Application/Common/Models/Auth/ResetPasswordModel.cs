using System.ComponentModel.DataAnnotations;

namespace MyRecipe.Application.Common.Models.Auth
{
    public class ResetPasswordModel
    {
        [Required(ErrorMessage = "User Id is required")]
        public string UserId { get; set; }
        [Required(ErrorMessage = "Token is required")]
        public string Token { get; set; }
    }
}
