using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace MyRecipeBackend.Models.Auth
{
    public class ResetPasswordModel
    {
        [Required(ErrorMessage = "User Id is required")]
        public string UserId { get; set; }
        [Required(ErrorMessage = "Token is required")]
        public string Token { get; set; }
    }
}
