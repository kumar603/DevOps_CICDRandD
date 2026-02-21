# CI vs CD - Concepts & Theory

## Day 1 Learning Summary

Based on the curriculum, here's the core understanding needed:

## 1. Continuous Integration (CI)

### Definition
**CI = Automatically build & test every code change**

### What Happens When Developer Pushes Code

```
Push to Git
    ↓
[Automatic Trigger]
    ├─ Restore dependencies
    ├─ Compile/Build
    ├─ Run unit tests
    ├─ Run integration tests
    └─ Report status
```

### Problems CI Solves

| Before CI | With CI |
|-----------|--------|
| Manual merging | Automatic integration |
| Late bug detection | Early detection |
| "Works on my machine" | Consistent builds |
| Integration at end | Continuous validation |

### Key Point
Developers get **immediate feedback** if their code breaks something.

---

## 2. Continuous Delivery (CD)

### Two Different Meanings

#### 🔹 Continuous Delivery
- Application is **automatically prepared** for production
- **Manual approval** may be required before release
- "Ready to release"

#### 🔹 Continuous Deployment  
- Application is **automatically deployed** to production
- **No human approval** needed
- "Actually releasing"

### Interview Trick Question

**Q: What's the difference between Delivery and Deployment?**

**A:** 
- **Delivery**: Prepared automatically, release may need approval
- **Deployment**: Released automatically without approval

### Visual Difference

```
Continuous Delivery:
Build → Test → Stage ← [Human: Approve or Reject] → Production

Continuous Deployment:
Build → Test → Stage → Production [Automatic]
```

---

## 3. Complete CI/CD Flow

### The CI/CD Pipeline

```
Developer Code Push
        ↓
    [CI Phase]
    ├─ dotnet restore
    ├─ dotnet build  
    ├─ dotnet test
    └─ Build Success? 
        ↓ YES
    [CD Phase]
    ├─ Create Docker image
    ├─ Push to registry
    ├─ Deploy to Staging
    └─ Manual Approval (Delivery) 
        or Auto-Deploy (Deployment)
```

---

## 4. Real .NET Example

### Your Project Scenario

```
You push DevOpsStack API code to GitHub

↓ GitHub triggers pipeline ↓

[CI Pipeline Runs]
1. dotnet restore               (Get all NuGet packages)
2. dotnet build                 (Compile code)
3. dotnet test                  (Run unit & integration tests)
4. Results?
   - If PASS → Continue to CD
   - If FAIL → Stop, notify developer

[CD Pipeline Runs]
1. Build Docker image:
   docker build -t devopsstack:latest .

2. Push to registry:
   docker push myregistry/devopsstack:latest

3. Deploy to staging server

4. Deployment ready:
   - Continuous Delivery: Wait for approval
   - Continuous Deployment: Deploy live
```

---

## 5. Local Setup (Your Scenario)

### You're On Localhost - What This Means

✅ **Can Do:**
- Local builds and testing
- Docker containerization
- IIS server hosting
- Run full CI/CD workflows locally

❌ **Cannot Do:**
- Deploy to cloud (AWS, Azure, GCP)
- Use cloud registries (Docker Hub requires push)
- Use cloud CI/CD (can simulate locally)

### Local IIS Deployment Flow

```
Code Push (to GitHub or local)
    ↓
Local CI Pipeline (manual or automated)
    ├─ dotnet restore
    ├─ dotnet build
    ├─ dotnet test
    └─ dotnet publish
        ↓
    Copy to IIS folder
        ↓
    IIS serves the application
        ↓
    Test via http://localhost/app
```

---

## 6. Key Terminology

| Term | Meaning |
|------|---------|
| **CI** | Automated build & test on every push |
| **CD** | Automated delivery/deployment after CI |
| **Pipeline** | Sequence of automated steps |
| **Artifact** | Output of build (DLL, Docker image, etc.) |
| **Staging** | Test environment before production |
| **Production** | Live environment users access |

---

## 7. What You Must Remember

### The One-Sentence Definition:
> **"Developer pushes code → CI automatically builds and tests → CD automatically deploys → Application runs"**

### Daily Standup Explanation:
> "CI means every code change is automatically tested. CD means every tested change is automatically deployed. This catches bugs early and releases features faster."

### For HR/Non-Technical:
> "We've automated code quality checks and deployment processes. Less manual work, fewer bugs, faster features to users."

---

## 8. Your DevOpsStack Project Maps To This

Your project demonstrates:

✅ **CI Part:**
- Unit tests in `DevopsStack.UnitTests`
- Integration tests in `DevopsStack.IntegrationTests`  
- Build scripts in `ci-cd/build-scripts/`
- GitHub Actions in `.github/workflows/ci-pipeline.yml`

✅ **CD Part:**
- Docker containerization
- Docker-compose for deployment
- IIS hosting setup
- GitHub Actions in `.github/workflows/cd-pipeline.yml`

---

## Practice Exercise

Close this guide and answer:

1. **Why is CI needed?** 
   > Early bug detection, consistent builds, team integration

2. **What's the difference between Continuous Delivery and Deployment?**
   > Delivery = automatic prep + optional approval. Deployment = automatic release

3. **Explain CI/CD in 1 minute to HR:**
   > Automated testing catches bugs early. Automated deployment gets features to users faster.

4. **In your project, which part is CI and which is CD?**
   > CI = testing scripts. CD = Docker/IIS deployment

---

## Next Day Topics (Day 2+)

- Docker deep dive
- Kubernetes orchestration
- Monitoring and logging
- Security in CI/CD
- Infrastructure as Code
