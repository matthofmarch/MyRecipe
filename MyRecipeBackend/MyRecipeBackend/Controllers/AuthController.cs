using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Resources;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;
using DAL;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using MyRecipeBackend.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion.Internal;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using MyRecipeBackend.Config;

namespace MyRecipeBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly ApplicationDbContext _dbContext;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly IEmailSender _emailSender;
        private readonly SpaLinks _spaLinks;
        private readonly JwtConfiguration _jwtConfiguration;

        public AuthController(
            UserManager<ApplicationUser> userManager,
            SignInManager<ApplicationUser> signInManager,
            IEmailSender emailSender,
            IOptions<JwtConfiguration> jwtConfiguration,
            IOptions<SpaLinks> spaLinks,
            ApplicationDbContext dbContext)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _emailSender = emailSender;
            _spaLinks = spaLinks.Value;
            _jwtConfiguration = jwtConfiguration.Value;
            _dbContext = dbContext;
        }

        /// <summary>
        /// Login endpoint for a user, Default users: test1@test.test and test2@test.test, Pw: Pass123$
        /// </summary>
        /// <param name="model"></param>
        /// <returns>accessToken, refreshToken</returns>
        [HttpPost]
        [Route("login")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> Login([FromBody] LoginModel model)
        {
            if (!ModelState.IsValid)
                return BadRequest();

            var result = await _signInManager.PasswordSignInAsync(model.Email, model.Password, true, false);
            if (result.Succeeded)
            {
                var user = await _userManager.FindByEmailAsync(model.Email);
                var customClaims = await _userManager.GetClaimsAsync(user);


                var identityClaims = new List<Claim>
                {
                    new Claim(ClaimTypes.Name, user.Id),
                    new Claim(ClaimTypes.NameIdentifier, user.Id),
                    new Claim(ClaimTypes.Email, user.Email),
                    new Claim(JwtRegisteredClaimNames.Sub, user.Email),
                    new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
                };

                if (user.IsAdmin)
                {
                    identityClaims.Add(new Claim(ClaimTypes.Role, "Admin"));
                }


                var token = GenerateJwtToken(identityClaims.Concat(customClaims));
                var refreshToken = await _userManager.GenerateUserTokenAsync(
                    user, _jwtConfiguration.RefreshProvider, "RefreshToken");

                await _userManager.SetAuthenticationTokenAsync(user, _jwtConfiguration.RefreshProvider,
                    "RefreshToken", refreshToken);

                return Ok(new
                {
                    token,
                    expiration = DateTime.Now.AddMinutes(Convert.ToInt32(_jwtConfiguration.TokenValidMinutes)),
                    refreshToken
                });
            }
            else if (result.IsNotAllowed)
                return Unauthorized(new {Error = "Email needs to be confirmed"});

            return Unauthorized();

        }

        /// <summary>
        /// Register a new user
        /// </summary>
        /// <param name="loginModel"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("register")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> Register([FromBody] LoginModel loginModel)
        {
            if (!ModelState.IsValid) return BadRequest();

            var user = new ApplicationUser
            {
                Email = loginModel.Email,
                SecurityStamp = Guid.NewGuid().ToString(),
                UserName = loginModel.Email
            };
            var result = await _userManager.CreateAsync(user, loginModel.Password);

            if (result.Succeeded)
            {
                var code = await _userManager.GenerateEmailConfirmationTokenAsync(user);
                var callbackUrl = Url.Action("ConfirmEmail", "Auth", new {userId = user.Id, code}, HttpScheme.Https.ToString());
                await _emailSender.SendEmailAsync(loginModel.Email, "Confirm your email",
                    $"Please confirm your account by <a href='{HtmlEncoder.Default.Encode(callbackUrl)}'>clicking here</a>.");
                return Ok();
            }

            return BadRequest(result.Errors);
        }


        /// <summary>
        /// Called to confirm a users email
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="code"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("confirmemail")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> ConfirmEmail(string userId, string code)
        {
            if (userId == null || code == null)
                return BadRequest();
            var user = await _userManager.FindByIdAsync(userId);
            var result = await _userManager.ConfirmEmailAsync(user, code);
            if (result.Succeeded)
                return Ok("Successfully confirmed");

            return BadRequest(result.Errors);
        }

        /// <summary>
        /// Change a users password (has to be logged in)
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost("changePassword")]
        [Authorize]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> ChangePassword(ChangePasswordModel model)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null)
                return BadRequest("User not found");

            var res = await _userManager.ChangePasswordAsync(user, model.CurrentPassword, model.NewPassword);
            if (res.Succeeded) return Ok();
            return BadRequest("Reset failed");
        }

        /// <summary>
        /// Request the reset of a users password (via email)
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("resetPassword")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> ResetPassword(string email)
        {
            if (email == null) return BadRequest("Email not set");
            var user = await _userManager.FindByEmailAsync(email);
            if (user == null) return BadRequest("User not found");

            var token = await _userManager.GeneratePasswordResetTokenAsync(user);
            var callbackUrl =
                $"{_spaLinks.ResetPasswordBaseLink}?userId={WebUtility.UrlEncode(user.Id)}&token={WebUtility.UrlEncode(token)}";
            await _emailSender.SendEmailAsync(email, "Reset your account password",
                $"Please follow the link to reset your password: <a href='{HtmlEncoder.Default.Encode(callbackUrl)}'>Click here</a>");
            return Ok("Email sent");
        }

        /// <summary>
        /// Confirm reset of a users password
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("resetPassword")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> ResetPassword(ResetPasswordConfirmModel model)
        {
            if (ModelState.IsValid)
            {
                var user = await _userManager.FindByIdAsync(model.UserId);
                if (user != null)
                {
                    var result = await _userManager.ResetPasswordAsync(user, model.Token, model.NewPassword);
                    if (result.Succeeded)
                    {
                        return Ok();
                    }

                    return BadRequest(result.Errors);
                }
            }

            return BadRequest();
        }

        /// <summary>
        /// Request the change of email for a user (has to be logged in)
        /// </summary>
        /// <param name="newEmail"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("changeEmail")]
        [Authorize]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> ChangeEmail(string newEmail)
        {
            if (newEmail == null) return BadRequest("New Email not provided");
            var user = await _userManager.GetUserAsync(User);
            if (user == null) return BadRequest("Could not find User");

            var token = await _userManager.GenerateChangeEmailTokenAsync(user, newEmail);
            var callbackUrl =
                $"{_spaLinks.ResetEmailBaseLink}" +
                $"?userId={WebUtility.UrlEncode(user.Id)}" +
                $"&token={WebUtility.UrlEncode(token)}" +
                $"&newEmail={WebUtility.UrlEncode(newEmail)}";
            await _emailSender.SendEmailAsync(newEmail, "Change your account email",
                $"Please follow the link to confirm your email change: <a href='{HtmlEncoder.Default.Encode(callbackUrl)}'>Click here</a>");
            return Ok("Email sent");
        }

        /// <summary>
        /// Confirm the change of a users email
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("changeEmail")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> ChangeEmail(ResetEmailConfirmModel model)
        {
            if (ModelState.IsValid)
            {
                var user = await _userManager.FindByIdAsync(model.UserId);
                if (user == null) return BadRequest("Could not find User");

                var result = await _userManager.ChangeEmailAsync(user, model.NewEmail, model.Token);
                var resultUserNameChange = await _userManager.SetUserNameAsync(user, model.NewEmail);

                if (result.Succeeded && resultUserNameChange.Succeeded)
                {
                    return Ok();
                }

                return BadRequest(result.Succeeded ? resultUserNameChange.Errors : result.Errors);
            }

            return BadRequest();
        }

        /// <summary>
        /// Exchange refresh tokens for a new access token
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("refresh")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> Refresh(RefreshModel model)
        {
            if (ModelState.IsValid)
            {
                ClaimsPrincipal principal;

                try
                {
                    principal = GetPrincipalFromExpiredToken(model.Token);
                }
                catch (SecurityTokenException e)
                {
                    return BadRequest(e.Message);
                }

                var user = await _userManager.FindByIdAsync(principal.Identity.Name);
                var result = await _dbContext.UserTokens.SingleOrDefaultAsync(t =>
                        t.UserId == user.Id && t.Value == model.RefreshToken);

                if (user != null && result != null)
                {
                    var newToken = GenerateJwtToken(principal.Claims);
                    await _userManager.RemoveAuthenticationTokenAsync(user, _jwtConfiguration.RefreshProvider,
                        "RefreshToken");
                    var newRefreshToken = await _userManager.GenerateUserTokenAsync(user,
                        _jwtConfiguration.RefreshProvider, "RefreshToken");
                    await _userManager.SetAuthenticationTokenAsync(user, _jwtConfiguration.RefreshProvider,
                        "RefreshToken", newRefreshToken);

                    return Ok(new
                    {
                        token = newToken,
                        expiration = DateTime.Now.AddMinutes(Convert.ToDouble(_jwtConfiguration.TokenValidMinutes)),
                        refreshToken = newRefreshToken
                    });
                }
            }

            return BadRequest();
        }


        private string GenerateJwtToken(IEnumerable<Claim> claims)
        {
            var authSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtConfiguration.Key));

            var token = new JwtSecurityToken(
                _jwtConfiguration.Issuer,
                _jwtConfiguration.Audience,
                expires: DateTime.Now.AddMinutes(Convert.ToDouble(_jwtConfiguration.TokenValidMinutes)),
                claims: claims,
                signingCredentials: new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha256)
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        private ClaimsPrincipal GetPrincipalFromExpiredToken(string token)
        {
            var tokenValidationParameters = new TokenValidationParameters
            {
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateIssuerSigningKey = true,
                ValidAudience = _jwtConfiguration.Audience,
                ValidIssuer = _jwtConfiguration.Issuer,
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtConfiguration.Key)),
                ValidateLifetime = false
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var principal = tokenHandler.ValidateToken(token, tokenValidationParameters, out var securityToken);
            var jwtSecurityToken = securityToken as JwtSecurityToken;
            if (jwtSecurityToken == null || !jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256,
                StringComparison.InvariantCultureIgnoreCase))
                throw new SecurityTokenException("Invalid token");

            return principal;
        }
    }
}