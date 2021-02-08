using System.ComponentModel.DataAnnotations;

namespace MyRecipe.Application.Common.Models.Auth
{
    public class ResetPasswordConfirmModel
    {
        [Required(ErrorMessage = "User Id is required")]
        public string UserId { get; set; }
        [Required(ErrorMessage = "Token is required")]
        public string Token { get; set; }
        [Required(ErrorMessage = "New Password is required")]
        public string NewPassword { get; set; }
    }
}
