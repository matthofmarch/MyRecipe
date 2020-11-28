using Core.Entities;
using Devices.Core.Contracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Core.Contracts.Repositories
{
    public interface IApplicationUserRepository
    {
        Task<ApplicationUser> GetByEmailAsync(string email);
    }
}
