using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace DAL.Migrations
{
    public partial class AddedNutritionTagAndManyToManyOnBaseRecipeIngredientTag : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Ingredients",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    RowVersion = table.Column<byte[]>(rowVersion: true, nullable: true),
                    Name = table.Column<string>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Ingredients", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "NutritionTags",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    RowVersion = table.Column<byte[]>(rowVersion: true, nullable: true),
                    Descriptor = table.Column<string>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NutritionTags", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "RecipeImages",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    RowVersion = table.Column<byte[]>(rowVersion: true, nullable: true),
                    Image = table.Column<byte[]>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RecipeImages", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "IngredientTagRelation",
                columns: table => new
                {
                    IngredientId = table.Column<Guid>(nullable: false),
                    TagId = table.Column<Guid>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_IngredientTagRelation", x => new { x.IngredientId, x.TagId });
                    table.ForeignKey(
                        name: "FK_IngredientTagRelation_Ingredients_IngredientId",
                        column: x => x.IngredientId,
                        principalTable: "Ingredients",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_IngredientTagRelation_NutritionTags_TagId",
                        column: x => x.TagId,
                        principalTable: "NutritionTags",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "BaseRecipes",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    RowVersion = table.Column<byte[]>(rowVersion: true, nullable: true),
                    Name = table.Column<string>(maxLength: 30, nullable: false),
                    Description = table.Column<string>(nullable: true),
                    CookingTimeInMin = table.Column<int>(nullable: false),
                    ImageId = table.Column<Guid>(nullable: true),
                    Discriminator = table.Column<string>(nullable: false),
                    ApplicationUserId = table.Column<string>(nullable: true),
                    AddToGroupPool = table.Column<bool>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BaseRecipes", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BaseRecipes_RecipeImages_ImageId",
                        column: x => x.ImageId,
                        principalTable: "RecipeImages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_BaseRecipes_AspNetUsers_ApplicationUserId",
                        column: x => x.ApplicationUserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "RecipeIngredientRelation",
                columns: table => new
                {
                    RecipeId = table.Column<Guid>(nullable: false),
                    IngredientId = table.Column<Guid>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RecipeIngredientRelation", x => new { x.RecipeId, x.IngredientId });
                    table.ForeignKey(
                        name: "FK_RecipeIngredientRelation_Ingredients_IngredientId",
                        column: x => x.IngredientId,
                        principalTable: "Ingredients",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_RecipeIngredientRelation_BaseRecipes_RecipeId",
                        column: x => x.RecipeId,
                        principalTable: "BaseRecipes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_BaseRecipes_ImageId",
                table: "BaseRecipes",
                column: "ImageId");

            migrationBuilder.CreateIndex(
                name: "IX_BaseRecipes_ApplicationUserId",
                table: "BaseRecipes",
                column: "ApplicationUserId");

            migrationBuilder.CreateIndex(
                name: "IX_IngredientTagRelation_TagId",
                table: "IngredientTagRelation",
                column: "TagId");

            migrationBuilder.CreateIndex(
                name: "IX_RecipeIngredientRelation_IngredientId",
                table: "RecipeIngredientRelation",
                column: "IngredientId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "IngredientTagRelation");

            migrationBuilder.DropTable(
                name: "RecipeIngredientRelation");

            migrationBuilder.DropTable(
                name: "NutritionTags");

            migrationBuilder.DropTable(
                name: "Ingredients");

            migrationBuilder.DropTable(
                name: "BaseRecipes");

            migrationBuilder.DropTable(
                name: "RecipeImages");
        }
    }
}
