using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;

namespace MyRecipeBackend.Config.StartupExtensions
{
    public static class ConfigureJwtAuthentication
    {
        public static IServiceCollection AddJwtAuthenication(this IServiceCollection services, JwtConfiguration jwtConfiguration)
        {
            services.AddAuthentication(options =>
                {
                    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                })
                .AddJwtBearer(options =>
                {
                    options.SaveToken = true;
                    options.RequireHttpsMetadata = false;
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuer = true,
                        ValidIssuer = jwtConfiguration.Issuer,
                        ValidateAudience = true,
                        ValidAudience = jwtConfiguration.Audience,
                        ValidateIssuerSigningKey = true,
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtConfiguration.Key)),
                        ValidateLifetime = true,
                        ClockSkew = TimeSpan.Zero
                    };
                });
            return services;
        }
    }
}
