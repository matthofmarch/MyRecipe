using Microsoft.EntityFrameworkCore.Migrations;

namespace MyRecipeBackend.Migrations
{
    public partial class AddedSets : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUsers_Group_GroupId",
                table: "AspNetUsers");

            migrationBuilder.DropForeignKey(
                name: "FK_InviteCode_Group_GroupId",
                table: "InviteCode");

            migrationBuilder.DropPrimaryKey(
                name: "PK_InviteCode",
                table: "InviteCode");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Group",
                table: "Group");

            migrationBuilder.RenameTable(
                name: "InviteCode",
                newName: "InviteCodes");

            migrationBuilder.RenameTable(
                name: "Group",
                newName: "Groups");

            migrationBuilder.RenameIndex(
                name: "IX_InviteCode_GroupId",
                table: "InviteCodes",
                newName: "IX_InviteCodes_GroupId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_InviteCodes",
                table: "InviteCodes",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Groups",
                table: "Groups",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUsers_Groups_GroupId",
                table: "AspNetUsers",
                column: "GroupId",
                principalTable: "Groups",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_InviteCodes_Groups_GroupId",
                table: "InviteCodes",
                column: "GroupId",
                principalTable: "Groups",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUsers_Groups_GroupId",
                table: "AspNetUsers");

            migrationBuilder.DropForeignKey(
                name: "FK_InviteCodes_Groups_GroupId",
                table: "InviteCodes");

            migrationBuilder.DropPrimaryKey(
                name: "PK_InviteCodes",
                table: "InviteCodes");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Groups",
                table: "Groups");

            migrationBuilder.RenameTable(
                name: "InviteCodes",
                newName: "InviteCode");

            migrationBuilder.RenameTable(
                name: "Groups",
                newName: "Group");

            migrationBuilder.RenameIndex(
                name: "IX_InviteCodes_GroupId",
                table: "InviteCode",
                newName: "IX_InviteCode_GroupId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_InviteCode",
                table: "InviteCode",
                column: "Id");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Group",
                table: "Group",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUsers_Group_GroupId",
                table: "AspNetUsers",
                column: "GroupId",
                principalTable: "Group",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_InviteCode_Group_GroupId",
                table: "InviteCode",
                column: "GroupId",
                principalTable: "Group",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
