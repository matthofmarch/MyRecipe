using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Core.Entities;
using Devices.Core.Contracts;

namespace Core.Contracts
{
    public interface IInviteCodeRepository:IEntityRepository<InviteCode>
    {
        Task<bool> InviteCodeExistsAsync(string inviteCode);
        Task Delete(string code);
    }
}
