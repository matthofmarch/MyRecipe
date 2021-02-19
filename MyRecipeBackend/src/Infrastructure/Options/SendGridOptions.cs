using System.ComponentModel.DataAnnotations;
using MyRecipe.Application.Common.Interfaces.Services;

namespace MyRecipe.Infrastructure.Configurations
{
    public class SendGridOptions : ISendGridConfiguration
    {
        [Required] public string User { get; set; }

        [Required] public string Key { get; set; }
    }
}