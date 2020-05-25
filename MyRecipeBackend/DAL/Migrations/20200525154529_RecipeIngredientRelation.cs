using Microsoft.EntityFrameworkCore.Migrations;

namespace DAL.Migrations
{
    public partial class RecipeIngredientRelation : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_IngredientTagRelation_NutritionTags_TagId",
                table: "IngredientTagRelation");

            migrationBuilder.DropForeignKey(
                name: "FK_RecipeIngredientRelation_Ingredients_IngredientId",
                table: "RecipeIngredientRelation");

            migrationBuilder.DropForeignKey(
                name: "FK_RecipeIngredientRelation_BaseRecipes_RecipeId",
                table: "RecipeIngredientRelation");

            migrationBuilder.DropPrimaryKey(
                name: "PK_RecipeIngredientRelation",
                table: "RecipeIngredientRelation");

            migrationBuilder.DropPrimaryKey(
                name: "PK_NutritionTags",
                table: "NutritionTags");

            migrationBuilder.RenameTable(
                name: "RecipeIngredientRelation",
                newName: "RecipeIngredientRelations");

            migrationBuilder.RenameTable(
                name: "NutritionTags",
                newName: "Tag");

            migrationBuilder.RenameIndex(
                name: "IX_RecipeIngredientRelation_IngredientId",
                table: "RecipeIngredientRelations",
                newName: "IX_RecipeIngredientRelations_IngredientId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_RecipeIngredientRelations",
                table: "RecipeIngredientRelations",
                columns: new[] { "RecipeId", "IngredientId" });

            migrationBuilder.AddPrimaryKey(
                name: "PK_Tag",
                table: "Tag",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_IngredientTagRelation_Tag_TagId",
                table: "IngredientTagRelation",
                column: "TagId",
                principalTable: "Tag",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_RecipeIngredientRelations_Ingredients_IngredientId",
                table: "RecipeIngredientRelations",
                column: "IngredientId",
                principalTable: "Ingredients",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_RecipeIngredientRelations_BaseRecipes_RecipeId",
                table: "RecipeIngredientRelations",
                column: "RecipeId",
                principalTable: "BaseRecipes",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_IngredientTagRelation_Tag_TagId",
                table: "IngredientTagRelation");

            migrationBuilder.DropForeignKey(
                name: "FK_RecipeIngredientRelations_Ingredients_IngredientId",
                table: "RecipeIngredientRelations");

            migrationBuilder.DropForeignKey(
                name: "FK_RecipeIngredientRelations_BaseRecipes_RecipeId",
                table: "RecipeIngredientRelations");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Tag",
                table: "Tag");

            migrationBuilder.DropPrimaryKey(
                name: "PK_RecipeIngredientRelations",
                table: "RecipeIngredientRelations");

            migrationBuilder.RenameTable(
                name: "Tag",
                newName: "NutritionTags");

            migrationBuilder.RenameTable(
                name: "RecipeIngredientRelations",
                newName: "RecipeIngredientRelation");

            migrationBuilder.RenameIndex(
                name: "IX_RecipeIngredientRelations_IngredientId",
                table: "RecipeIngredientRelation",
                newName: "IX_RecipeIngredientRelation_IngredientId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_NutritionTags",
                table: "NutritionTags",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_RecipeIngredientRelation",
                table: "RecipeIngredientRelation",
                columns: new[] { "RecipeId", "IngredientId" });

            migrationBuilder.AddForeignKey(
                name: "FK_IngredientTagRelation_NutritionTags_TagId",
                table: "IngredientTagRelation",
                column: "TagId",
                principalTable: "NutritionTags",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_RecipeIngredientRelation_Ingredients_IngredientId",
                table: "RecipeIngredientRelation",
                column: "IngredientId",
                principalTable: "Ingredients",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_RecipeIngredientRelation_BaseRecipes_RecipeId",
                table: "RecipeIngredientRelation",
                column: "RecipeId",
                principalTable: "BaseRecipes",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
