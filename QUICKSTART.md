# DevOpsStack - Quick Start Guide

## 📋 Initial Setup

### 1. Prerequisites Check
```bash
# Verify .NET 8 is installed
dotnet --version
# Should show: 8.0.x or higher

# Verify Git is installed
git --version
```

### 2. Navigate to Project
```bash
cd c:\Development\DevOps\DevOpsStack_RandD
```

## 🔨 Building & Testing

### Option A: Run CI Pipeline (Fastest)

**Windows:**
```bash
.\ci-cd\build-scripts\build.bat
```

**Linux/Mac:**
```bash
./ci-cd/build-scripts/build.sh
```

**What it does:**
1. Restores dependencies (dotnet restore)
2. Builds solution (dotnet build -c Release)
3. Runs unit tests
4. Runs integration tests
5. Publishes to output folder

**Expected Output:**
```
[PASS] Restore completed
[PASS] Build completed
[PASS] Unit tests completed
[PASS] Integration tests completed
[PASS] Publish completed

CI Pipeline Completed Successfully!
Published app is in: .\publish
```

### Option B: Step-by-Step Build

```bash
# 1. Restore
dotnet restore DevopsStack.sln

# 2. Build
dotnet build DevopsStack.sln -c Release

# 3. Run Unit Tests
dotnet test src/DevopsStack.UnitTests/DevopsStack.UnitTests.csproj

# 4. Run Integration Tests
dotnet test src/DevopsStack.IntegrationTests/DevopsStack.IntegrationTests.csproj

# 5. Publish
dotnet publish src/DevopsStack.API/DevopsStack.API.csproj -c Release -o ./publish
```

## 🚀 Running the Application

### Option 1: Direct Run (Development)

```bash
cd src/DevopsStack.API
dotnet run

# Open browser: http://localhost:5000
# Swagger UI: http://localhost:5000/swagger
```

### Option 2: From Published Output

```bash
dotnet ./publish/DevopsStack.API.dll

# Open browser: http://localhost:5000
```

### Option 3: Docker (If Docker Installed)

```bash
# Build image
docker build -t devopsstack:latest .

# Run container
docker-compose up

# Open browser: http://localhost:8080
```

## 📊 Testing Endpoints

Once application is running:

### Get Application Info
```bash
curl http://localhost:5000/api/cipeline/info
```

**Expected Response:**
```json
{
  "application": "DevOpsStack CI/CD Demo",
  "version": "1.0.0",
  "status": "Running",
  "framework": "ASP.NET Core 8",
  "timestamp": "2026-02-19T10:30:00Z"
}
```

### Check Build Status
```bash
curl -X POST http://localhost:5000/api/cipeline/build-status \
  -H "Content-Type: application/json" \
  -d '{"projectName":"DevOpsStack"}'
```

**Expected Response:**
```json
{
  "success": true,
  "project": "DevOpsStack",
  "stage": "CI Pipeline Complete",
  "steps": ["Restore", "Build", "Test", "Ready for Deployment"]
}
```

## 🐳 Docker Usage

### Build and Run

```bash
# Build local image
docker build -t devopsstack:latest .

# View image
docker images | grep devopsstack

# Run with compose
docker-compose up

# Run single container
docker run -d -p 8080:8080 devopsstack:latest

# Check logs
docker logs <container_id>

# Stop container
docker stop <container_id>
```

### Docker Compose

```bash
# Start all services
docker-compose up

# Start in background
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild images
docker-compose up --build
```

## 🏠 Local IIS Deployment

See [IIS-SETUP.md](iis-hosting/IIS-SETUP.md) for complete instructions

**Quick Steps:**
1. Publish: `dotnet publish src/DevopsStack.API/DevopsStack.API.csproj -c Release -o C:\inetpub\wwwroot\DevOpsStack_RandD`
2. Copy `iis-hosting\web.config` to published folder
3. Create IIS App Pool: DevOpsStack_RandD
4. Create IIS Site pointing to published folder (Port 8082)
5. Verify: http://localhost:8082/api/cipeline/info

