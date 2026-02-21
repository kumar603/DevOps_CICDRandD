# Day 2 Practice Exercises & Answers

## Your 20-Minute Practice from Curriculum

### ⏱ 5 Minutes: Read and Understand
✅ Read [Day2-Pipeline-Stages.md](Day2-Pipeline-Stages.md)

---

## ⏱ 10 Minutes: Explain Scenarios Aloud

### Scenario 1: "What happens if build fails?"

**Model Answer:**
> "If the build stage fails, it means the code doesn't compile. The pipeline stops immediately right there. No tests run, no Docker image gets created, and the application is not deployed. The previous working version continues running. The developer is notified of the compilation error and needs to fix it."

**Key Points:**
- Pipeline stops at Stage 1
- Build errors caught immediately
- Saves time (no point running tests on broken code)
- Fail fast = Cheaper fix

---

### Scenario 2: "What happens if tests fail?"

**Model Answer:**
> "If tests fail, it means the code compiles but doesn't work correctly. The pipeline stops at the Test stage. This is important because even though build passed, the Docker image is NOT created. The deployment doesn't happen. The previous version keeps running. This prevents broken code from reaching users."

**Key Points:**
- Tests are a quality gate
- Docker image not created after test failure
- Previous version unaffected
- Test failures prevent deployment

---

### Scenario 3: "Why do we separate stages?"

**Model Answer:**
> "We separate stages because each has a specific purpose and a quality gate. If something fails early, we don't waste time running steps that won't matter. Stage 1 finds compilation errors in 5 seconds instead of waiting 70 seconds. Stage 2 catches logic errors before packaging. Each stage is a checkpoint. This is called 'fail fast' and saves enormous amounts of time and money."

**Key Points:**
- Early detection saves time
- Won't proceed with broken code
- Catch mistakes as soon as possible
- Professional pipelines always do this

---

### Scenario 4: "Where does Docker fit in pipeline?"

**Model Answer:**
> "Docker comes in Stage 3, the Package stage. After code compiles and tests pass, we create a Docker image. This image is the deployable artifact. It's a snapshot of the application with all dependencies included. In Stage 4, we push this image to a registry like Docker Hub. In Stage 5, we run this image on a server. Docker ensures the application runs the same everywhere."

**Key Points:**
- GitHub stage 3 = Package
- Docker creates deployable artifact
- Same image runs everywhere
- Stage 4 = Push to registry
- Stage 5 = Run the image

---

### Scenario 5: "What's the difference between Continuous Delivery and Deployment?"

**Model Answer:**
> "Continuous Delivery means the application is automatically prepared and ready for deployment, but a human must give approval before it goes to production. Continuous Deployment means it's automatically deployed without any human approval. In both cases, Stages 1-4 are automatic. The difference is in Stage 5: Delivery waits, Deployment goes live immediately."

**Key Points:**
- Both have automatic Build, Test, Package
- Delivery = manual approval for production
- Deployment = automatic production release
- Interview asks this frequently

---

## ⏱ 5 Minutes: Draw and Explain

### What You Should Draw:

```
CODE
  ↓
BUILD (compile)
  ✅ or ❌
  ↓
TEST (validate)
  ✅ or ❌
  ↓
PACKAGE (Docker)
  ↓
PUSH (registry)
  ↓
DEPLOY (run)
  ↓
APPLICATION LIVE
```

### Annotations to Add:

**Next to BUILD:**
- What: dotnet build
- Output: DLL files
- Fails: Syntax error

**Next to TEST:**
- What: Unit + Integration tests
- Output: Pass/Fail report
- Fails: Code logic error

**Next to PACKAGE:**
- What: docker build
- Output: Docker image
- Fails: Deployment blocked

**Next to PUSH:**
- What: docker push
- Output: Image in registry
- Note: Skipped for localhost

**Next to DEPLOY:**
- What: docker-compose up
- Output: Running app
- Fails: Rollback triggered

---

## Test Yourself - Answer Without Looking

### Question 1: Full Stage Order
**Q:** "List the 5 pipeline stages in order"

**Your Answer Should Be:**
```
1. BUILD
2. TEST
3. PACKAGE
4. PUSH
5. DEPLOY
```

**How to remember:** BUILD → TEST → PACKAGE → PUSH → DEPLOY

---

### Question 2: Stage 1 Details
**Q:** "What happens in the BUILD stage?"

**Your Answer Should Include:**
- Purpose: Compile code and restore dependencies
- Commands: `dotnet restore` and `dotnet build`
- Output: DLL files in obj/bin folder
- If fails: Pipeline stops, no further stages run

---

### Question 3: Stage 2 Details
**Q:** "What happens in the TEST stage?"

**Your Answer Should Include:**
- Purpose: Run automated tests
- Validates: Code correctness and quality
- If fails: Docker image is NOT created
- Why important: Prevents broken code deployment

---

