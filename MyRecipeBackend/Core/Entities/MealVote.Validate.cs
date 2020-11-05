using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using Core.Contracts;
using Core.Validations;
using DAL;

namespace Core.Entities
{
    public partial class MealVote : IDatabaseValidatableObject
    {
        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            var unitOfWork = validationContext.GetService(typeof(IUnitOfWork)) as IUnitOfWork;
            if (unitOfWork == null)
                throw new AccessViolationException("UnitOfWork is not injected!");
            var validationResults = DatabaseValidations.CheckIfUserAlreadyVotedAsync(this, unitOfWork).Result;
            if (validationResults != ValidationResult.Success)
                yield return validationResults;
        }
    }
}
