FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files
COPY ["DevopsStack.sln", "."]
COPY ["src/DevopsStack.API/DevopsStack.API.csproj", "src/DevopsStack.API/"]
COPY ["src/DevopsStack.UnitTests/DevopsStack.UnitTests.csproj", "src/DevopsStack.UnitTests/"]
COPY ["src/DevopsStack.IntegrationTests/DevopsStack.IntegrationTests.csproj", "src/DevopsStack.IntegrationTests/"]

# Restore dependencies
RUN dotnet restore "DevopsStack.sln"

# Copy source code
COPY . .

# Build projects
WORKDIR "/src"
RUN dotnet build "DevopsStack.sln" -c Release -o /app/build

# Run tests
FROM build AS test
# RUN dotnet test "src/DevopsStack.UnitTests/DevopsStack.UnitTests.csproj" -c Release --no-build --logger "console;verbosity=minimal"
# RUN dotnet test "src/DevopsStack.IntegrationTests/DevopsStack.IntegrationTests.csproj" -c Release --no-build --logger "console;verbosity=minimal"

# Publish application
FROM test AS publish
RUN dotnet publish "src/DevopsStack.API/DevopsStack.API.csproj" -c Release -o /app/publish

# Final runtime image
FROM runtime AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "DevopsStack.API.dll"]
