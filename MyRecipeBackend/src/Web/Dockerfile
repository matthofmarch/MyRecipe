#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /src
COPY ["src/Web/Web.csproj", "src/Web/"]
COPY ["src/MyRecipe.Infrastructure.Persistence.Migrations.MySql/MyRecipe.Infrastructure.Persistence.Migrations.MySql.csproj", "src/MyRecipe.Infrastructure.Persistence.Migrations.MySql/"]
COPY ["src/Infrastructure/Infrastructure.csproj", "src/Infrastructure/"]
COPY ["src/Domain/Domain.csproj", "src/Domain/"]
COPY ["src/Application/Application.csproj", "src/Application/"]
COPY ["src/MyRecipe.Infrastructure.Persistence.Migrations.SqlServer/MyRecipe.Infrastructure.Persistence.Migrations.SqlServer.csproj", "src/MyRecipe.Infrastructure.Persistence.Migrations.SqlServer/"]
RUN dotnet restore "src/Web/Web.csproj"
COPY . .
WORKDIR "/src/src/Web"
RUN dotnet build "Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Web.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyRecipe.Web.dll"]