using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace Core.Entities
{
    public class UserRecipe : BaseRecipe
    {
        //Required to tell EF Core that Recipe has a relation with User, prevents unwanted Re-Inserting
        public string UserId { get; set; }
        [ForeignKey(nameof(UserId))]
        public ApplicationUser User { get; set; }
        public bool AddToGroupPool { get; set; }
    }
}
