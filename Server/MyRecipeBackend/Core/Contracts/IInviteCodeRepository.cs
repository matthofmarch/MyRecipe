using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Core.Entities;

namespace Core.Contracts
{
    public interface IInviteCodeRepository
    {
        Task<bool> InviteCodeExistsAsync(string inviteCode);
        Task Delete(string code);
    }
}
