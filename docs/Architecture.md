# DevOpsStack - Project Architecture

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                       Developer Workflow                         │
│  git push → GitHub Repository → Webhook Trigger                 │
└──────────────────────┬──────────────────────────────────────────┘
                       │
        ┌──────────────┴──────────────┐
        ↓                             ↓
   ┌─────────────┐            ┌──────────────┐
   │ CI Pipeline │            │ CD Pipeline  │
   └──────┬──────┘            └──────┬───────┘
          │                          │
    ┌─────┴─────────────────┐  ┌────┴──────────────┐
    │                       │  │                   │
    ├─ Restore Dependencies │  ├─ Build Container │
    ├─ Build Code           │  ├─ Push Registry   │
    ├─ Unit Tests           │  └─ Deploy (IIS)    │
    ├─ Integration Tests    │
    ├─ Code Analysis        │
    └─ Publish Artifacts    │
```

## Project Layout

### `/src` - Source Code

```
src/
├── DevopsStack.API/
│   ├── Controllers/
│   │   └── CIPipelineController.cs    # REST endpoints
│   ├── Properties/
│   │   └── launchSettings.json        # Run profiles
│   ├── Program.cs                     # Startup configuration
│   ├── appsettings.json              # App settings
│   └── DevopsStack.API.csproj        # Project file
│
├── DevopsStack.UnitTests/
│   ├── CIPipelineControllerTests.cs  # Controller unit tests
│   └── DevopsStack.UnitTests.csproj  # Test project
│
└── DevopsStack.IntegrationTests/
    ├── CIPipelineIntegrationTests.cs # API endpoint tests
    └── DevopsStack.IntegrationTests.csproj
```

### `/ci-cd` - CI/CD Infrastructure

```
ci-cd/
├── build-scripts/
│   ├── build.bat                     # CI pipeline (Windows)
│   └── build.sh                      # CI pipeline (Linux/Mac)
└── README.md
```

**Purpose:** Scripts that automate the CI pipeline locally

**Steps Executed:**
1. `dotnet restore` - Download dependencies
2. `dotnet build -c Release` - Compile project
3. `dotnet test` (Unit) - Run unit tests
4. `dotnet test` (Integration) - Run integration tests
5. `dotnet publish -c Release` - Create deployment package

### `/.github/workflows` - GitHub Actions

```
.github/workflows/
├── ci-pipeline.yml                  # GitHub Actions CI
└── cd-pipeline.yml                  # GitHub Actions CD
```

**CI Pipeline Workflow:**
- Triggered on: push to `main` or `develop`
- Runs on: Ubuntu Linux (GitHub Actions runner)
- Steps: Restore → Build → Test → Publish
- Output: Artifact upload

**CD Pipeline Workflow:**
- Triggered on: successful CI build
- Runs on: Ubuntu Linux (GitHub Actions runner)
- Steps: Build Docker → Deploy to staging → Ready for production
- Manual approval step for production

### `/iis-hosting` - Local IIS Setup

```
iis-hosting/
├── web.config                       # IIS configuration
└── IIS-SETUP.md                    # Setup instructions
```

**Purpose:** Deploy application to local IIS for testing

**Configuration:**
- Application Pool: DevOpsStack (No Managed Code)
- Port: 80
- Physical Path: C:\iis-apps\devopsstack\

### `/docs` - Documentation

```
docs/
├── CI-CD-Concepts.md               # Theory & concepts
└── Architecture.md                 # This file
```

## Application Architecture

### ASP.NET Core 8 Structure

```
DevopsStack.API (WebAPI)
│
├── Program.cs
│   ├── WebApplicationBuilder configuration
│   ├── Service registration (DI)
│   ├── Middleware pipeline
│   └── app.Run() - Start server
│
├── Controllers/
│   └── CIPipelineController
│       ├── GET /api/cipeline/info       → Application status
│       └── POST /api/cipeline/build-status → Build information
│
├── Models/
│   └── BuildRequest (DTO)
│
└── Properties/
    └── launchSettings.json
        ├── http: localhost:5000
        ├── https: localhost:44300
        └── IIS: via IIS Express
```

### Dependency Chain

```
DevopsStack.API (WebAPI)
    ├─ Swashbuckle.AspNetCore  (Swagger/OpenAPI)
    └─ Microsoft.AspNetCore.* (ASP.NET Core 8 packages)

DevopsStack.UnitTests
    ├─ DevopsStack.API (project reference)
    ├─ xUnit (testing framework)
    └─ Test SDK

DevopsStack.IntegrationTests
    ├─ DevopsStack.API (project reference)
    ├─ xUnit
    ├─ WebApplicationFactory (ASP.NET Core testing)
    └─ Test SDK
