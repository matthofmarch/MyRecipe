using System.ComponentModel.DataAnnotations;

namespace MyRecipe.Web.ViewModels.ChangeEmail
{
    public class ChangeEmailSuccessViewModel
    {
        [Required] public string NewEmail { get; set; }
    }
}