# Day 2 – Pipeline Stages Overview

## 🎯 Today's Goal

Understand what actually happens inside a pipeline. By the end of today, you must confidently explain:
- What is a pipeline?
- What are stages?
- What happens in each stage?

---

## 🧱 What is a Pipeline?

### Definition
**A pipeline is an automated sequence of steps that runs after code is pushed.**

Think of it like a **factory assembly line for software**:

```
Developer pushes code
        ↓
Pipeline runs steps
        ↓
Application becomes deployable
```

### Why Pipelines Exist

| Before Pipelines | With Pipelines |
|------------------|----------------|
| Manual build steps | Automatic build |
| Manual testing | Automatic testing |
| Manual packaging | Automatic packaging |
| Manual deployment | Automatic deployment |
| Slow releases | Fast releases |
| Many human errors | Fewer errors |

---

## 🧩 The 5 Core Pipeline Stages

Every professional pipeline has these stages in order:

### 🔹 Stage 1 – BUILD

**Purpose:** Compile code and restore dependencies

**What happens:**
- Download all required packages
- Compile source code to executable format
- Check for compilation errors

**Example (.NET):**
```bash
dotnet restore    # Download NuGet packages
dotnet build      # Compile code
```

**Result:** 
- ✅ Compiled binaries (DLL files)
- ❌ If fails → STOP pipeline (nothing else runs)

**Why it matters:**
- Catches syntax errors immediately
- Prevents broken code from going further
- Ensures dependencies are available

---

### 🔹 Stage 2 – TEST

**Purpose:** Run automated tests and validate code quality

**What happens:**
- Execute unit tests
- Execute integration tests
- Check code coverage
- Validate business logic

**Example:**
```bash
dotnet test                    # Run all tests
dotnet test --filter "Unit"    # Run specific test category
```

**Result:**
- ✅ All tests pass → Continue to next stage
- ❌ Tests fail → STOP pipeline

**Why it matters:**
- Prevents broken code from deployment
- Ensures features work as intended
- Saves time vs manual testing
- Documents expected behavior

---

### 🔹 Stage 3 – PACKAGE

**Purpose:** Prepare application for deployment

**What happens:**
- Create release package
- Prepare Docker image
- Bundle all dependencies
- Create artifact

**Examples:**
```bash
# Option A: Create publish folder
dotnet publish -c Release -o ./publish

# Option B: Create Docker image
docker build -t myapp:latest .

# Option C: Create ZIP artifact
zip -r app.zip ./publish
```

**Result:**
- ✅ Deployable artifact (Docker image, folder, or ZIP)
- Ready to be pushed to registry or deployed directly

**Why it matters:**
- Standardizes deployment format
- Reduces environment differences
- Makes rollback easier
- Enables multiple deployment options

---

### 🔹 Stage 4 – PUSH (Optional but Common)

**Purpose:** Push packaged artifact to a registry

**What happens:**
- Take Docker image from Stage 3
- Push to container registry
- Make it accessible to deployment servers

**Examples:**
```bash
# Docker Hub
docker push myregistry/myapp:latest

# Azure Container Registry
az acr build --registry myregistry --image myapp:latest .

# AWS ECR
aws ecr push-image --repository myapp
```

**Result:**
- ✅ Image stored in registry
- Available for deployment from anywhere

**Why it matters:**
- Centralized artifact storage
- Enables scale-out deployments
- Provides version history
- **Note:** In your localhost setup, you'd push to Docker Hub or skip this (use local image)

---

### 🔹 Stage 5 – DEPLOY

**Purpose:** Deploy application to a server

**What happens:**
- Pull artifact from registry (or use local)
- Start application on target server
- Run health checks
- Verify application is running

**Examples:**
```bash
# Docker local deployment
docker-compose up -d

# IIS deployment (Windows)
Copy files to IIS folder
Start IIS website

# Kubernetes
kubectl apply -f deployment.yaml
```

**Deployment Environments:**
- **Staging:** Test environment (like production, but for testing)
- **Production:** Live environment (users access this)

**Result:**
- ✅ Application running and accessible
- Users can use the application

**Why it matters:**
- Users get new features
- Automated deployment reduces manual errors
- Can be immediate (Continuous Deployment) or after approval (Continuous Delivery)

