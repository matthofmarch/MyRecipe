using System.ComponentModel.DataAnnotations;

namespace MyRecipe.Application.Common.Models.Auth
{
    public class RefreshModel
    {
        [Required(ErrorMessage = "Token is required")]
        public string Token { get; set; }

        [Required(ErrorMessage = "Refresh Token is required")]
        public string RefreshToken { get; set; }
    }
}