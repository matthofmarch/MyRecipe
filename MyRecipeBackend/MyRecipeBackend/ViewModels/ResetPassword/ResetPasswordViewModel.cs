using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace MyRecipeBackend.Models
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
