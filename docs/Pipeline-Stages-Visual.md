# Pipeline Stages - Visual Reference

## 5 Core Pipeline Stages (DevopsStack Implementation)

### Complete Pipeline Flow

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│ Developer Code Push to GitHub                                                    │
└──────────────────────────────┬──────────────────────────────────────────────────┘
                               │
                    ┌──────────▼───────────┐
                    │  STAGE 1: BUILD      │
                    │  (Compile Code)      │
                    └──────────┬───────────┘
                               │
                    ┌──────────▼───────────┐
                    │  STAGE 2: TEST       │
                    │  (Run Tests)         │
                    └──────────┬───────────┘
                               │
                    ┌──────────▼───────────┐
                    │  STAGE 3: PACKAGE    │
                    │  (Create Docker Img) │
                    └──────────┬───────────┘
                               │
                    ┌──────────▼───────────┐
                    │  STAGE 4: PUSH       │
                    │  (Push Registry)     │
                    └──────────┬───────────┘
                               │
                    ┌──────────▼───────────┐
                    │  STAGE 5: DEPLOY     │
                    │  (Run Application)   │
                    └──────────────────────┘
                               │
                    Application Running ✅
```

---

## Stage 1: BUILD - Compile Code

### What Happens
```
┌─────────────────────────────────────────┐
│ STAGE 1: BUILD                          │
├─────────────────────────────────────────┤
│ Purpose: Restore dependencies & compile │
├─────────────────────────────────────────┤
│ Steps:                                  │
│  [1.1] dotnet restore                  │
│  [1.2] dotnet build -c Release         │
├─────────────────────────────────────────┤
│ Output:                                 │
│  ✅ Compiled DLL files in obj/bin/     │
│  ✅ No syntax errors                   │
│  ✅ Dependencies available             │
├─────────────────────────────────────────┤
│ If Fails:                               │
│  ❌ Pipeline STOPS                      │
│  ❌ Error message displayed             │
│  ❌ No tests run                        │
│  ❌ No Docker image created            │
└─────────────────────────────────────────┘
```

### Real Example
```bash
$ dotnet restore
  Restore completed

$ dotnet build -c Release
  Build succeeded
  ✅ STAGE 1 COMPLETE
```

---

## Stage 2: TEST - Run Automated Tests

### What Happens
```
┌─────────────────────────────────────────┐
│ STAGE 2: TEST                           │
├─────────────────────────────────────────┤
│ Purpose: Validate code quality         │
├─────────────────────────────────────────┤
│ Steps:                                  │
│  [2.1] Run Unit Tests (5 tests)        │
│  [2.2] Run Integration Tests (2 tests) │
├─────────────────────────────────────────┤
│ Output:                                 │
│  ✅ All tests passing                  │
│  ✅ Test coverage report               │
│  ✅ Code meets quality standards       │
├─────────────────────────────────────────┤
│ If Fails:                               │
│  ❌ Pipeline STOPS                      │
│  ❌ Docker image NOT created           │
│  ❌ Deployment does NOT happen         │
│  ✅ Previous version still running     │
└─────────────────────────────────────────┘
```

### Real Example
```bash
$ dotnet test src/DevopsStack.UnitTests/
  Test Run Successful
  Total tests: 5, Passed: 5

$ dotnet test src/DevopsStack.IntegrationTests/
  Test Run Successful
  Total tests: 2, Passed: 2
  ✅ STAGE 2 COMPLETE
```

---

## Stage 3: PACKAGE - Create Deployable Artifact

### What Happens
```
┌─────────────────────────────────────────┐
│ STAGE 3: PACKAGE                        │
├─────────────────────────────────────────┤
│ Purpose: Prepare deployment artifact   │
├─────────────────────────────────────────┤
│ Steps:                                  │
│  [3.1] dotnet publish (Release mode)   │
│  [3.2] docker build                    │
├─────────────────────────────────────────┤
│ Output:                                 │
│  ✅ ./publish/ folder                  │
│  ✅ Docker image: devopsstack:latest   │
│  ✅ Ready for deployment               │
├─────────────────────────────────────────┤
│ If Fails:                               │
│  ❌ Pipeline STOPS                      │
│  ❌ Deployment does NOT happen         │
└─────────────────────────────────────────┘
```

### Real Example
```bash
$ dotnet publish src/DevopsStack.API/ -c Release -o ./publish
  Published successfully
  Removal: 15 files removed

