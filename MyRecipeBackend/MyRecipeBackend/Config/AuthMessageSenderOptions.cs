using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MyRecipeBackend.Services
{
    public class AuthMessageSenderOptions
    {
        //MyRecipe
        public string SendGridUser { get; set; }

        //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
        public string SendGridKey { get; set; }
    }
}
