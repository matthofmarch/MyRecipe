namespace Core.Entities
{
    public class UserRecipe : BaseRecipe
    {
        public ApplicationUser ApplicationUser { get; set; }
        public bool AddToGroupPool { get; set; }
    }
}
