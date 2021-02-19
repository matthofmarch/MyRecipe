using System.Linq;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http;
using Microsoft.Extensions.Logging;
using MyRecipe.Application.Common.Interfaces.Services;
using MyRecipe.Domain.Entities;
using MyRecipe.Web.ViewModels;
using MyRecipe.Web.ViewModels.ChangeEmail;

namespace MyRecipe.Web.Controllers
{
    [Route("[controller]")]
    public class ChangeEmailController : Controller
    {
        private readonly IEmailSender _emailSender;
        private readonly ILogger<ChangeEmailController> _log;
        private readonly UserManager<ApplicationUser> _userManager;


        public ChangeEmailController(
            UserManager<ApplicationUser> userManager,
            IEmailSender emailSender,
            ILogger<ChangeEmailController> log)
        {
            _userManager = userManager;
            _emailSender = emailSender;
            _log = log;
        }


        /// <summary>
        ///     Request the change of email for a user (has to be logged in)
        /// </summary>
        /// <param name="newEmail"></param>
        /// <returns></returns>
        [HttpPost("mail")]
        [Authorize]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> RequestChangeEmail(string newEmail)
        {
            if (string.IsNullOrWhiteSpace(newEmail)) return BadRequest("New Email not provided");
            var user = await _userManager.GetUserAsync(User);
            if (user is null) return BadRequest("Could not find User");

            var token = await _userManager.GenerateChangeEmailTokenAsync(user, newEmail);
            var callbackUrl = Url.Action("ChangeEmail", "ChangeEmail",
                new ResetEmailViewModel {Token = token, UserId = user.Id, NewEmail = newEmail},
                HttpScheme.Https.ToString());
            var encodedCallbackUrl = HtmlEncoder.Default.Encode(callbackUrl);
            await _emailSender.SendEmailAsync(newEmail, "Change your account email",
                $"Please follow the link to confirm your email change: <a href='{encodedCallbackUrl}'>Click here</a>");
            return Ok("Email sent");
        }

        /// <summary>
        ///     s
        ///     Confirm the change of a users email
        /// </summary>
        /// <param name="viewModel"></param>
        /// <returns></returns>
        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> ChangeEmail(ResetEmailViewModel viewModel)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var user = await _userManager.FindByIdAsync(viewModel.UserId);
            if (user is null) return BadRequest("Could not find User");

            var emailChange = await _userManager.ChangeEmailAsync(user, viewModel.NewEmail, viewModel.Token);
            if (!emailChange.Succeeded)
            {
                _log.LogError(string.Join(", ", emailChange.Errors.Select(e => $"{e.Code}: {e.Description}")));
                if (emailChange.Errors.Any(c => c.Description.Contains("DuplicateEmail")))
                    return BadRequest("Email is already bound to a user");
                return BadRequest("Could not change email");
            }

            var userNameChange = await _userManager.SetUserNameAsync(user, viewModel.NewEmail);
            if (!userNameChange.Succeeded)
            {
                _log.LogCritical("Changed email, but not username");
                return BadRequest("Could not change userName to new email");
            }

            return RedirectToAction("ChangeEmailSuccess",
                new ChangeEmailSuccessViewModel {NewEmail = viewModel.NewEmail});
        }

        [HttpGet]
        [Route("Success")]
        public IActionResult ChangeEmailSuccess(ChangeEmailSuccessViewModel viewModel)
        {
            return View(viewModel);
        }
    }
}