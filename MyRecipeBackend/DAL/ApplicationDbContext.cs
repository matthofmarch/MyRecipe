using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.FileProviders;

using System;
using System.Diagnostics;
using Core.Entities;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System.Runtime.CompilerServices;

namespace DAL.Data
{
    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        public DbSet<Group> Groups { get; set; }
        public DbSet<InviteCode> InviteCodes { get; set; }
        public DbSet<BaseRecipe> BaseRecipes { get; set; }
        public DbSet<UserRecipe> UserRecipes { get; set; }
        public DbSet<Ingredient> Ingredients { get; set; }
        public DbSet<Tag> NutritionTags { get; set; }

        public DbSet<RecipeImage> RecipeImages { get; set; }


        public ApplicationDbContext()
        {
            
        }
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {

        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            builder.Entity<RecipeIngredientRelation>()
                .HasKey(rel => new { rel.RecipeId, rel.IngredientId });

            builder.Entity<RecipeIngredientRelation>()
                .HasOne(rel => rel.Recipe)
                .WithMany(rel => rel.Ingredients) // Property from recipe
                .HasForeignKey(rel => rel.RecipeId);

            builder.Entity<RecipeIngredientRelation>()
                .HasOne(rel => rel.Ingredient)
                .WithMany(rel => rel.Recipes) // Property from ingredient
                .HasForeignKey(rel => rel.IngredientId);

            builder.Entity<IngredientTagRelation>()
                .HasKey(rel => new { rel.IngredientId, rel.TagId });

            builder.Entity<IngredientTagRelation>()
                .HasOne(rel => rel.Ingredient)
                .WithMany(rel => rel.Tags) // Property from ingredient
                .HasForeignKey(rel => rel.IngredientId);

            builder.Entity<IngredientTagRelation>()
                .HasOne(rel => rel.Tag)
                .WithMany(rel => rel.Ingredients) // Property from Tag
                .HasForeignKey(rel => rel.TagId);



            base.OnModelCreating(builder);
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                var builder = new ConfigurationBuilder()
                    .SetBasePath(Environment.CurrentDirectory)
                    .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);
                var configuration = builder.Build();
                Debug.Write(configuration.ToString());
                string connectionString = configuration["ConnectionStrings:DefaultConnection"];
                optionsBuilder.UseSqlServer(connectionString);
                //optionsBuilder.UseLoggerFactory(GetLoggerFactory());
            }
        }

    }
}
