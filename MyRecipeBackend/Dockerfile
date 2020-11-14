#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:5.0 AS build
WORKDIR /src
COPY ["MyRecipeBackend/MyRecipeBackend.csproj", "MyRecipeBackend/"]
COPY ["DAL/DAL.csproj", "DAL/"]
COPY ["Core/Core.csproj", "Core/"]
RUN dotnet restore "MyRecipeBackend/MyRecipeBackend.csproj"
COPY . .
WORKDIR "/src/MyRecipeBackend"
RUN dotnet build "MyRecipeBackend.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MyRecipeBackend.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyRecipeBackend.dll"]