using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace MyRecipeBackend.Models
{
    public class RefreshToken
    {
        [Key]
        public string Token { get; set; }
        public DateTime Expiration { get; set; }
    }
}
