using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace DAL.Migrations
{
    public partial class AddedUserIdToUserRecipe : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_BaseRecipes_AspNetUsers_ApplicationUserId",
                table: "BaseRecipes");

            migrationBuilder.DropIndex(
                name: "IX_BaseRecipes_ApplicationUserId",
                table: "BaseRecipes");

            migrationBuilder.AlterColumn<Guid>(
                name: "ApplicationUserId",
                table: "BaseRecipes",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldNullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ApplicationUserId1",
                table: "BaseRecipes",
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

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_BaseRecipes_AspNetUsers_ApplicationUserId1",
                table: "BaseRecipes");

            migrationBuilder.DropIndex(
                name: "IX_BaseRecipes_ApplicationUserId1",
                table: "BaseRecipes");

            migrationBuilder.DropColumn(
                name: "ApplicationUserId1",
                table: "BaseRecipes");

            migrationBuilder.AlterColumn<string>(
                name: "ApplicationUserId",
                table: "BaseRecipes",
                type: "nvarchar(450)",
                nullable: true,
                oldClrType: typeof(Guid),
                oldNullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_BaseRecipes_ApplicationUserId",
                table: "BaseRecipes",
                column: "ApplicationUserId");

            migrationBuilder.AddForeignKey(
                name: "FK_BaseRecipes_AspNetUsers_ApplicationUserId",
                table: "BaseRecipes",
                column: "ApplicationUserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
