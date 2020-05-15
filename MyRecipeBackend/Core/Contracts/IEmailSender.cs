using System.Threading.Tasks;

namespace Core.Contracts
{
    public interface IEmailSender
    {
        public Task SendEmailAsync(string email, string subject, string message);
    }
}