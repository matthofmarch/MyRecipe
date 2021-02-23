using System.IO;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Infrastructure;
using MyRecipe.Infrastructure.Options;
using MyRecipe.Web.Installers;
using Serilog;

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

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddLogging();
            services.AddCustomSwaggerGen();
            services.AddInfrastructure(Configuration, Environment);

            services.AddCors(options =>
                options.AddDefaultPolicy(builder =>
                    builder.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod()));

            services.AddControllersWithViews().AddJsonOptions(options =>
            {
                options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());
            });
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IApplicationDbContext dbContext,
            IOptions<StaticRecipeImagesOptions> staticFilesConfiguration
        )
        {
            if (env.IsDevelopment()) app.UseDeveloperExceptionPage();

            app.UseHttpsRedirection();

            if (env.IsStaging() | env.IsProduction()) dbContext.Database.Migrate();

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
                    "default",
                    "{controller=Home}/{action=Index}/{id?}");
            });

            app.UseCustomSwagger();
        }
    }
}