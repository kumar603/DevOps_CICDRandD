#!/bin/bash
# Build Script for DevOpsStack - Day 2 Pipeline Stages Implementation
# This script demonstrates the 5 core pipeline stages:
# 1. BUILD    - Restore dependencies and compile
# 2. TEST     - Run automated tests
# 3. PACKAGE  - Prepare deployable artifact (Docker image)
# 4. PUSH     - Push to registry (skipped for localhost)
# 5. DEPLOY   - Deploy application (optional, see docker-compose up)

echo "================================================================"
echo "                  DEVOPSSTACK PIPELINE"
echo "                   5 Pipeline Stages"
echo "================================================================"
echo ""
echo "Pipeline Flow: CODE COMMIT > BUILD > TEST > PACKAGE > DEPLOY"
echo ""
echo ""

set -e

# ================================================================
# STAGE 1: BUILD
# Purpose: Restore dependencies and compile code
# ================================================================
echo "================================================================"
echo "[STAGE 1/5] BUILD"
echo "================================================================"
echo "Purpose: Restore dependencies and compile code"
echo ""

echo "[1.1] Restoring dependencies (dotnet restore)..."
dotnet restore DevopsStack.sln
echo "✅ Dependencies restored"
echo ""

echo "[1.2] Building solution in Release mode (dotnet build)..."
dotnet build DevopsStack.sln -c Release --no-restore
echo "✅ Code compiled successfully"
echo ""
echo "✅ STAGE 1 (BUILD) - COMPLETED"
echo ""

# ================================================================
# STAGE 2: TEST
# Purpose: Run automated tests to validate code quality
# ================================================================
echo "================================================================"
echo "[STAGE 2/5] TEST"
echo "================================================================"
echo "Purpose: Run automated tests to validate code quality"
echo ""

echo "[2.1] Running Unit Tests (xUnit)..."
dotnet test src/DevopsStack.UnitTests/DevopsStack.UnitTests.csproj -c Release --no-build --verbosity normal
echo "✅ Unit tests passed"
echo ""

echo "[2.2] Running Integration Tests..."
dotnet test src/DevopsStack.IntegrationTests/DevopsStack.IntegrationTests.csproj -c Release --no-build --verbosity normal
echo "✅ Integration tests passed"
echo ""
echo "✅ STAGE 2 (TEST) - COMPLETED"
echo ""

# ================================================================
# STAGE 3: PACKAGE
# Purpose: Create deployable artifact (publish folder + Docker)
# ================================================================
echo "================================================================"
echo "[STAGE 3/5] PACKAGE"
echo "================================================================"
echo "Purpose: Create deployable artifact"
echo ""

echo "[3.1] Publishing application (dotnet publish)..."
dotnet publish src/DevopsStack.API/DevopsStack.API.csproj -c Release -o ./publish
echo "✅ Application published to ./publish"
echo ""

echo "[3.2] Creating Docker image (docker build)..."
if [ -f "Dockerfile" ]; then
    docker build -t devopsstack:latest .
    echo "✅ Docker image created: devopsstack:latest"
else
    echo "⚠️  Warning: Dockerfile not found, skipping Docker image creation"
    echo "Run: docker build -t devopsstack:latest . manually"
fi
echo ""
echo "✅ STAGE 3 (PACKAGE) - COMPLETED"
echo ""

# ================================================================
# STAGE 4: PUSH
# Purpose: Push artifact to registry (skipped for localhost)
# ================================================================
echo "================================================================"
echo "[STAGE 4/5] PUSH"
echo "================================================================"
echo "Purpose: Push Docker image to registry"
echo ""
echo "Note: Localhost deployment - PUSH stage skipped"
echo "In production, this stage would:"
echo "  - Push Docker image to Docker Hub"
echo "  - Push to Azure Container Registry"
echo "  - Push to AWS ECR"
echo "  - Update Kubernetes manifests"
echo ""
echo "✅ STAGE 4 (PUSH) - SKIPPED (localhost environment)"
echo ""

# ================================================================
# STAGE 5: DEPLOY
# Purpose: Deploy application to target environment
# ================================================================
echo "================================================================"
echo "[STAGE 5/5] DEPLOY"
echo "================================================================"
echo "Purpose: Deploy application to target environment"
echo ""
echo "Note: DEPLOY stage is manual - run one of the options below:"
echo ""
echo "Option A - Docker Compose (Recommended for learning):"
echo "  docker-compose up"
echo "  Access: http://localhost:8080"
echo ""
echo "Option B - Local Run:"
echo "  cd src/DevopsStack.API"
echo "  dotnet run"
echo "  Access: http://localhost:5000"
echo ""
echo "✅ STAGE 5 (DEPLOY) - READY (manual step)"
echo ""

echo "================================================================"
echo "✅ PIPELINE COMPLETED SUCCESSFULLY"
echo "================================================================"
echo ""
echo "Summary:"
echo "  ✅ Stage 1 - BUILD:   Code compiled successfully"
echo "  ✅ Stage 2 - TEST:    All tests passed"
echo "  ✅ Stage 3 - PACKAGE: Artifacts ready"
echo "  ✅ Stage 4 - PUSH:    (Skipped for localhost)"
echo "  ✅ Stage 5 - DEPLOY:  Ready for deployment"
echo ""
echo "Next Step: Run one of the DEPLOY options above"
echo ""
echo "Artifacts location: ./publish"
echo "Docker image: devopsstack:latest"
echo ""
echo "================================================================"
