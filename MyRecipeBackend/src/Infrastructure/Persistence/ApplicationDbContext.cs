using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.Extensions.Hosting;
using MyRecipe.Application.Common.Interfaces;
using MyRecipe.Domain.Entities;

namespace MyRecipe.Infrastructure.Persistence
{
    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>, IApplicationDbContext
    {
        public DbSet<Meal> Meals { get; set; }
        public DbSet<MealVote> MealVotes { get; set; }
        public DbSet<Group> Groups { get; set; }
        public DbSet<InviteCode> InviteCodes { get; set; }
        public DbSet<Recipe> Recipes { get; set; }
        public DbSet<Ingredient> Ingredients { get; set; }

        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) 
            : base(options)
        {
        }
        
        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            builder.Entity<Ingredient>()
                .HasIndex(i => i.Name)
                .IsUnique();

            var hostEnvironment = this.GetService<IHostEnvironment>();
            if (hostEnvironment.IsDevelopment() || hostEnvironment.IsStaging())
            {
                SeedDatabase(builder);
            }
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
                    Recipes = new List<Recipe>(),
                    EmailConfirmed = true,
                    IsAdmin = true,
                    GroupId=seedGroupId
                },
                new ApplicationUser()
                {
                    Id = "testUser2",
                    Email = "test2@test.test",
                    SecurityStamp = String.Empty,
                    Recipes = new List<Recipe>(),
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

            var recipes = new[]
            {
                new Recipe
                {
                    Id = new Guid("00000000-0000-0000-0000-000000000001"),
                    CookingTimeInMin = 20,
                    Name = "Pot of Rice",
                    Description = "Just rice",
                    UserId = users[0].Id,
                    AddToGroupPool = true,
                },
                new Recipe
                {
                    Id = new Guid("00000000-0000-0000-0000-000000000002"),
                    CookingTimeInMin = 30,
                    Name = "A tasty steak",
                    Description = "Steak",
                    UserId = users[0].Id,
                    AddToGroupPool = true,
                },
                new Recipe
                {
                    Id = new Guid("00000000-0000-0000-0000-000000000003"),
                    CookingTimeInMin = 10,
                    Name = "Ham and Eggs",
                    Description = "Fast",
                    UserId = users[1].Id,
                    AddToGroupPool = true,
                },
                new Recipe
                {
                    Id = new Guid("00000000-0000-0000-0000-000000000004"),
                    CookingTimeInMin = 3,
                    Name = "Yogurt",
                    Description = "Healthy",
                    UserId = users[1].Id,
                    AddToGroupPool = true,
                }
            };
            builder.Entity<Recipe>().HasData(recipes);

            var joinIngredientUserRecipe = new[]
            {
                new//rice for pot of rice
                {
                    IngredientsId = ingredients[2].Id,
                    RecipesId = recipes[0].Id
                },
                new//steak for steak
                {
                    IngredientsId = ingredients[5].Id,
                    RecipesId = recipes[1].Id
                },
                new //Potato for steak
                {
                    IngredientsId = ingredients[1].Id,
                    RecipesId = recipes[1].Id
                },
                new //ham&eggs
                {
                    IngredientsId = ingredients[6].Id,
                    RecipesId = recipes[2].Id
                },
                new
                {
                    IngredientsId = ingredients[7].Id,
                    RecipesId = recipes[2].Id
                },
                new //yogurt
                {
                    IngredientsId = ingredients[3].Id,
                    RecipesId = recipes[3].Id
                },
                new
                {
                    IngredientsId = ingredients[9].Id,
                    RecipesId = recipes[3].Id
                }
            };
            builder.Entity("IngredientRecipe").HasData(joinIngredientUserRecipe);
            
            var meals = new[] {
                new Meal
                {
                    InitiatorId = users[0].Id,
                    RecipeId = recipes[0].Id,
                    DateTime = DateTime.Now,
                    GroupId = groups[0].Id,
                    Accepted = true,
                    Id = new Guid("00000000-0000-0000-0000-000000000001"),
                },
                new Meal
                {
                    InitiatorId = users[0].Id,
                    RecipeId = recipes[1].Id,
                    DateTime = DateTime.Now.AddDays(2),
                    GroupId = groups[0].Id,
                    Accepted = false,
                    Id = new Guid("00000000-0000-0000-0000-000000000002"),
                }
            };
            builder.Entity<Meal>().HasData(meals);

            var mealVotes = new[]
            {
                new MealVote()
                {
                    Id = new Guid("00000000-0000-0000-0000-000000000001"),
                    MealId = meals[0].Id,
                    UserId = users[1].Id,
                    Vote = VoteEnum.Approved
                },
                new MealVote()
                {
                    Id = new Guid("00000000-0000-0000-0000-000000000002"),
                    MealId = meals[0].Id,
                    UserId = users[1].Id,
                    Vote = VoteEnum.Rejected
                }
            };
            builder.Entity<MealVote>().HasData(mealVotes);
        }
    }
}
