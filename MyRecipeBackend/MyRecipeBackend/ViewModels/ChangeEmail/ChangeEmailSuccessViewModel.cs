using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace MyRecipeBackend.ViewModels.ChangeEmail
{
    public class ChangeEmailSuccessViewModel
    {
        [Required]
        public string NewEmail { get; set; }
    }
}
