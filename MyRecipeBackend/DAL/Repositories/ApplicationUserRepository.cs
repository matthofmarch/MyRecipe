using Core.Contracts.Repositories;
using Core.Entities;
using Devices.Persistence.Repositories;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.Repositories
{
    public class ApplicationUserRepository : IApplicationUserRepository
    {
        private readonly ApplicationDbContext _dbContext;
        public ApplicationUserRepository(ApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<ApplicationUser> GetByEmailAsync(string email)
        {
            return await _dbContext.Users
                .Include(u => u.Group)
                .SingleOrDefaultAsync(u => u.Email.ToUpper() == email.ToUpper());
        }
    }
}
