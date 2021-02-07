using System.Threading.Tasks;
using Microsoft.Extensions.Options;
using MyRecipe.Application.Common.Interfaces.Services;
using SendGrid;
using SendGrid.Helpers.Mail;

namespace MyRecipe.Infrastructure.Services
{
    public class EmailSender : IEmailSender
    {
        public EmailSender(IOptions<AuthMessageSenderOptions> optionsAccessor)
        {
            Options = optionsAccessor.Value;
        }

        public AuthMessageSenderOptions Options { get; } //set only via Secret Manager

        public Task SendEmailAsync(string email, string subject, string message)
        {
            return Execute(Options.SendGridKey, subject, message, email);
        }

        public Task Execute(string apiKey, string subject, string message, string email)
        {
            var client = new SendGridClient(apiKey);
            var msg = new SendGridMessage()
            {
                From = new EmailAddress("myrecipes@noreply.com", Options.SendGridUser),
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
    
    public class AuthMessageSenderOptions
    {
        //MyRecipe
        public string SendGridUser { get; set; }

        //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
        public string SendGridKey { get; set; }
    }
}
