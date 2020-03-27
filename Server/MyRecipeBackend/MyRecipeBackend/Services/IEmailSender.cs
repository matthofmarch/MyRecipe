using System.Threading.Tasks;

namespace MyRecipeBackend.Services
{
    public interface IEmailSender
    {
        public Task SendEmailAsync(string email, string subject, string message);
    }
}