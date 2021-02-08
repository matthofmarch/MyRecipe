using System.ComponentModel.DataAnnotations;
using MyRecipe.Application.Common.Interfaces.Services;

namespace MyRecipe.Infrastructure.Configurations
{
    public class SendGridOptions: ISendGridConfiguration
    {
        public string SendGridUser { get; set; }
        public string SendGridKey { get; set; }
    }
}