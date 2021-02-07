using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace MyRecipe.Domain.Entities
{
    public class MealVote:EntityObject
    {
        [Required]
        public string UserId { get; set; }
        [ForeignKey(nameof(UserId))]
        public ApplicationUser User { get; set; }
        
        [Required]
        public Guid MealId { get; set; }
        [ForeignKey(nameof(MealId))]      
        public Meal Meal { get; set; }

        public VoteEnum Vote { get; set; }
    }

    public enum VoteEnum
    {
        Rejected,
        Approved
    }
}
