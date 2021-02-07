using System.Threading.Tasks;

namespace MyRecipe.Application.Common.Interfaces.Services
{
    public interface IEmailSender
    {
        public Task SendEmailAsync(string email, string subject, string message);
    }
}