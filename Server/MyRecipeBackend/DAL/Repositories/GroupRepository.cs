using System;
using System.Collections.Generic;
using System.Text;
using Core.Entities;
using DAL.Data;
using Microsoft.EntityFrameworkCore;

namespace DAL.Repositories
{
    class GroupRepository: GenericRepository<Group>
    {
        public GroupRepository(ApplicationDbContext dbContext):base(dbContext)
        {
            
        }
    }
}
