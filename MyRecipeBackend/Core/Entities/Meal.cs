using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;
using Core.Entities;

namespace Core.Entities
{
    /// <summary>
    /// A meal is created when a User wants to use a recipe at a given day
    /// </summary>
    public class Meal: EntityObject
    { 
        [Required]
        public Guid RecipeId { get; set; }
        [ForeignKey(nameof(RecipeId))]
        public UserRecipe Recipe { get; set; }

        public DateTime DateTime { get; set; }

        /// <summary>
        /// This may or may not be shown on the voting screen
        /// </summary>
        public string InitiatorId { get; set; }
        [ForeignKey(nameof(InitiatorId))]
        public ApplicationUser Initiator { get; set; }

        [Required]
        public Guid GroupId { get; set; }
        [ForeignKey(nameof(GroupId))]
        public Group Group { get; set; }

        //This flag shall be set after a threshold of positive votes has been reached
        [Required]
        public Boolean Accepted { get; set; } = false;
        
        public List<MealVote> Votes { get; set; }
    }
}