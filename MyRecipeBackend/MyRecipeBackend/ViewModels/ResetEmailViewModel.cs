using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace MyRecipeBackend.ViewModels
{
    public class ResetEmailViewModel
    {
        [Required(ErrorMessage = "Token is required")]
        public string Token { get; set; }
        [Required(ErrorMessage = "New Email is required")]
        [DataType(DataType.EmailAddress)]
        public string NewEmail { get; set; }
        [Required(ErrorMessage = "User Id is required")]
        public string UserId { get; set; }
    }
}
