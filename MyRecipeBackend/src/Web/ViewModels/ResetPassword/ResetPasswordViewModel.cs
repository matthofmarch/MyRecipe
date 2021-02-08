using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;

namespace MyRecipe.Web.ViewModels.ResetPassword
{
    public class ResetPasswordViewModel
    {
        [Required(ErrorMessage = "User Id is required")]
        [HiddenInput(DisplayValue = false)]
        public string UserId { get; set; }
        [Required(ErrorMessage = "Token is required")]
        [HiddenInput(DisplayValue = false)]
        public string Token { get; set; }

        [Required]
        [DisplayName("New Password")]
        [DataType(DataType.Password)]
        public string NewPassword { get; set; }
        [Required]
        [DisplayName("Confirm new Password")]
        [DataType(DataType.Password)]
        [Compare(nameof(NewPassword), ErrorMessage = "Password must match")]
        public string ConfirmNewPassword { get; set; }
    }
}