---

## 🧠 The Complete Pipeline Flow

### Visual Representation

```
┌─────────────────────────────────────────────────────────────┐
│ Developer pushes code to GitHub                              │
└────────────────────┬────────────────────────────────────────┘
                     ↓
        ┌────────────────────────┐
        │  STAGE 1: BUILD        │
        │  dotnet restore        │
        │  dotnet build          │
        │  ✅ or ❌              │
        └────────┬───────────────┘
                 ↓
        ┌────────────────────────┐
        │  STAGE 2: TEST         │
        │  dotnet test           │
        │  ✅ or ❌              │
        └────────┬───────────────┘
                 ↓
        ┌────────────────────────┐
        │  STAGE 3: PACKAGE      │
        │  docker build          │
        │  Create image          │
        │  ✅                    │
        └────────┬───────────────┘
                 ↓
        ┌────────────────────────┐
        │  STAGE 4: PUSH         │
        │  docker push           │
        │  (Optional locally)    │
        │  ✅                    │
        └────────┬───────────────┘
                 ↓
        ┌────────────────────────┐
        │  STAGE 5: DEPLOY       │
        │  docker-compose up     │
        │  OR IIS deployment     │
        │  ✅                    │
        └────────────────────────┘
                 ↓
        Application Running → Users Can Access
```

### One-Sentence Summary
> **Code commit → Build → Test → Package → Push → Deploy**

---

## 🏗 Real Example: Your DevOpsStack API

When you push code to GitHub:

```
Stage 1 - BUILD:
├─ dotnet restore (get NuGet packages)
└─ dotnet build (compile C# code)

Stage 2 - TEST:
├─ dotnet test UnitTests (5 tests)
└─ dotnet test IntegrationTests (2 tests)

Stage 3 - PACKAGE:
└─ docker build -t devopsstack:latest . (create image)

Stage 4 - PUSH:
└─ docker push registry/devopsstack:latest (optional for localhost)

Stage 5 - DEPLOY:
├─ docker-compose up (start container)
├─ Health check (test if running)
└─ Application available at http://localhost:8080
```

**If BUILD fails:** Pipeline stops. Nothing else runs.  
**If TEST fails:** Pipeline stops. Docker image is never built.  
**If PACKAGE fails:** DEPLOY never runs.  
**If all pass:** Application is deployed and live.

---

## ❌ What Happens If Each Stage Fails

### Build Fails
```
❌ Build error (syntax, missing dependency)
→ Pipeline stops immediately
→ Developer sees error
→ No tests run
→ No deployment happens
→ Previous version still running
```

**Developer Action:** Fix code, push again

### Test Fails
```
✅ Build succeeds
❌ Test fails (logic error)
→ Pipeline stops
→ Docker image NOT created
→ No deployment happens
→ Previous version still running
```

**Developer Action:** Fix code logic, push again

### Package Fails
```
✅ Build succeeds
✅ Tests pass
❌ Docker build fails
→ Pipeline stops
→ No deployment happens
```

**Developer Action:** Fix Dockerfile, push again

### Deploy Fails
```
✅ Build succeeds
✅ Tests pass
✅ Package created
❌ Container fails to start
→ Application down
→ Alerts triggered
→ Rollback to previous version
```

**DevOps Action:** Investigate logs, rollback if needed

---

## 🎯 Key Concepts to Understand

### 1. Pipeline = Automation
Everything runs automatically without human intervention (in CD).

### 2. Stages = Quality Gates
Each stage is a checkpoint. Bad code stops at the earliest checkpoint.

### 3. Build First = Fail Fast
Compilation errors caught in seconds, not hours.

### 4. Test Before Package = Prevent Deployment of Broken Code
Broken tests prevent Docker image from being created.

### 5. Package Then Deploy = Consistency
Same package deployed everywhere (dev, staging, production).

---

## 📊 Stage Failures = Cost Savings

### Without Pipeline (Manual Process)
```
Developer writes code → 1 day later
QA manually tests → Finds bugs
Developer fixes bugs → 1 day later
QA tests again → Still bugs
Developer frustrated
```
**Time wasted: 3-5 days**