$ docker build -t devopsstack:latest .
  Successfully tagged devopsstack:latest
  ✅ STAGE 3 COMPLETE
```

---

## Stage 4: PUSH - Push to Registry

### What Happens
```
┌─────────────────────────────────────────┐
│ STAGE 4: PUSH                           │
├─────────────────────────────────────────┤
│ Purpose: Store artifact in registry    │
├─────────────────────────────────────────┤
│ Steps:                                  │
│  [4.1] docker push (to registry)       │
│  [4.2] Verify in registry              │
├─────────────────────────────────────────┤
│ Registries:                             │
│  • Docker Hub (docker.io)              │
│  • Azure Container Registry (ACR)      │
│  • AWS ECR                             │
│  • GitLab Registry                     │
├─────────────────────────────────────────┤
│ Output:                                 │
│  ✅ Image stored in registry           │
│  ✅ Version history maintained         │
│  ✅ Available from anywhere            │
├─────────────────────────────────────────┤
│ For Localhost:                          │
│  🏠 Use local Docker image             │
│  Skip push step                        │
└─────────────────────────────────────────┘
```

### Real Example (Production)
```bash
$ docker push myregistry/devopsstack:latest
  The push refers to repository [docker.io/myregistry/devopsstack]
  Sha256: a1b2c3d4...
  latest: digest: sha256:...
  ✅ STAGE 4 COMPLETE
```

### For Localhost
```bash
# Skip push step
docker-compose up  # Uses local image
✅ STAGE 4 SKIPPED (localhost)
```

---

## Stage 5: DEPLOY - Run Application

### What Happens
```
┌─────────────────────────────────────────┐
│ STAGE 5: DEPLOY                         │
├─────────────────────────────────────────┤
│ Purpose: Run application on server     │
├─────────────────────────────────────────┤
│ Steps:                                  │
│  [5.1] Pull/Use image                  │
│  [5.2] Start container                 │
│  [5.3] Run health checks               │
│  [5.4] Verify accessibility            │
├─────────────────────────────────────────┤
│ Deployment Environments:                │
│  • Staging (test before prod)          │
│  • Production (users access)           │
├─────────────────────────────────────────┤
│ Output:                                 │
│  ✅ Container running                  │
│  ✅ Health checks passing              │
│  ✅ Application accessible             │
├─────────────────────────────────────────┤
│ If Fails:                               │
│  ❌ Health check fails                 │
│  ❌ Rollback to previous version       │
│  ✅ Alerts triggered                   │
│  ✅ DevOps team notified               │
└─────────────────────────────────────────┘
```

### Real Example (Docker Compose)
```bash
$ docker-compose up
  Creating devopsstack-api ... done
  Attaching to devopsstack-api
  devopsstack-api | info: Running application...
  
Health check:
  curl http://localhost:8080/api/cipeline/info
  200 OK ✅
  
✅ STAGE 5 COMPLETE
```

### Real Example (IIS)
```bash
# Publish to IIS folder
$ dotnet publish -c Release -o C:\iis-apps\devopsstack

# IIS serves application
http://devopsstack.local/api/cipeline/info
200 OK ✅

✅ STAGE 5 COMPLETE
```

---

## Failure Scenarios

### Scenario 1: Build Fails
```
Builder pushes code
        ↓
Stage 1 (BUILD)
  dotnet build
  ❌ COMPILATION ERROR
        ↓
Pipeline STOPS Immediately
  - No tests run
  - No Docker image created
  - Application unchanged
  - Developer notified
        ↓
