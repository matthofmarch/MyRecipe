using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Core.Entities;
using Microsoft.AspNetCore.Identity;

namespace Core.Contracts.Services
{
    public interface IUserService
    {
        Task<ApplicationUser> GetUserByClaimsPrincipalAsync(ClaimsPrincipal claimsPrincipal);
    }
}
