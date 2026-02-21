Here is a concise list of all the essential Docker commands you've used and would need to set up, run, and manage this project.

Phase 1: Installation & Setup (One-time)
Install Docker Desktop:

Download and run the installer from the official Docker website.
Verify Installation:

Open a new terminal and run:

bash
docker --version
Phase 2: Building the Image
Build the Docker Image:
This command reads your Dockerfile and creates a runnable image named devopsstack.
bash
docker build -t devopsstack .
Phase 3: Running the Container
Option A: Using docker run (The Manual Way)
Run the container and map ports:

This starts your app and makes it accessible on http://localhost:8080.
bash
docker run -p 8080:8080 devopsstack
Run in the background (detached mode):

The -d flag runs the container in the background and gives you your terminal back.
bash
docker run -d -p 8080:8080 --name my-app devopsstack
Option B: Using docker-compose (The Recommended Way)
Build and run in the background:
This reads your docker-compose.yml file and handles everything for you.
bash

docker-compose up -d --build
Phase 4: Managing the Running Container
List running containers:

Shows you what's currently running, its ID, and status.
 
bash
docker ps
View application logs:

Shows the live output from inside the container.
bash
# If using docker-compose
docker-compose logs -f

# If using "docker run --name my-app"
docker logs -f my-app
Stop the container:

bash
# If using docker-compose
docker-compose down

# If using "docker run"
docker stop my-app
Phase 5: Cleanup (Optional)
Remove stopped containers and old images:
This helps free up disk space.
bash
docker system prune -f
This list covers the complete lifecycle from installation to running and stopping your containerized application.


Good. You need clarity. DevOps is command discipline.

Below is **everything you installed and executed till now**, in clean order.

---

# 🟢 1️⃣ Windows Feature Installation (WSL + Virtualization)

### Install WSL + Virtual Machine Platform

```powershell
wsl --install -d Ubuntu
```

OR (manual enable)

```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all
```

---

# 🟢 2️⃣ Restart System

After WSL installation:

```
Restart Computer
```

(Required for changes to take effect)

---

# 🟢 3️⃣ Verify WSL Installation

Check installed distributions:

```powershell
wsl -l -v
```

Expected output:

```
docker-desktop    Running    2
Ubuntu            Running    2
```

---

# 🟢 4️⃣ Ubuntu First-Time Setup

Inside Ubuntu terminal:

```
Create username
Create password
```

(No command — manual setup)

---

# 🟢 5️⃣ Docker Desktop Installation

Downloaded:

**Docker Desktop for Windows – AMD64**

Installed with:

✔ Use WSL2 instead of Hyper-V
✔ Restarted system

---

# 🟢 6️⃣ Verify Docker Installation

Check version:

```powershell
docker --version
```

---

# 🟢 7️⃣ Test Docker Engine

Run test container:

```powershell
docker run hello-world
```

---

# 🟢 8️⃣ Pull & Run Real Image (Example: Nginx)

Pull & run nginx:

```powershell
docker run -d -p 8080:80 nginx
```

Check running containers:

```powershell
docker ps
```

Stop container:

```powershell
docker stop <container_id>
```

---

# 🟢 9️⃣ Incorrect Command You Tried (Learning Point)

```powershell
docker run welcome kiran
```

Why it failed:

* No image named `welcome`

---

# 🟢 10️⃣ Optional Helpful Commands

List images:

```powershell
docker images
```

List all containers (running + stopped):

```powershell
docker ps -a
```

Remove container:

```powershell
docker rm <container_id>
```

Remove image:

```powershell
docker rmi <image_name>
```

---

# 🎯 What You Have Successfully Set Up

✔ BIOS Virtualization
✔ WSL2
✔ Ubuntu distribution
✔ Docker Desktop
✔ Docker Engine
✔ Docker Hub pull access
✔ Container execution

This is a complete modern Docker Windows setup.

---
 
 Install the latest PowerShell for new features and improvements! https://aka.ms/PSWindows

PS C:\WINDOWS\system32> wsl -l -v
Windows Subsystem for Linux has no installed distributions.
You can resolve this by installing a distribution with the instructions below:

Use 'wsl.exe --list --online' to list available distributions
and 'wsl.exe --install <Distro>' to install.
PS C:\WINDOWS\system32> wsl --install -d Ubuntu
Downloading: Ubuntu
Installing: Ubuntu
Distribution successfully installed. It can be launched via 'wsl.exe -d Ubuntu'
Launching Ubuntu...
Provisioning the new WSL instance Ubuntu
This might take a while...
Create a default Unix user account: kiran
New password:Welcome1$
Retype new password:Welcome1$
passwd: password updated successfully
wsl: Failed to start the systemd user session for 'kiran'. See journalctl for more details.
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

PS C:\WINDOWS\system32> wsl -l -v
  NAME              STATE           VERSION
* docker-desktop    Running         2
  Ubuntu            Running         2

kiran@Kirans:/mnt/c/WINDOWS/system32$