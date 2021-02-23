using System;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Interfaces.Repositories;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Logic.Repositories
{
    public class ApplicationUserRepository : IApplicationUserRepository
    {
        private readonly IApplicationDbContext _dbContext;

        public ApplicationUserRepository(IApplicationDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<ApplicationUser> GetByEmailAsync(string email)
        {
            return await _dbContext.Users
                .Include(u => u.Group)
                .SingleOrDefaultAsync(u => string.Equals(u.Email, email, StringComparison.CurrentCultureIgnoreCase));
        }
    }
}