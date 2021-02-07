using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Web
{
    public class TokenStillValidMiddleware
    {
        private readonly RequestDelegate _next;

        public TokenStillValidMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task InvokeAsync(HttpContext context, UserManager<ApplicationUser> userManager)
        {
            var user = await userManager.GetUserAsync(context.User);
            if (user is not null &&
                (user.IsAdmin != context.User.IsInRole("GroupAdmin") 
                || user.GroupId.ToString() != context.User.Claims.Single(c => c.Type == "household").Value))
            {
                await context.Response.WriteAsJsonAsync(new ForbidResult());
                context.Abort();
                return;
            }

            await _next(context);
        }
    }
}