```

## Deployment Scenarios

### Scenario 1: Local Development

```
Developer Machine
├─ git clone
├─ dotnet build
├─ dotnet test
├─ dotnet run
└─ Access via http://localhost:5000
```

### Scenario 2: Local CI Pipeline (Manual)

```
Developer Machine
├─ Run: .\ci-cd\build-scripts\build.bat
│   ├─ Restore
│   ├─ Build
│   ├─ Test
│   └─ Publish → .\publish
├─ IIS Deploy
├─ Access via http://devopsstack.local
└─ Monitor: logs\stdout
```

### Scenario 3: GitHub CI/CD

```
GitHub Platform
├─ Developer Pushes Code
├─ GitHub Actions Triggers CI Pipeline
│   ├─ Runner (Ubuntu)
│   ├─ Restore → Build → Test → Publish
│   └─ Artifact Storage
├─ CI Success → Triggers CD Pipeline
├─ CD Pipeline
│   ├─ Build Docker Image
│   ├─ Push to Registry (simulated)
│   └─ Deploy to Staging
└─ Manual Approval for Production
```

### Scenario 4: Docker Local

```
Development Machine
├─ docker build -t devopsstack:latest .
├─ docker-compose up
├─ Container runs on port 8080
└─ Access via http://localhost:8080
```

## File Flow

### Build Output

```
dotnet publish -o ./publish

./publish/
├── DevopsStack.API.dll           # Main assembly
├── DevopsStack.API.deps.json     # Dependency info
├── DevopsStack.API.runtimeconfig.json
├── appsettings*.json             # Configuration
└── ... (all dependencies)
```

### Docker Image Layers

```
Dockerfile stages:

1. base: mcr.microsoft.com/dotnet/aspnet:8.0
2. build: mcr.microsoft.com/dotnet/sdk:8.0
   └─ COPY projects
   └─ dotnet restore
   └─ Copy source
   └─ dotnet build
3. test: build stage
   └─ dotnet test (Unit)
   └─ dotnet test (Integration)
4. publish: build stage
   └─ dotnet publish
5. final: runtime base
   └─ COPY from publish stage
```

## Configuration Flow

### appsettings.json

```json
{
  "Logging": { ... }
  "AllowedHosts": "*"
  "ApplicationName": "DevOpsStack CI/CD Demo"
}
```

### IIS web.config

```xml
<aspNetCore
  processPath="dotnet"
  arguments=".\DevopsStack.API.dll"
  stdoutLogEnabled="true"
  stdoutLogFile=".\logs\stdout"
  hostingModel="inprocess">
</aspNetCore>
```

## Testing Strategy

### Unit Tests
- **Location:** `DevopsStack.UnitTests/`
- **Framework:** xUnit
- **Scope:** Individual method/component testing
- **Speed:** Fast (< 1 second)

### Integration Tests
- **Location:** `DevopsStack.IntegrationTests/`
- **Framework:** xUnit + WebApplicationFactory
- **Scope:** Full API request/response testing
- **Speed:** Slower (5-10 seconds)

### Test Scenarios Covered

```
CIPipelineController Tests:
├─ GetInfo()
│  └─ Returns OkResult with application info
├─ BuildStatus() - Valid Input
│  └─ Returns success with build stages
├─ BuildStatus() - Invalid Input
│  └─ Returns BadRequest
└─ CI Pipeline Stages
   └─ Verify all stages present

API Integration Tests:
├─ GET /api/cipeline/info
│  └─ HTTP 200 with JSON response
└─ POST /api/cipeline/build-status
   └─ HTTP 200 with status object
```

## Security Considerations (Local Only)

⚠️ **Note:** This is a learning project on localhost

- No authentication/authorization implemented
- HTTPS configured for development only
- No data encryption
- Logging to stdout (for learning purposes)

For production:
- Add JWT/OAuth authentication
- Implement authorization policies
- Enable HTTPS only
- Implement audit logging
- Add API rate limiting

## Monitoring & Logging

### Local Logging

```
IIS stdout:
C:\iis-apps\devopsstack\logs\stdout*.log

Application Logs:
- Console output in development
- File output in IIS
```

### Health Check Endpoint

```
GET /api/cipeline/info

Response: {
  application, version, status, framework, timestamp
}
```

Used by Docker health check:
```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8080/api/cipeline/info"]
```

## Performance Characteristics

### Build Time (Approximate)

| Step | Time |
|------|------|
| Restore | 10-20s |
| Build | 5-10s |
| Unit Tests | 2-3s |
| Integration Tests | 5-10s |
| Publish | 3-5s |
| **Total** | **25-48s** |

### Runtime Characteristics

| Metric | Value |
|--------|-------|
| Startup Time | 2-3s |
| Memory (Running) | 50-100 MB |
| API Response Time | <100ms |
| Container Size | ~200 MB |

## Future Enhancements

```
Phase 2 (Database):
├─ Add Entity Framework Core
├─ SQLite for development
├─ Migration scripts
└─ Data seeding

Phase 3 (Features):
├─ Authentication (JWT)
├─ Authorization (Roles)
├─ Logging framework (Serilog)
├─ Health checks
└─ Metrics endpoints

Phase 4 (Operations):
├─ Kubernetes deployment
├─ Helm charts
├─ ArgoCD for GitOps
├─ Prometheus monitoring
└─ ELK stack logging
```
