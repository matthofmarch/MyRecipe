using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.FileProviders;

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using Core.Entities;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System.Runtime.CompilerServices;
using Microsoft.AspNetCore.Identity;

namespace DAL
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
            var hasher = new PasswordHasher<ApplicationUser>();

            var seedGroupId = new Guid("00000000-0000-0000-0000-000000000001");

            var users = new []
            {
                new ApplicationUser()
                {
                    Id = "testUser1",
                    Email = "test1@test.test",
                    SecurityStamp = String.Empty,
                    Recipes = new List<UserRecipe>(),
                    EmailConfirmed = true,
                    GroupId=seedGroupId
                },
                new ApplicationUser()
                {
                    Id = "testUser2",
                    Email = "test2@test.test",
                    SecurityStamp = String.Empty,
                    Recipes = new List<UserRecipe>(),
                    EmailConfirmed = true,
                    GroupId = seedGroupId
                }
            }.Select(u => { 
                u.PasswordHash = hasher.HashPassword(u, "Pass123$");
                u.UserName = u.NormalizedUserName = u.NormalizedEmail = u.Email;
                return u;
            }).ToArray();

            builder.Entity<ApplicationUser>().HasData(users);

            var groups = new[]
            {
                new Group()
                {
                    Id = seedGroupId,
                    Name = "TestGroup",
                }
            };
            builder.Entity<Group>().HasData(groups);

            var ingredients = new List<Ingredient>
            {
                new Ingredient {Id = new Guid("00000000-0000-0000-0000-000000000001"), Name = "Green salad"},
                new Ingredient {Id = new Guid("00000000-0000-0000-0000-000000000002"), Name = "Potato"},
                new Ingredient {Id = new Guid("00000000-0000-0000-0000-000000000003"), Name = "Brown Rice"},
                new Ingredient {Id = new Guid("00000000-0000-0000-0000-000000000004"), Name = "Oats"},
                new Ingredient {Id = new Guid("00000000-0000-0000-0000-000000000005"), Name = "Tomato"},
                new Ingredient {Id = new Guid("00000000-0000-0000-0000-000000000006"), Name = "Steak"},
                new Ingredient {Id = new Guid("00000000-0000-0000-0000-000000000007"), Name = "Ham"},
                new Ingredient {Id = new Guid("00000000-0000-0000-0000-000000000008"), Name = "Whole chicken egg"},
                new Ingredient {Id = new Guid("00000000-0000-0000-0000-000000000009"), Name = "White rice"},
                new Ingredient {Id = new Guid("00000000-0000-0000-0000-000000000010"), Name = "Greek yogurt"},
            };
            builder.Entity<Ingredient>().HasData(ingredients);

            var userRecipes = new[]
            {
                new UserRecipe
                {
                    Id = new Guid("00000000-0000-0000-0000-000000000001"),
                    CookingTimeInMin = 20,
                    Name = "Pot of Rice",
                    Description = "Just rice",
                    UserId = users[0].Id,
                    AddToGroupPool = true,
                },
                new UserRecipe
                {
                    Id = new Guid("00000000-0000-0000-0000-000000000002"),
                    CookingTimeInMin = 30,
                    Name = "A tasty steak",
                    Description = "Steak",
                    UserId = users[0].Id,
                    AddToGroupPool = true,
                },
                new UserRecipe
                {
                    Id = new Guid("00000000-0000-0000-0000-000000000003"),
                    CookingTimeInMin = 10,
                    Name = "Ham and Eggs",
                    Description = "Fast",
                    UserId = users[1].Id,
                    AddToGroupPool = true,
                },
                new UserRecipe
                {
                    Id = new Guid("00000000-0000-0000-0000-000000000004"),
                    CookingTimeInMin = 3,
                    Name = "Yogurt",
                    Description = "Healthy",
                    UserId = users[1].Id,
                    AddToGroupPool = true,
                }
            };
            builder.Entity<UserRecipe>().HasData(userRecipes);

            var recipeIngredientRelation = new[]
            {
                new RecipeIngredientRelation//rice for pot of rice
                {
                    IngredientId = ingredients[2].Id,
                    RecipeId = userRecipes[0].Id
                },
                new RecipeIngredientRelation//steak for steak
                {
                    IngredientId = ingredients[5].Id,
                    RecipeId = userRecipes[1].Id
                },
                new RecipeIngredientRelation //Potato for steak
                {
                    IngredientId = ingredients[1].Id,
                    RecipeId = userRecipes[1].Id
                },
                new RecipeIngredientRelation //ham&eggs
                {
                    IngredientId = ingredients[6].Id,
                    RecipeId = userRecipes[2].Id
                },
                new RecipeIngredientRelation
                {
                    IngredientId = ingredients[7].Id,
                    RecipeId = userRecipes[2].Id
                },
                new RecipeIngredientRelation //yogurt
                {
                    IngredientId = ingredients[3].Id,
                    RecipeId = userRecipes[3].Id
                },
                new RecipeIngredientRelation
                {
                    IngredientId = ingredients[9].Id,
                    RecipeId = userRecipes[3].Id
                }
            };
            builder.Entity<RecipeIngredientRelation>().HasData(recipeIngredientRelation);
        }
    }
}
