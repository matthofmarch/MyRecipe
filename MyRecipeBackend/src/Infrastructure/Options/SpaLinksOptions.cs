using System.ComponentModel.DataAnnotations;

namespace MyRecipe.Infrastructure.Options
{
    public class SpaLinksOptions
    {
        [Required] public string ResetPasswordBaseLink { get; set; }

        [Required] public string ResetEmailBaseLink { get; set; }
    }
}