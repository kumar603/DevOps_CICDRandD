Download
We recommend configuring the runner under "\actions-runner". 
This will help avoid issues related to service identity folder permissions and long path restrictions on Windows.

# Create a folder under the drive root
mkdir actions-runner; cd actions-runner

# Download the latest runner package

Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.331.0/actions-runner-win-x64-2.331.0.zip -OutFile actions-runner-win-x64-2.331.0.zip

The file is approximately 180 MB.

# Optional: Validate the hash 
if((Get-FileHash -Path actions-runner-win-x64-2.331.0.zip -Algorithm SHA256).Hash.ToUpper() -ne '473e74b86cd826e073f1c1f2c004d3fb9e6c9665d0d51710a23e5084a601c78a'.ToUpper()){ throw 'Computed checksum did not match' }

# Extract the installer
Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.331.0.zip", "$PWD")

Configure

# Create the runner and start the configuration experience
./config.cmd --url https://github.com/kumar603/DevOps_CICDRandD --token AQV3IYX5LTZEP4X4VNUA3ATJTELXA

# Run it! (Manual Mode ONLY)
# If you installed as a Service (Y), SKIP THIS STEP.
./run.cmd

# If installed as a Service, check 'services.msc' to ensure it is running.

# Use this YAML in your workflow file for each job
runs-on: self-hosted


========================================================================================
Execution Commands Logs

PS C:\actions-runner> ./config.cmd --url https://github.com/kumar603/DevOps_CICDRandD --token AQV3IYX5LTZEP4X4VNUA3ATJTELXA

--------------------------------------------------------------------------------
|        ____ _ _   _   _       _          _        _   _                      |
|       / ___(_) |_| | | |_   _| |__      / \   ___| |_(_) ___  _ __  ___      |
|      | |  _| | __| |_| | | | | '_ \    / _ \ / __| __| |/ _ \| '_ \/ __|     |
|      | |_| | | |_|  _  | |_| | |_) |  / ___ \ (__| |_| | (_) | | | \__ \     |
|       \____|_|\__|_| |_|\__,_|_.__/  /_/   \_\___|\__|_|\___/|_| |_|___/     |
|                                                                              |
|                       Self-hosted runner registration                        |
|                                                                              |
--------------------------------------------------------------------------------

# Authentication


√ Connected to GitHub

# Runner Registration

Enter the name of the runner group to add this runner to: [press Enter for Default]

Enter the name of runner: [press Enter for KIRANS] KiranRunner

This runner will have the following labels: 'self-hosted', 'Windows', 'X64'
Enter any additional labels (ex. label-1,label-2): [press Enter to skip]

√ Runner successfully added

# Runner settings

Enter name of work folder: [press Enter for _work] Devops

√ Settings Saved.

Would you like to run the runner as service? (Y/N) [press Enter for N] Y
User account to use for the service [press Enter for NT AUTHORITY\NETWORK SERVICE]
Granting file permissions to 'NT AUTHORITY\NETWORK SERVICE'.
Service actions.runner.kumar603-DevOps_CICDRandD.KiranRunner successfully installed
Service actions.runner.kumar603-DevOps_CICDRandD.KiranRunner successfully set recovery option
Service actions.runner.kumar603-DevOps_CICDRandD.KiranRunner successfully set to delayed auto start
Service actions.runner.kumar603-DevOps_CICDRandD.KiranRunner successfully configured
Waiting for service to start...


Press Windows Key + R, type services.msc, and press Enter.
Find the service named "GitHub Actions Runner..." (it will have your repo name).
Right-click it > Properties.
Go to the Log On tab.
Select Local System account.
Click OK.
Right-click the service again and select Restart.



# 1. Stage all changes
git add .

# 2. Commit with a message
git commit -m "Fixed Default Connection"

# 3. Push to G
git push  

 Where to See Logs
Since your runner is running as a background service, you won't see a black window anymore. Here is where to check what's happening:

https://github.com/kumar603/DevOps_CICDRandD/settings/actions/runners

A. GitHub Actions (Best for Pipeline Status) This is the primary place to check. The runner sends logs back to GitHub.

Go to your GitHub Repository.
Click the Actions tab.
Click the latest run (e.g., "Fixed bug in API").
Click deploy-to-local-iis.
Expand the Run Local Build & Deploy Script step to see the build.bat output.

# Qucik Checkins
Make a change in your code (e.g., change "Kiran" to "Kiran V2" in CIPipelineController.cs).
Run .\quick-push.bat in your terminal.
Watch the automation happen.
