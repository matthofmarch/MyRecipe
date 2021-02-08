using System.Threading.Tasks;
using Microsoft.Extensions.Options;
using MyRecipe.Application.Common.Interfaces.Services;
using MyRecipe.Infrastructure.Configurations;
using SendGrid;
using SendGrid.Helpers.Mail;

namespace MyRecipe.Infrastructure.Services
{
    public class EmailSender : IEmailSender
    {
        private readonly SendGridOptions _sendGridOptions;

        public EmailSender(IOptions<SendGridOptions> optionsAccessor)
        {
            _sendGridOptions = optionsAccessor.Value;
        }

        public Task SendEmailAsync(string email, string subject, string message)
        {
            return Execute(_sendGridOptions.Key, subject, message, email);
        }

        public Task Execute(string apiKey, string subject, string message, string email)
        {
            var client = new SendGridClient(apiKey);
            var msg = new SendGridMessage()
            {
                From = new EmailAddress("myrecipes@noreply.com", _sendGridOptions.User),
                Subject = subject,
                PlainTextContent = message,
                HtmlContent = message
            };
            msg.AddTo(new EmailAddress(email));

            // Disable click tracking.
            // See https://sendgrid.com/docs/User_Guide/Settings/tracking.html
            msg.SetClickTracking(false, false);

            return client.SendEmailAsync(msg);
        }
    }
}
