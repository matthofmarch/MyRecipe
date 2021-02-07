using System;
using System.IO;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using MyRecipe.Application.Common.Config;
using MyRecipe.Application.Common.Config.Installers;
using MyRecipe.Application.Common.Config.StartupExtensions;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Application.Common.Interfaces.Services;
using MyRecipe.Application.Logic;
using MyRecipe.Domain.Entities;
using MyRecipe.Infrastructure.Persistence;
using MyRecipe.Infrastructure.Services;
using MyRecipe.Web.Config;
using Serilog;
using static Microsoft.Extensions.Hosting.Environments;

namespace MyRecipe.Web
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
            services.AddLogging();

            services.AddDbContext<ApplicationDbContext>(builder => builder
                .UseSqlServer(
                    Configuration.GetConnectionString("DefaultConnection"),
                    sqlOptions => { sqlOptions.EnableRetryOnFailure(10, TimeSpan.FromSeconds(5), null); })
                .EnableSensitiveDataLogging(Environment.IsDevelopment())
            );
            services.AddScoped<IApplicationDbContext, ApplicationDbContext>();

            services.AddIdentity<ApplicationUser, IdentityRole>(options =>
                {
                    options.SignIn.RequireConfirmedAccount = false;
                    options.User.RequireUniqueEmail = true;
                    options.Password.RequireUppercase = false;
                    options.Password.RequireNonAlphanumeric = false;
                    options.Password.RequiredLength = 8;
                })
                .AddEntityFrameworkStores<ApplicationDbContext>()
                .AddTokenProvider<DataProtectorTokenProvider<ApplicationUser>>(Configuration["Jwt:RefreshProvider"])
                .AddDefaultTokenProviders();

            services.AddScoped<IUnitOfWork, UnitOfWork>();

            var jwtSection = Configuration.GetSection("Jwt");
            services.Configure<JwtConfiguration>(jwtSection);
            var jwtConfiguration = jwtSection.Get<JwtConfiguration>();

            services.AddJwtAuthenication(jwtConfiguration);
            services.AddCustomSwaggerGen();

            services.AddTransient<IEmailSender, EmailSender>();
            services.Configure<AuthMessageSenderOptions>(Configuration);

            services.AddCors(options =>
                options.AddDefaultPolicy(builder =>
                    builder.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod()));

            services.Configure<SpaLinksConfiguration>(Configuration.GetSection("SpaLinks"));
            services.Configure<StaticFilesOptions>(Configuration.GetSection("StaticFiles"));

            services.AddControllersWithViews().AddJsonOptions(options =>
            {
                options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        /// <summary>
        /// 
        /// </summary>
        /// <param name="app"></param>
        /// <param name="env"></param>
        /// <param name="dbContext"></param>
        /// <param name="staticFilesConfiguration"></param>
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IApplicationDbContext dbContext, 
            IOptions<StaticFilesOptions> staticFilesConfiguration
        )
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            if (!env.IsDevelopment())
            {
                app.UseHttpsRedirection();
            }
            
            if (env.IsStaging() || env.IsProduction())
            {
                dbContext.Database.Migrate();
            }
            
            app.UseSerilogRequestLogging();

            var imagePath =
                Path.Combine(Directory.GetCurrentDirectory(), staticFilesConfiguration.Value.ImageBasePath);
            if (!Directory.Exists(imagePath))
                Directory.CreateDirectory(imagePath);
            app.UseStaticFiles(new StaticFileOptions
            {
                FileProvider = new PhysicalFileProvider(imagePath),
                RequestPath = "/" + staticFilesConfiguration.Value.ImageBasePath
            });

            app.UseRouting();
            app.UseCors();

            app.UseAuthentication();
            app.UseAuthorization();
            app.UseMiddleware<TokenStillValidMiddleware>();

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