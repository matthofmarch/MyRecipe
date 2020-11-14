using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using Core.Contracts;
using Core.Validations;

namespace Core.Entities
{
    public partial class InviteCode : IDatabaseValidatableObject
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
