using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Http;
using MyRecipeBackend.Data;
using MyRecipeBackend.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using MyRecipeBackend.Services;

namespace MyRecipeBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly IEmailSender _emailSender;
        private readonly IConfiguration _configuration;
        private readonly ApplicationDbContext _dbContext;

        public AuthController(UserManager<ApplicationUser> userManager, SignInManager<ApplicationUser> signInManager, IEmailSender emailSender, IConfiguration config, ApplicationDbContext dbContext)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _emailSender = emailSender;
            _configuration = config;
            _dbContext = dbContext;
        }

        [HttpPost]
        [Route("login")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> Login([FromBody] LoginModel model)
        {
            if (ModelState.IsValid)
            {
                var result = await _signInManager.PasswordSignInAsync(model.Email, model.Password, true, false);
                if (result.Succeeded)
                {
                    var user = await _userManager.FindByEmailAsync(model.Email);
                    var claims = await _userManager.GetClaimsAsync(user);


                    var authClaims = new List<Claim>
                    {
                        new Claim(ClaimTypes.Name, user.Id),
                        new Claim(ClaimTypes.Email, user.Email),
                        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
                    };

                    authClaims.AddRange(claims);

                    var token = GenerateJwtToken(authClaims);
                    var refreshToken = await _userManager.GenerateUserTokenAsync(user,
                        _configuration["Jwt:RefreshProvider"], "RefreshToken");
                    await _userManager.SetAuthenticationTokenAsync(user, _configuration["Jwt:RefreshProvider"],
                        "RefreshToken", refreshToken);

                    return Ok(new
                    {
                        token,
                        expiration = DateTime.Now.AddMinutes(Convert.ToDouble(_configuration["Jwt:TokenValidMinutes"])),
                        refreshToken
                    });
                }
                else if (result.IsNotAllowed)
                    return Unauthorized(new { Error = "Email needs to be confirmed" });
                return Unauthorized();
            }
            return BadRequest();
        }

        [HttpPost]
        [Route("register")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> Register([FromBody] LoginModel loginModel)
        {
            if (ModelState.IsValid)
            {
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
                    var callbackUrl = Url.Action("ConfirmEmail","Auth", new { userId = user.Id, code }, Request.Scheme);
                    await _emailSender.SendEmailAsync(loginModel.Email, "Confirm your email",
                        $"Please confirm your account by <a href='{HtmlEncoder.Default.Encode(callbackUrl)}'>clicking here</a>.");
                    return Ok();
                }
                return BadRequest(result.Errors);
            }
            return BadRequest();
        }

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

        [HttpGet]
        [Route("resetPassword")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> ResetPassword(string email)
        {
            if (email == null)
                return Ok();
            var user = await _userManager.FindByEmailAsync(email);
            if (user != null)
            {
                var token = await _userManager.GeneratePasswordResetTokenAsync(user);
                var callbackUrl = $"{_configuration["SpaLinks:ResetPasswordBaseLink"]}?userId={WebUtility.UrlEncode(user.Id)}&token={WebUtility.UrlEncode(token)}";
                await _emailSender.SendEmailAsync(email, "Reset your account password",
                    $"Please follow the link to reset your password: <a href='{HtmlEncoder.Default.Encode(callbackUrl)}'>Click here</a>");
            }
            return Ok();
        }

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
                    principal =  GetPrincipalFromExpiredToken(model.Token);
                }
                catch (SecurityTokenException e)
                {
                    return BadRequest(e.Message);
                }
                var user = await _userManager.FindByIdAsync(principal.Identity.Name);
                var result = await _dbContext.UserTokens.SingleOrDefaultAsync(t => t.UserId == user.Id && t.Value == model.RefreshToken);
                if (user != null && result != null)
                {
                    var newToken = GenerateJwtToken(principal.Claims);
                    await _userManager.RemoveAuthenticationTokenAsync(user, _configuration["Jwt:RefreshProvider"],
                        "RefreshToken");
                    var newRefreshToken = await _userManager.GenerateUserTokenAsync(user,
                        _configuration["Jwt:RefreshProvider"], "RefreshToken");
                    await _userManager.SetAuthenticationTokenAsync(user, _configuration["Jwt:RefreshProvider"],
                        "RefreshToken", newRefreshToken);

                    return Ok(new
                    {
                        token = newToken,
                        expiration = DateTime.Now.AddMinutes(Convert.ToDouble(_configuration["Jwt:TokenValidMinutes"])),
                        refreshToken = newRefreshToken
                    });
                }
            }

            return BadRequest();
        }

        private string GenerateJwtToken(IEnumerable<Claim> claims)
        {
            var authSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));

            var token = new JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"],
                audience: _configuration["Jwt:Audience"],
                expires: DateTime.Now.AddMinutes(Convert.ToDouble(_configuration["Jwt:TokenValidMinutes"])),
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
                ValidAudience = _configuration["Jwt:Audience"],
                ValidIssuer = _configuration["Jwt:Issuer"],
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"])),
                ValidateLifetime = false
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var principal = tokenHandler.ValidateToken(token, tokenValidationParameters, out var securityToken);
            var jwtSecurityToken = securityToken as JwtSecurityToken;
            if (jwtSecurityToken == null || !jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCultureIgnoreCase))
                throw new SecurityTokenException("Invalid token");

            return principal;
        }
    }
}