using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Routing;
using Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http;
using MyRecipeBackend.Models;
using MyRecipeBackend.Models.Auth;

namespace MyRecipeBackend.Controllers
{
    [Route("[controller]")]
    public class ResetPasswordController : Controller
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IEmailSender _emailSender;


        public ResetPasswordController(
            UserManager<ApplicationUser> userManager,
            IEmailSender emailSender)
        {
            _userManager = userManager;
            _emailSender = emailSender;
        }


        /// <summary>
        /// Request the reset of a users password (via email)
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        [HttpPost("mail")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> RequestResetPassword(string email)
        {
            if (email is null) return BadRequest("Email not set");
            var user = await _userManager.FindByEmailAsync(email);
            if (user is null) return BadRequest("User not found");

            var token = await _userManager.GeneratePasswordResetTokenAsync(user);
            var callbackUrl = Url.Action("ResetPassword", "ResetPassword",
                new ResetPasswordModel {UserId = user.Id, Token = token}, HttpScheme.Https.ToString());
            var encodedCallbackUrl = HtmlEncoder.Default.Encode(callbackUrl);
            await _emailSender.SendEmailAsync(email, "Reset your account password",
                $"Please follow the link to reset your password: <a href='{encodedCallbackUrl}'>Click here</a>");
            return Ok("Email sent");
        }

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public IActionResult ResetPassword(ResetPasswordModel model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest("Invalid model");
            }

            return View(new ResetPasswordViewModel {Token = model.Token, UserId = model.UserId});
        }

        /// <summary>
        /// Confirm reset of a users password
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> ResetPassword(ResetPasswordViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest();
            }

            var user = await _userManager.FindByIdAsync(model.UserId);
            if (user is null)
                return BadRequest("User does not exist");


            var result = await _userManager.ResetPasswordAsync(user, model.Token, model.NewPassword);
            if (result.Succeeded)
            {
                return RedirectToAction("ResetPasswordSuccess");
            }

            return BadRequest(result.Errors);
        }

        [HttpGet("Success")]
        public IActionResult ResetPasswordSuccess()
        {
            return View();
        }
    } 
}