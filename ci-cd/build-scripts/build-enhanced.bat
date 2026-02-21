@echo off
REM Build Script for DevOpsStack - Day 2 Pipeline Stages Implementation
REM This script demonstrates the 5 core pipeline stages:
REM 1. BUILD    - Restore dependencies and compile
REM 2. TEST     - Run automated tests
REM 3. PACKAGE  - Prepare deployable artifact (Docker image)
REM 4. PUSH     - Push to registry (skipped for localhost)
REM 5. DEPLOY   - Deploy application (optional, see docker-compose up)

echo ================================================================
echo                  DEVOPSSTACK PIPELINE
echo                   5 Pipeline Stages
echo ================================================================
echo.
echo Pipeline Flow: CODE COMMIT ^> BUILD ^> TEST ^> PACKAGE ^> DEPLOY
echo.
echo.

setlocal enabledelayedexpansion
set TIMESTAMP=%date% %time%

REM ================================================================
REM STAGE 1: BUILD
REM Purpose: Restore dependencies and compile code
REM ================================================================
echo.
echo ================================================================
echo [STAGE 1/5] BUILD
echo ================================================================
echo Purpose: Restore dependencies and compile code
echo.

echo [1.1] Restoring dependencies (dotnet restore)...
dotnet restore DevopsStack.sln
if !errorlevel! neq 0 (
    echo.
    echo ❌ BUILD FAILED: Restore failed
    echo Pipeline STOPPED
    exit /b 1
)
echo ✅ Dependencies restored
echo.

echo [1.2] Building solution in Release mode (dotnet build)...
dotnet build DevopsStack.sln -c Release --no-restore
if !errorlevel! neq 0 (
    echo.
    echo ❌ BUILD FAILED: Compilation error
    echo Pipeline STOPPED
    exit /b 1
)
echo ✅ Code compiled successfully
echo.
echo ✅ STAGE 1 (BUILD) - COMPLETED
echo.

REM ================================================================
REM STAGE 2: TEST
REM Purpose: Run automated tests to validate code quality
REM ================================================================
echo ================================================================
echo [STAGE 2/5] TEST
echo ================================================================
echo Purpose: Run automated tests to validate code quality
echo.

echo [2.1] Running Unit Tests (xUnit)...
dotnet test src\DevopsStack.UnitTests\DevopsStack.UnitTests.csproj -c Release --no-build --verbosity normal
if !errorlevel! neq 0 (
    echo.
    echo ❌ TEST FAILED: Unit tests failed
    echo Pipeline STOPPED - Docker image will NOT be created
    exit /b 1
)
echo ✅ Unit tests passed
echo.

echo [2.2] Running Integration Tests...
dotnet test src\DevopsStack.IntegrationTests\DevopsStack.IntegrationTests.csproj -c Release --no-build --verbosity normal
if !errorlevel! neq 0 (
    echo.
    echo ❌ TEST FAILED: Integration tests failed
    echo Pipeline STOPPED - Docker image will NOT be created
    exit /b 1
)
echo ✅ Integration tests passed
echo.
echo ✅ STAGE 2 (TEST) - COMPLETED
echo.

REM ================================================================
REM STAGE 3: PACKAGE
REM Purpose: Create deployable artifact (publish folder + Docker)
REM ================================================================
echo ================================================================
echo [STAGE 3/5] PACKAGE
echo ================================================================
echo Purpose: Create deployable artifact
echo.

echo [3.1] Publishing application (dotnet publish)...
dotnet publish src\DevopsStack.API\DevopsStack.API.csproj -c Release -o .\publish
if !errorlevel! neq 0 (
    echo.
    echo ❌ PACKAGE FAILED: Publish failed
    echo Pipeline STOPPED
    exit /b 1
)
echo ✅ Application published to .\publish
echo.

echo [3.2] Creating Docker image (docker build)...
if not exist "Dockerfile" (
    echo ⚠️  Warning: Dockerfile not found, skipping Docker image creation
    echo Run: docker build -t devopsstack:latest . manually
) else (
    docker build -t devopsstack:latest .
    if !errorlevel! neq 0 (
        echo.
        echo ❌ PACKAGE FAILED: Docker image creation failed
        echo Pipeline STOPPED
        exit /b 1
    )
    echo ✅ Docker image created: devopsstack:latest
)
echo.
echo ✅ STAGE 3 (PACKAGE) - COMPLETED
echo.

REM ================================================================
REM STAGE 4: PUSH
REM Purpose: Push artifact to registry (skipped for localhost)
REM ================================================================
echo ================================================================
echo [STAGE 4/5] PUSH
echo ================================================================
echo Purpose: Push Docker image to registry
echo.
echo Note: Localhost deployment - PUSH stage skipped
echo In production, this stage would:
echo   - Push Docker image to Docker Hub
echo   - Push to Azure Container Registry
echo   - Push to AWS ECR
echo   - Update Kubernetes manifests
echo.
echo ✅ STAGE 4 (PUSH) - SKIPPED (localhost environment)
echo.

REM ================================================================
REM STAGE 5: DEPLOY
REM Purpose: Deploy application to target environment
REM ================================================================
echo ================================================================
echo [STAGE 5/5] DEPLOY
echo ================================================================
echo Purpose: Deploy application to target environment
echo.
echo Note: DEPLOY stage is manual - run one of the options below:
echo.
echo Option A - Docker Compose (Recommended for learning):
echo   cd %cd%
echo   docker-compose up
echo   Access: http://localhost:8080
echo.
echo Option B - IIS Hosting (Windows):
echo   See iis-hosting\IIS-SETUP.md
echo   Access: http://devopsstack.local
echo.
echo Option C - Local Run:
echo   cd src\DevopsStack.API
echo   dotnet run
echo   Access: http://localhost:5000
echo.
echo ✅ STAGE 5 (DEPLOY) - READY (manual step)
echo.

echo ================================================================
echo ✅ PIPELINE COMPLETED SUCCESSFULLY
echo ================================================================
echo.
echo Summary:
echo   ✅ Stage 1 - BUILD:   Code compiled successfully
echo   ✅ Stage 2 - TEST:    All tests passed
echo   ✅ Stage 3 - PACKAGE: Artifacts ready
echo   ✅ Stage 4 - PUSH:    (Skipped for localhost)
echo   ✅ Stage 5 - DEPLOY:  Ready for deployment
echo.
echo Next Step: Run one of the DEPLOY options above
echo.
echo Artifacts location: .\publish
echo Docker image: devopsstack:latest
echo.
echo ================================================================
