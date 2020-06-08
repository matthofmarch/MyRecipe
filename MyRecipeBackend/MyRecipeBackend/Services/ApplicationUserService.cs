using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Core.Contracts.Services;
using Core.Entities;
using Microsoft.AspNetCore.Identity;

namespace MyRecipeBackend.Services
{
    public class ApplicationUserService:IUserService
    {
        private readonly UserManager<ApplicationUser> _userManager;

        public ApplicationUserService(UserManager<ApplicationUser> userManager)
        {
            this._userManager = userManager;
        }

        public Task<ApplicationUser> GetUserByClaimsPrincipalAsync(ClaimsPrincipal claimsPrincipal)
        {
            return _userManager.GetUserAsync(claimsPrincipal);
        }


    }
}