## 📁 Project Structure

```
DevopsStack/
├── src/                              # Source code
│   ├── DevopsStack.API/             # WebAPI application
│   ├── DevopsStack.UnitTests/       # Unit tests
│   └── DevopsStack.IntegrationTests/# Integration tests
├── ci-cd/build-scripts/             # Build automation
│   ├── build.bat                    # Windows build script
│   └── build.sh                     # Linux/Mac build script
├── .github/workflows/               # GitHub Actions
│   ├── ci-pipeline.yml              # CI workflow
│   └── cd-pipeline.yml              # CD workflow
├── iis-hosting/                     # IIS configuration
│   ├── web.config                   # IIS config
│   └── IIS-SETUP.md                # Setup guide
├── docs/                            # Documentation
│   ├── CI-CD-Concepts.md           # Theory
│   └── Architecture.md              # Architecture
├── Dockerfile                       # Docker image definition
├── docker-compose.yml               # Docker compose config
├── DevopsStack.sln                 # Solution file
└── README.md                        # Project overview
```

## 🔍 Common Tasks

### Run Specific Tests

```bash
# Unit tests only
dotnet test src/DevopsStack.UnitTests/ -v minimal

# Integration tests only
dotnet test src/DevopsStack.IntegrationTests/ -v minimal

# Single test method
dotnet test --filter "Name~GetInfo"
```

### View Test Coverage

Tests are configured for code coverage. Check test output for coverage info.

### Clean Build

```bash
# Remove build artifacts
dotnet clean

# Rebuild from scratch
dotnet build -c Release
```

### Update Dependencies

```bash
# Check for outdated packages
dotnet outdated

# Update all packages
dotnet list package --outdated
```

## 🐛 Troubleshooting

### "dotnet not found"
```bash
# Install .NET 8 SDK from https://dotnet.microsoft.com/download
# Verify installation
dotnet --version
```

### Tests Failing
```bash
# Clean and rebuild
dotnet clean
dotnet build

# Run with verbose output
dotnet test -v detailed
```

### IIS Deployment Issues
See [IIS-SETUP.md](iis-hosting/IIS-SETUP.md) troubleshooting section

### Docker Build Fails
```bash
# Check Docker is running
docker --version

# Clean Docker cache
docker system prune -a

# Rebuild image
docker build --no-cache -t devopsstack:latest .
```

## 📚 Learning Resources

- **CI/CD Theory:** [CI-CD-Concepts.md](docs/CI-CD-Concepts.md)
- **Architecture:** [Architecture.md](docs/Architecture.md)
- **API Endpoints:** [README.md](README.md)
- **IIS Hosting:** [iis-hosting/IIS-SETUP.md](iis-hosting/IIS-SETUP.md)

## ✅ Verification Checklist

- [x] Project loads in Visual Studio / VS Code
- [x] `dotnet build` completes successfully
- [x] `dotnet test` passes all tests
- [x] `dotnet run` starts application
- [x] Swagger UI opens at http://localhost:5000/swagger
- [x] API endpoints respond correctly
- [x] Docker image builds successfully
- [x] Docker container runs and responds

## 📞 Support

For issues specific to:
- **.NET Development:** Check [Microsoft Docs](https://docs.microsoft.com/dotnet)
- **GitHub Actions:** See `.github/workflows/` files with comments
- **Docker:** See [Docker Documentation](https://docs.docker.com)
- **IIS Hosting:** See [iis-hosting/IIS-SETUP.md](iis-hosting/IIS-SETUP.md)

## 🎯 Next Steps

1. ✅ Build and run the application
2. ✅ Test all endpoints
3. ✅ Review CI/CD concepts in docs
4. ✅ Try Docker deployment
5. ✅ Set up local IIS hosting
6. ✅ Understand GitHub Actions workflows
7. 🔜 Extend with your own features
