dotnet ef migrations add testmigration -p MyRecipe.Infrastructure.Persistence.Migrations.MySql -s Web --verbose -- --
provider MySql

dotnet ef migrations add testmigration -p MyRecipe.Infrastructure.Persistence.Migrations.SqlServer -s Web --verbose -- --
provider SqlServer