### Question 4: Stage 3 Details
**Q:** "What happens in the PACKAGE stage?"

**Your Answer Should Include:**
- Purpose: Create deployable artifact
- Commands: `dotnet publish` and `docker build`
- Output: Docker image with tag `devopsstack:latest`
- Why: Standardized format for deployment

---

### Question 5: Stage 4 Details
**Q:** "What happens in the PUSH stage?"

**Your Answer Should Include:**
- Purpose: Upload image to registry
- Examples: Docker Hub, Azure Container Registry, AWS ECR
- For localhost: Skipped (use local images)
- Why: Centralized storage, version control

---

### Question 6: Stage 5 Details
**Q:** "What happens in the DEPLOY stage?"

**Your Answer Should Include:**
- Purpose: Run application on target server
- Environments: Staging (testing) and Production (live)
- For localhost: `docker-compose up`
- What happens: Container starts, health checks run

---

### Question 7: The "If Tests Fail" Question
**Q:** "If tests fail, does a Docker image get created?"

**Your Answer:** 
NO. Docker image creation is in Stage 3. If Stage 2 (Tests) fails, the pipeline stops and never reaches Stage 3.

---

### Question 8: The "Why Separate" Question
**Q:** "Why don't we just run everything at once?"

**Your Answer Should Explain:**
- Early detection of errors saves time
- Fail fast principle
- Each stage is a quality gate
- No point running tests on code that doesn't compile
- No point packaging code that fails tests
- Professional pipelines always separate

---

### Question 9: The Docker Question
**Q:** "In which stage does Docker come in, and why?"

**Your Answer:**
- Stage: 3 (PACKAGE)
- Why: After all tests pass, we create a containerized version
- Ensures consistent deployment across all environments
- Makes Stage 4 (PUSH to registry) and Stage 5 (DEPLOY) possible

---

### Question 10: Failure Handling
**Q:** "What happens if Stage 4 (PUSH) fails?"

**Your Answer Should Include:**
- Pipeline stops at Stage 4
- Image NOT pushed to registry
- Deployment (Stage 5) does NOT happen
- Application continues running previous version
- DevOps fixes the registry/authentication issue
- Commits fix and restarts pipeline

---

## Interview Questions You're Now Ready For

### Q1: "Explain a CI/CD pipeline in simple terms"
**Your Answer:**
"A pipeline is an automated assembly line for software. Code goes through stages: Build, Test, Package, Push, and Deploy. Each stage validates the code. If any stage fails, the pipeline stops to catch errors early. This automation saves time and prevents bugs from reaching users."

### Q2: "What are the main pipeline stages?"
**Your Answer:**
"1. Build - Compile code and dependencies
2. Test - Run automated tests
3. Package - Create Docker image
4. Push - Upload to registry
5. Deploy - Run application on server"

### Q3: "Why are stages separate?"
**Your Answer:**
"Each stage is a quality gate. Separating them let us 'fail fast' - catch errors as early as possible. If code doesn't compile, we know in 5 seconds, not 70 seconds. This saves enormous amounts of time and money."

### Q4: "What happens if tests fail?"
**Your Answer:**
"The pipeline stops at the Test stage. No Docker image is created, so deployment doesn't happen. The previous working version keeps running. This safeguard prevents broken code from reaching users."

### Q5: "Where does Docker fit in?"
**Your Answer:**
"Docker comes in the Package stage. After tests pass, we create a Docker image, which is the deployable artifact. In the Push stage, we upload this image. In the Deploy stage, we run it on a server."

---

## Practice Repetition - Read Daily

Take 5 minutes every morning to read this section aloud:

```
Pipeline = Automated software assembly line

5 Stages:
1. BUILD - Compile code
2. TEST - Validate code works
3. PACKAGE - Prepare Docker image
4. PUSH - Upload to registry
5. DEPLOY - Run application

Each stage must pass for next to run.
Each failure stops pipeline.
Early failure saves time and money.
```

Say it until you can explain it in your sleep.

---

## Verification Checklist

Can you answer YES to all?

- [ ] I can list 5 stages in order without looking
- [ ] I can explain what each stage does
- [ ] I understand what happens if each stage fails
- [ ] I know why stages are separated
- [ ] I know where Docker fits in pipeline
- [ ] I can explain to non-technical person
- [ ] I can handle interview questions
- [ ] I understand fail-fast principle

If any is NO, re-read that section.

---

## Your DevopsStack Lab

Run this to see all 5 stages:

```bash
cd c:\Development\DevOps\DevOpsStack_RandD
.\ci-cd\build-scripts\build.bat
```

Watch the output. You'll see:
- Stage 1: [STAGE 1/5] BUILD
- Stage 2: [STAGE 2/5] TEST
- Stage 3: [STAGE 3/5] PACKAGE
- Stage 4: [STAGE 4/5] PUSH
- Stage 5: [STAGE 5/5] DEPLOY

See how each stage is marked? That's teaching you the structure.
