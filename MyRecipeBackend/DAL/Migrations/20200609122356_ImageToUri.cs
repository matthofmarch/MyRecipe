using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace DAL.Migrations
{
    public partial class ImageToUri : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_BaseRecipes_RecipeImages_ImageId",
                table: "BaseRecipes");

            migrationBuilder.DropTable(
                name: "RecipeImages");

            migrationBuilder.DropIndex(
                name: "IX_BaseRecipes_ImageId",
                table: "BaseRecipes");

            migrationBuilder.DropColumn(
                name: "ImageId",
                table: "BaseRecipes");

            migrationBuilder.AddColumn<string>(
                name: "Image",
                table: "BaseRecipes",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Image",
                table: "BaseRecipes");

            migrationBuilder.AddColumn<Guid>(
                name: "ImageId",
                table: "BaseRecipes",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "RecipeImages",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Image = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RowVersion = table.Column<byte[]>(type: "rowversion", rowVersion: true, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RecipeImages", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_BaseRecipes_ImageId",
                table: "BaseRecipes",
                column: "ImageId");

            migrationBuilder.AddForeignKey(
                name: "FK_BaseRecipes_RecipeImages_ImageId",
                table: "BaseRecipes",
                column: "ImageId",
                principalTable: "RecipeImages",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
