using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;
using System.Text.Json.Serialization;
using Core.Contracts;
using Core.Entities;
using DAL;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using MyRecipeBackend.Config;
using MyRecipeBackend.Config.StartupExtensions;
using MyRecipeBackend.Services;
using Serilog;

namespace MyRecipeBackend
{
    public class Startup
    {
        public Startup(IConfiguration configuration, IHostEnvironment environment)
        {
            Configuration = configuration;
            Environment = environment;
        }

        public IHostEnvironment Environment { get; }
        public IConfiguration Configuration { get; }

        /// <summary>
        /// This method gets called by the runtime. Use this method to add services to the container.
        /// </summary>
        /// <param name="services"></param>
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddDbContext<ApplicationDbContext>(builder => builder
                .UseSqlServer(
                    Configuration.GetConnectionString("DefaultConnection"),
                    sqlOptions => { sqlOptions.EnableRetryOnFailure(10, TimeSpan.FromSeconds(5), null); })
                .EnableSensitiveDataLogging(Environment.IsDevelopment())
            );

            services.AddIdentity<ApplicationUser, IdentityRole>(options =>
                {
                    options.SignIn.RequireConfirmedAccount = true;
                    options.User.RequireUniqueEmail = true;
                })
                .AddEntityFrameworkStores<ApplicationDbContext>()
                .AddTokenProvider<DataProtectorTokenProvider<ApplicationUser>>(Configuration["Jwt:RefreshProvider"])
                .AddDefaultTokenProviders();

            services.AddScoped<IUnitOfWork, UnitOfWork>();

            var jwtSection = Configuration.GetSection("Jwt");
            services.Configure<JwtConfiguration>(jwtSection);
            var jwtConfiguration = jwtSection.Get<JwtConfiguration>();

            services.AddJwtAuthenication(jwtConfiguration);

            services.AddCustomSwagger();

            services.AddTransient<IEmailSender, EmailSender>();
            services.Configure<AuthMessageSenderOptions>(Configuration);

            services.AddCors(options =>
                options.AddDefaultPolicy(builder =>
                    builder.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod()));

            services.Configure<SpaLinks>(Configuration.GetSection("SpaLinks"));

            services.AddControllersWithViews().AddJsonOptions(options =>
            {
                options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, ApplicationDbContext dbContext)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else if (env.IsStaging())
            {
                dbContext.Database.EnsureDeleted();
                dbContext.Database.Migrate();
                app.UseHttpsRedirection();
            }
            else if (env.IsProduction())
            {
                app.UseHttpsRedirection();
                dbContext.Database.Migrate();
            }

            var staticFileDirectory =
                Path.Combine(Directory.GetCurrentDirectory(), Configuration["StaticFiles:ImageBasePath"]);
            if (!Directory.Exists(staticFileDirectory))
                Directory.CreateDirectory(staticFileDirectory);

            app.UseStaticFiles();
            app.UseStaticFiles(new StaticFileOptions
            {
                FileProvider = new PhysicalFileProvider(staticFileDirectory),
                RequestPath = "/" + Configuration["StaticFiles:ImageBasePath"]
            });
            app.UseSerilogRequestLogging();


            app.UseRouting();
            app.UseCors();

            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllerRoute(
                    name: "default",
                    pattern: "{controller=Home}/{action=Index}/{id?}");
            });

            app.UseCustomSwagger();
        }
    }
}