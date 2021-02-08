using System;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Common.Models.Group
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
