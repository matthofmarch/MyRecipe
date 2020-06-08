using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace DAL.Migrations
{
    public partial class AddedUserIdToUserRecipe2 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_BaseRecipes_AspNetUsers_ApplicationUserId1",
                table: "BaseRecipes");

            migrationBuilder.DropIndex(
                name: "IX_BaseRecipes_ApplicationUserId1",
                table: "BaseRecipes");

            migrationBuilder.DropColumn(
                name: "ApplicationUserId",
                table: "BaseRecipes");

            migrationBuilder.DropColumn(
                name: "ApplicationUserId1",
                table: "BaseRecipes");

            migrationBuilder.AddColumn<string>(
                name: "UserId",
                table: "BaseRecipes",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_BaseRecipes_UserId",
                table: "BaseRecipes",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_BaseRecipes_AspNetUsers_UserId",
                table: "BaseRecipes",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_BaseRecipes_AspNetUsers_UserId",
                table: "BaseRecipes");

            migrationBuilder.DropIndex(
                name: "IX_BaseRecipes_UserId",
                table: "BaseRecipes");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "BaseRecipes");

            migrationBuilder.AddColumn<Guid>(
                name: "ApplicationUserId",
                table: "BaseRecipes",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ApplicationUserId1",
                table: "BaseRecipes",
                type: "nvarchar(450)",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_BaseRecipes_ApplicationUserId1",
                table: "BaseRecipes",
                column: "ApplicationUserId1");

            migrationBuilder.AddForeignKey(
                name: "FK_BaseRecipes_AspNetUsers_ApplicationUserId1",
                table: "BaseRecipes",
                column: "ApplicationUserId1",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
