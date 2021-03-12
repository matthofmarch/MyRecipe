using System;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Interfaces.Services;
using MyRecipe.Domain.Entities;
using MyRecipe.Infrastructure.Installers;
using MyRecipe.Infrastructure.Options;
using MyRecipe.Infrastructure.Persistence;
using MyRecipe.Infrastructure.Services;

namespace MyRecipe.Infrastructure
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddInfrastructure(this IServiceCollection services,
            IConfiguration configuration, IHostEnvironment environment)
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
            services.AddOptions<StaticRecipeImagesOptions>()
                .Bind(configuration.GetSection("StaticFiles"))
                .ValidateDataAnnotations();

            // Set the active provider via configuration
            var provider = configuration.GetValue("Provider", "SqlServer");
            services.AddDbContext<ApplicationDbContext>(
                options => _ = provider switch
                {
                    "AppServiceMySql" => options.UseMySql(
                        Environment.GetEnvironmentVariable("MYSQLCONNSTR_localdb")!,
                        ServerVersion.AutoDetect(Environment.GetEnvironmentVariable("MYSQLCONNSTR_localdb")!),
                        x => { x.MigrationsAssembly("MyRecipe.Infrastructure.Persistence.Migrations.MySql"); }),
                    "MySql" => options.UseMySql(
                        configuration.GetConnectionString("MySqlConnection"),
                        ServerVersion.AutoDetect(configuration.GetConnectionString("MySqlConnection")),
                        x => { x.MigrationsAssembly("MyRecipe.Infrastructure.Persistence.Migrations.MySql"); }),
                    "SqlServer" => options.UseSqlServer(
                        configuration.GetConnectionString("SqlServerConnection"),
                        x => { x.MigrationsAssembly("MyRecipe.Infrastructure.Persistence.Migrations.SqlServer"); }),

                    _ => throw new Exception($"Unsupported provider: {provider}")
                });

            services.AddScoped<DbContext>(s => s.GetService<ApplicationDbContext>());
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