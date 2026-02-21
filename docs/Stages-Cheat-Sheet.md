- # Pipeline Stages - Quick Reference Cheat Sheet

## 🎯 The 5 Stages (Print This & Pin to Wall)

```
┌──────────────────────────────┐
│   STAGE 1: BUILD             │
│   └─ dotnet restore          │
│   └─ dotnet build            │
│   Output: DLL files          │
│   Fail → Pipeline STOPS      │
└──────────┬───────────────────┘
           │
┌──────────▼───────────────────┐
│   STAGE 2: TEST              │
│   └─ dotnet test (unit)      │
│   └─ dotnet test (integration)
│   Output: Pass/Fail          │
│   Fail → No Docker image     │
└──────────┬───────────────────┘
           │
┌──────────▼───────────────────┐
│   STAGE 3: PACKAGE           │
│   └─ dotnet publish          │
│   └─ docker build            │
│   Output: Docker image       │
│   Fail → No deployment       │
└──────────┬───────────────────┘
           │
┌──────────▼───────────────────┐
│   STAGE 4: PUSH              │
│   └─ docker push             │
│   To: Docker Hub/ACR/ECR     │
│   For localhost: SKIP        │
│   Output: Image in registry  │
└──────────┬───────────────────┘
           │
┌──────────▼───────────────────┐
│   STAGE 5: DEPLOY            │
│   └─ docker-compose up       │
│   └─ OR IIS deployment       │
│   Output: Running app        │
│   Users can access           │
└──────────────────────────────┘
```

---

## Quick Answers - Memorize These

### Q1: Stages in order?
**A:** BUILD → TEST → PACKAGE → PUSH → DEPLOY

### Q2: If test fails?
**A:** Pipeline stops, Docker image NOT created, deployment does NOT happen

### Q3: Docker in which stage?
**A:** Stage 3 (PACKAGE)

### Q4: Why separate stages?
**A:** Fail fast → catch errors early → save time/money

### Q5: Stages 1-3 vs 4-5?
**A:** 
- Stages 1-3: CODE QUALITY (Build, Test, Package)
- Stages 4-5: DELIVERY (Push, Deploy)

---

## Stage Failure Outcomes

| If Fails | Result | Next? |
|----------|--------|-------|
| **Stage 1** | Code doesn't compile | ❌ STOP |
| **Stage 2** | Tests fail | ❌ STOP, no image |
| **Stage 3** | Docker build fails | ❌ STOP |
| **Stage 4** | Push fails | ❌ STOP |
| **Stage 5** | Deploy fails | ⚠️ ROLLBACK |

---

## Time per Stage

| Stage | Time | Activity |
|-------|------|----------|
| 1 | 5-10s | Restore + Compile |
| 2 | 5-10s | Test |
| 3 | 10-20s | Publish + Docker |
| 4 | 3-5s | Push |
| 5 | 10-30s | Deploy + Health |
| **Total** | **33-75s** | **Full pipeline** |

---

## Run Pipeline Now

### Windows:
```cmd
cd c:\Development\DevOps\DevOpsStack
```

### Linux/Mac:
```bash
cd c:/Development/DevOps/DevOpsStack
./ci-cd/build-scripts/build.sh
```

**Watch for:** Each stage marked [STAGE X/5]

---

## Key Phrases (Memorize These)

1. **"BUILD, TEST, PACKAGE, PUSH, DEPLOY"**
   - Say it 10x fast

2. **"Fail fast principle"**
   - Catch errors ASAP

3. **"Each stage is a quality gate"**
   - Must pass to proceed

4. **"Docker Stage 3"**
   - Creates artifact

5. **"If tests fail, no image created"**
   - Prevents bad code deployment

---

## Interview Questions - Quick Answers

**Q: What's a pipeline?**
A: Automated software assembly line.

**Q: 5 stages?**
A: BUILD, TEST, PACKAGE, PUSH, DEPLOY

**Q: Why stages?**
A: Fail fast, catch errors early.

**Q: If test fails?**
A: Pipeline stops, deployment blocked.

**Q: Docker where?**
A: Stage 3, PACKAGE.

**Q: Delivery vs Deployment?**
A: Delivery = manual approval, Deployment = auto.

---

## Your DevopsStack Has All 5

```
Local: .\ci-cd\build-scripts\build.bat
GitHub: .github/workflows/ci-pipeline.yml
GitHub: .github/workflows/cd-pipeline.yml
```

Run them. Watch stages execute. Understand them.

---

## The Core Truth

> **Each stage must pass for next one to run.**
> 
> **If any stage fails, pipeline stops immediately.**
> 
> **This is why we separate stages.**
> 
> **This is DevOps.**

---

## Immediate Action

1. Read: [Day2-Pipeline-Stages.md](Day2-Pipeline-Stages.md)
2. Run: `build.bat` or `build.sh`
3. Practice: [Day2-Practice-Exercises.md](Day2-Practice-Exercises.md)
4. Repeat until you own it

---

**Print this page. Reference it. Master it.**

Your DevOps foundation is built on understanding these 5 stages.
