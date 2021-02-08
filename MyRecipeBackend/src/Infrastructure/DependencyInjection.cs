using System;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Interfaces.Services;
using MyRecipe.Domain.Entities;
using MyRecipe.Infrastructure.Configurations;
using MyRecipe.Infrastructure.Installers;
using MyRecipe.Infrastructure.Persistence;
using MyRecipe.Infrastructure.Services;
using MyRecipe.Web.Config;

namespace MyRecipe.Infrastructure
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration, IHostEnvironment environment)
        {
            services.AddOptions<SpaLinksOptions>()
                .Bind(configuration.GetSection("SpaLinks"))
                .ValidateDataAnnotations();
            services.AddOptions<JwtOptions>()
                .Bind(configuration.GetSection("Jwt"))
                .ValidateDataAnnotations();
            services.AddOptions<SendGridOptions>()
                .Bind(configuration.GetSection("SendGrid"))
                .ValidateDataAnnotations();
            services.AddOptions<StaticFilesOptions>()
                .Bind(configuration.GetSection("StaticFiles"))
                .ValidateDataAnnotations();
            
            services.AddDbContext<ApplicationDbContext>(builder => builder
                .UseSqlServer(
                    configuration.GetConnectionString("DefaultConnection"),
                    sqlOptions => { sqlOptions.EnableRetryOnFailure(10, TimeSpan.FromSeconds(5), null); })
                .EnableSensitiveDataLogging(environment.IsDevelopment())
            );
            services.AddScoped<IApplicationDbContext, ApplicationDbContext>();
            services.AddScoped<IUnitOfWork, UnitOfWork>();
            
            services.AddTransient<IEmailSender, EmailSender>();

            services.AddIdentity<ApplicationUser, IdentityRole>(options =>
                {
                    options.SignIn.RequireConfirmedAccount = false;
                    options.User.RequireUniqueEmail = true;
                    options.Password.RequireUppercase = false;
                    options.Password.RequireNonAlphanumeric = false;
                    options.Password.RequiredLength = 8;
                })
                .AddEntityFrameworkStores<ApplicationDbContext>()
                .AddTokenProvider<DataProtectorTokenProvider<ApplicationUser>>(configuration["Jwt:RefreshProvider"])
                .AddDefaultTokenProviders();
            
            services.AddJwtAuthentication();

            

            return services;
        }
    }
}