### With Pipeline (Automated)
```
Developer writes code
Developer pushes code
Pipeline auto-tests → Fails in 5 minutes
Developer sees error in Slack → Fixes immediately  
Developer pushes fix
Pipeline passes → Deployed in 10 minutes
```
**Time: 15 minutes instead of 3-5 days** ⚡

---

## 🔍 Interview Questions You Might Get

### Q1: "What are pipeline stages?"
**Answer:**
"Pipeline stages are sequential steps that run automatically after code is pushed. The main stages are: Build, Test, Package, Push, and Deploy. Each stage has a specific purpose, and if any stage fails, the pipeline stops."

### Q2: "Why do we separate build and test?"
**Answer:**
"Because we want to catch errors as early as possible. If code doesn't compile, there's no point running tests. This saves time and makes failures clear."

### Q3: "What happens if tests fail?"
**Answer:**
"The pipeline stops immediately after the Test stage. The Docker image is not created, and deployment doesn't happen. The previous working version continues running."

### Q4: "Where does Docker fit in a pipeline?"
**Answer:**
"Docker comes in the Package stage. After tests pass, we create a Docker image from the tested code. This image is then pushed to a registry in the Push stage, and deployed in the Deploy stage."

### Q5: "What's the difference between Stage 4 (Push) and Stage 5 (Deploy)?"
**Answer:**
"Push uploads the Docker image to a registry (Docker Hub, Azure Registry, etc.) for storage. Deploy actually runs that image on a server. For localhost, we might skip Push and use local images."

---

## ✅ Your 20-Minute Practice

### ⏱ 5 Minutes – Read Carefully
Read this document top-to-bottom. Understand flow, not just words.

### ⏱ 10 Minutes – Explain Scenarios Aloud

Practice explaining these scenarios:

**Scenario 1:** "What happens if build fails?"
- Your answer should include: Pipeline stops, no tests run, no deployment
- Why: Code doesn't compile, can't proceed

**Scenario 2:** "What happens if tests fail?"
- Your answer should include: Pipeline stops, Docker image not created, previous version still runs
- Why: Code is broken, shouldn't be deployed

**Scenario 3:** "Why do we separate stages?"
- Your answer should include: Fail fast, catch errors early, prevent bad code from shipping
- Why: Each stage is a quality gate

**Scenario 4:** "Where does Docker fit in?"
- Your answer should include: Stage 3 (Package), after tests pass, creates deployable image
- Why: Standardized deployment format

### ⏱ 5 Minutes – Draw It

Draw a simple pipeline on paper showing:
```
Code → Build → Test → Package → Deploy
```

Add annotations:
- What each stage does
- What happens if it fails
- What output it creates

---

## 🧠 Mindset Check

### ❌ Wrong Understanding
"A pipeline is just GitHub Actions"  
"Stages are just YAML file sections"  
"Docker is stage 3"

### ✅ Right Understanding
"A pipeline is an automated sequence. GitHub Actions is ONE tool that runs it."  
"Stages are quality gates with specific purposes, ordered logically."  
"Docker comes in Stage 3 (Package) to create the deployable artifact."

---

## 🎓 Your DevopsStack Demonstrates This

Your project already has these stages:

**Stage 1 - Build:**
```bash
dotnet restore
dotnet build
```

**Stage 2 - Test:**
```bash
dotnet test src/DevopsStack.UnitTests/
dotnet test src/DevopsStack.IntegrationTests/
```

**Stage 3 - Package:**
```bash
docker build -t devopsstack:latest .
```

**Stage 4 - Push:** (Skipped locally, but configured in GitHub Actions)

**Stage 5 - Deploy:**
```bash
docker-compose up
# OR IIS deployment
```

---

## 📚 Tomorrow's Topics Preview

- How to read pipeline logs
- How to debug failed stages
- How to monitor pipeline health
- Advanced stage configuration

---

## ✅ Verification

Can you answer these without looking back?

1. **What are the 5 pipeline stages?**
2. **What happens in each stage?**
3. **If tests fail, does Docker image get created?** (Answer: No)
4. **Why do we package after tests?** (Answer: To ensure only tested code gets deployed)
5. **Where does Docker fit?** (Answer: Stage 3, Package)

If you can't answer 4/5 clearly, re-read this document.

---

**Remember:** Stages aren't just names. Each has a purpose. Understand the PURPOSE, not just the NAME.

