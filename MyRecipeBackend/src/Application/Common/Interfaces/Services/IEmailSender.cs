using System.Threading.Tasks;

namespace MyRecipe.Application.Common.Interfaces.Services
{
    public interface IEmailSender
    {
        public Task SendEmailAsync(string email, string subject, string message);
    }

    public interface ISendGridConfiguration
    {
        string SendGridUser { get; }
        string SendGridKey { get; }
    }
}