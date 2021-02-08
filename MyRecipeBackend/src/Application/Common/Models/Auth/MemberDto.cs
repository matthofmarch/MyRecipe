using MyRecipe.Domain.Entities;

namespace MyRecipe.Application.Common.Models.Auth
{
    public class MemberDto
    {
        public string Email { get; set; }
        public bool IsAdmin { get; set; }

        public MemberDto(ApplicationUser user)
        {
            Email = user.Email;
            IsAdmin = user.IsAdmin;
        }
    }
}
