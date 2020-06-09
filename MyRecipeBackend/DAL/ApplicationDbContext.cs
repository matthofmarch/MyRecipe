using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.FileProviders;

using System;
using System.Collections.Generic;
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
        public DbSet<RecipeIngredientRelation> RecipeIngredientRelations { get; set; }

        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {

        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            builder.Entity<RecipeIngredientRelation>(e =>
            {
                e.HasKey(rel => new {rel.RecipeId, rel.IngredientId});

                e.HasOne(rel => rel.Recipe)
                    .WithMany(rel => rel.Ingredients) // Property from recipe
                    .HasForeignKey(rel => rel.RecipeId);

                e.HasOne(rel => rel.Ingredient)
                    .WithMany(rel => rel.Recipes) // Property from ingredient
                    .HasForeignKey(rel => rel.IngredientId);
            });

            builder.Entity<IngredientTagRelation>(e =>
            {
                e.HasKey(rel => new { rel.IngredientId, rel.TagId });

                e.HasOne(rel => rel.Ingredient)
                    .WithMany(rel => rel.Tags) // Property from ingredient
                    .HasForeignKey(rel => rel.IngredientId);

                e.HasOne(rel => rel.Tag)
                    .WithMany(rel => rel.Ingredients) // Property from Tag
                    .HasForeignKey(rel => rel.TagId);
            });

            SeedDatabase(builder);
        }

        private void SeedDatabase(ModelBuilder builder)
        {
            builder.Entity<Ingredient>().HasData(new List<Ingredient>
            {
                new Ingredient {Id = new Guid("00000000-0000-0000-0000-000000000001"), Name = "Salad"},
                new Ingredient {Id = new Guid("00000000-0000-0000-0000-000000000002"), Name = "Potato"},
                new Ingredient {Id = new Guid("00000000-0000-0000-0000-000000000003"), Name = "Rice"}
            });

        }

        // protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        // {
        //     if (!optionsBuilder.IsConfigured)
        //     {
        //         var builder = new ConfigurationBuilder()
        //             .SetBasePath(Environment.CurrentDirectory)
        //             .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);
        //         var configuration = builder.Build();
        //         Debug.Write(configuration.ToString());
        //         //string connectionString = configuration["ConnectionStrings:DefaultConnection"];
        //         //optionsBuilder.UseSqlServer(connectionString);
        //         //optionsBuilder.UseLoggerFactory(GetLoggerFactory());
        //     }
        // }

    }
}
