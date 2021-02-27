using System.ComponentModel.DataAnnotations;

namespace MyRecipe.Infrastructure.Options
{
    public class JwtOptions
    {
        [Required] public string Key { get; set; }

        [Required] public string Issuer { get; set; }

        [Required] public string Audience { get; set; }

        [Required] public string RefreshProvider { get; set; }

        [Required] public string TokenValidMinutes { get; set; }
    }
}