namespace MyRecipe.Web.Config
{
    public class JwtConfiguration
    {
        public string Key { get; set; }
        public string Issuer { get; set; }
        public string Audience { get; set; }
        public string RefreshProvider { get; set; }
        public string TokenValidMinutes { get; set; }
    }
}
