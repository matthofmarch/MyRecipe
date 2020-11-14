using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MyRecipeBackend.Config
{
    public class JwtConfiguration
    {
        public String Key { get; set; }
        public String Issuer { get; set; }
        public String Audience { get; set; }
        public String RefreshProvider { get; set; }
        public String TokenValidMinutes { get; set; }
    }
}
