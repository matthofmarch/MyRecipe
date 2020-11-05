using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using System.Threading.Tasks;
using Core.Contracts;
using Core.Entities;

namespace Core.Validations
{
    public static class DatabaseValidations
    {
        public static async Task<ValidationResult> CheckInviteCodeAlreadyExist(InviteCode inviteCode, IUnitOfWork unitOfWork)
        {
            if(inviteCode == null)
                throw new ArgumentNullException();

            var exists = await unitOfWork.InviteCodes.InviteCodeExistsAsync(inviteCode.Code);

            if (exists)
            {
                return new ValidationResult("InviteCode already exists", new List<string> {nameof(inviteCode.Code)});
            }
            return ValidationResult.Success;
        }

        public static async Task<ValidationResult> CheckIfUserAlreadyVotedAsync(MealVote mealVote, IUnitOfWork unitOfWork)
        {
            if(mealVote == null)
                throw new ArgumentNullException();

            var hasVoted = await unitOfWork.Meals.UserHasAlreadyVotedAsync(mealVote);

            if (hasVoted)
            {
                return new ValidationResult("User has already voted for this meal", new []{nameof(mealVote.User)});
            }
            return ValidationResult.Success;
        }
    }
}
