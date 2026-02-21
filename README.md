# DevOpsStack - CI/CD Learning Project

## Project Overview

This project is a learning implementation of **Day 1 - CI vs CD** concepts from the DevOps curriculum. It demonstrates:

- **Continuous Integration (CI)**: Automatic build, test, and validation
- **Continuous Delivery (CD)**: Automated preparation for deployment
- **.NET Core 8 WebAPI**: Sample application showing CI/CD principles
- **Local Hosting**: IIS deployment (no cloud)
- **Docker Support**: Containerization for deployment options

## Project Structure

```
DevopsStack/
├── src/
│   ├── DevopsStack.API/                    # Core WebAPI (ASP.NET Core 8)
│   ├── DevopsStack.UnitTests/              # Unit tests (xUnit)
│   └── DevopsStack.IntegrationTests/       # Integration tests
├── ci-cd/
│   ├── build-scripts/
│   │   ├── build.bat                       # CI pipeline (Windows)
│   │   └── build.sh                        # CI pipeline (Linux/Mac)
│   └── web.deploy/                         # Web Deploy files
├── .github/workflows/
│   ├── ci-pipeline.yml                     # GitHub Actions CI
│   └── cd-pipeline.yml                     # GitHub Actions CD
├── iis-hosting/
│   ├── web.config                          # IIS configuration
│   └── IIS-SETUP.md                        # IIS setup instructions
├── docs/
│   ├── CI-CD-Concepts.md                   # Theory documentation
│   └── Architecture.md                     # Project architecture
├── Dockerfile                              # Docker image definition
├── docker-compose.yml                      # Docker composition
└── DevopsStack.sln                         # Solution file
```

## Day 1 - CI vs CD Concepts

### CI (Continuous Integration)
**What it does:**
- Every code push triggers automated: `Restore → Build → Test → Validate`
- Early bug detection
- Broken builds caught immediately

**Key Steps:**
1. Developer pushes code
2. CI pipeline restores dependencies
3. Code is compiled
4. Automated tests run
5. Results reported

### CD (Continuous Delivery vs Deployment)

**Continuous Delivery:**
- Application is automatically prepared for deployment
- Manual approval may be required before production release

**Continuous Deployment:**
- Application is automatically deployed to production
- No human intervention needed

## Getting Started

### Prerequisites
- .NET 8 SDK installed
- Docker (optional, for containerized deployment)
- Git (for version control)
- IIS (for local hosting)

### Build & Test Locally

**Windows:**
```bash
cd c:\Development\DevOps\DevOpsStack_RandD
ci-cd\build-scripts\build.bat
```

**Linux/Mac:**
```bash
cd DevOpsStack
./ci-cd/build-scripts/build.sh
```

### Run Application

**From Published Output:**
```bash
dotnet ./publish/DevopsStack.API.dll
```

**From Source:**
```bash
cd src/DevopsStack.API
dotnet run
```

Application will be available at: `http://localhost:5000`

### Run Tests

**Unit Tests:**
```bash
dotnet test src/DevopsStack.UnitTests/
```

**Integration Tests:**
```bash
dotnet test src/DevopsStack.IntegrationTests/
```

### Docker Deployment

**Build image:**
```bash
docker build -t devopsstack:latest .
```

**Run container:**
```bash
docker-compose up
```

Application will be available at: `http://localhost:8080`

### IIS Hosting

See [IIS Setup Instructions](iis-hosting/IIS-SETUP.md)

## API Endpoints

### Get Application Information
```
GET /api/cipeline/info
```

Response:
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
```
POST /api/cipeline/build-status
Content-Type: application/json

{
  "projectName": "DevOpsStack"
}
```

Response:
```json
{
  "success": true,
  "project": "DevOpsStack",
  "stage": "CI Pipeline Complete",
  "steps": ["Restore", "Build", "Test", "Ready for Deployment"]
}
```

## CI/CD Pipeline Flow

```
Developer Push → GitHub
        ↓
[CI Pipeline Triggered]
    ├─ dotnet restore
    ├─ dotnet build
    ├─ dotnet test (Unit)
    ├─ dotnet test (Integration)
    └─ dotnet publish
        ↓
[CD Pipeline Triggered]
    ├─ Create Docker Image
    ├─ Deploy to Staging
    └─ Ready for Production
```

## Technologies Used

- **Framework**: ASP.NET Core 8
- **Testing**: xUnit
- **Containerization**: Docker
- **CI/CD**: GitHub Actions
- **Hosting**: IIS (Local)
- **Language**: C#

## Learning Outcomes

After working with this project, you will understand:

✅ CI vs CD differences
✅ How automated builds work
✅ Test automation in pipelines
✅ Docker containerization
✅ Local IIS deployment
✅ GitHub Actions workflows
✅ ASP.NET Core development

## Troubleshooting

### Build fails with "dotnet not found"
Ensure .NET 8 SDK is installed: `dotnet --version`

### Tests fail
Check that all project references are correct in `.csproj` files

### IIS deployment issues
See [IIS-SETUP.md](iis-hosting/IIS-SETUP.md)

## Next Steps

- Add authentication layer
- Implement logging framework
- Add database layer
- Create admin dashboard
- Deploy to staging environment
- Monitor application health

## Resources

- [ASP.NET Core Documentation](https://docs.microsoft.com/aspnet/core)
- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Docker Documentation](https://docs.docker.com)
- [IIS Configuration](https://docs.microsoft.com/iis)
