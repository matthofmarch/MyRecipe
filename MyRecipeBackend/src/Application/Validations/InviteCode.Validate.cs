using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Validations
{
    public class ValidatableInviteCode : InviteCode, IValidatableObject
    {
        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            var unitOfWork = validationContext.GetService(typeof(IUnitOfWork)) as IUnitOfWork;
            if (unitOfWork == null)
                throw new AccessViolationException("UnitOfWork is not injected!");
            var validationResults = DatabaseValidations.CheckInviteCodeAlreadyExist(this, unitOfWork).Result;
            if (validationResults != ValidationResult.Success)
                yield return validationResults;
        }
    }
}
