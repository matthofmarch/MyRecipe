using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Core.Entities;

namespace MyRecipeBackend.Models
{
    public class InviteCodeDto
    {
        public string Code { get; set; }
        public DateTime CreationDate { get; set; }

        public InviteCodeDto(InviteCode inviteCode)
        {
            Code = inviteCode.Code;
            CreationDate = inviteCode.CreationDate;
        }
    }
}