Developer fixes code, pushes again
```

### Scenario 2: Tests Fail
```
Code compiles successfully
        ↓
Stage 2 (TEST)
  dotnet test
  ❌ TEST FAILURE
        ↓
Pipeline STOPS
  - No Docker image created
  - No deployment happens
  - Previous version still running
        ↓
Developer debugs, fixes code, pushes again
```

### Scenario 3: Docker Build Fails
```
Tests all pass
        ↓
Stage 3 (PACKAGE)
  docker build
  ❌ DOCKERFILE ERROR
        ↓
Pipeline STOPS
  - No push happens
  - No deployment happens
        ↓
DevOps fixes Dockerfile, commits fix
```

### Scenario 4: Deployment Fails
```
All stages pass, image ready
        ↓
Stage 5 (DEPLOY)
  docker-compose up
  ❌ Container crashes
  Health check fails
        ↓
Automatic Response
  ✅ Rollback to previous version
  ✅ Alerts triggered
  ✅ DevOps team investigates
        ↓
Rollback successful
  - Users unaffected
  - Service restored
```

---

## Time Breakdown

### Stage Execution Times

| Stage | Time | What |
|-------|------|------|
| **Stage 1: BUILD** | 5-10s | Restore + Compile |
| **Stage 2: TEST** | 5-10s | Unit + Integration tests |
| **Stage 3: PACKAGE** | 10-20s | Publish + Docker build |
| **Stage 4: PUSH** | 3-5s | Push to registry |
| **Stage 5: DEPLOY** | 10-30s | Start container + Health check |
| **Total** | 33-75s | Entire pipeline |

**Key Point:** Fast feedback = Catch issues quickly

---

## Success Flow

### Complete Success Path
```
┌─────────────────────────────┐
│ Developer Pushes Code       │
└────────────┬────────────────┘
             ↓
┌─────────────────────────────┐
│ ✅ Stage 1: BUILD PASSED    │ (5-10s)
└────────────┬────────────────┘
             ↓
┌─────────────────────────────┐
│ ✅ Stage 2: TEST PASSED     │ (5-10s)
└────────────┬────────────────┘
             ↓
┌─────────────────────────────┐
│ ✅ Stage 3: PACKAGE         │ (10-20s)
│    Docker image ready       │
└────────────┬────────────────┘
             ↓
┌─────────────────────────────┐
│ ✅ Stage 4: PUSH COMPLETE   │ (3-5s)
│    Image in registry        │
└────────────┬────────────────┘
             ↓
┌─────────────────────────────┐
│ ✅ Stage 5: DEPLOY          │ (10-30s)
│    Application Running      │
│    Users Can Access         │
└─────────────────────────────┘
```

---

## Key Takeaways

1. **5 Stages = 5 Quality Gates**
   - Each stage passes = Next stage runs
   - Each stage fails = Pipeline stops

2. **Early Failure = Save Time**
   - Compilation error = Stop in 5 seconds
   - No need to wait 70 seconds for failed tests

3. **Each Stage Has Purpose**
   - BUILD = Code compiles
   - TEST = Code works correctly
   - PACKAGE = Deployment ready
   - PUSH = Centralized storage
   - DEPLOY = Live application

4. **Stages Flow Left to Right**
   - Can't deploy before packaging
   - Can't package before testing
   - Can't test before building

5. **Automation = Consistency**
   - Same steps every time
   - No manual mistakes
   - Same artifact format everywhere

---

## Your DevopsStack Implementation

Your project demonstrates all 5 stages:

1. **BUILD** → `build.bat` / GitHub Actions
2. **TEST** → Unit & Integration tests
3. **PACKAGE** → Docker image creation
4. **PUSH** → (Skipped for localhost)
5. **DEPLOY** → `docker-compose up` or IIS

Run the pipeline:
```bash
.\ci-cd\build-scripts\build.bat
```

Watch each stage execute with clear output!
