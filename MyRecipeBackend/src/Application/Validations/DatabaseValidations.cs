using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Validations
{
    public static class DatabaseValidations
    {
        public static async Task<ValidationResult> CheckInviteCodeAlreadyExist(InviteCode inviteCode, IUnitOfWork unitOfWork)
        {
            if(inviteCode is null)
                throw new ArgumentNullException();

            var exists = await unitOfWork.InviteCodes.InviteCodeExistsAsync(inviteCode.Code);

            if (exists)
            {
                return new ValidationResult("InviteCode already exists", new List<string> {nameof(inviteCode.Code)});
            }
            return ValidationResult.Success;
        }
    }
}
