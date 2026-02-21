# IIS Configuration Fix for localhost:8082

## Quick Fix Steps

### Step 1: Deploy Files to IIS physical path
```powershell
# Create IIS app directory
mkdir "C:\iis-apps\devopsstack" -ErrorAction SilentlyContinue

# Copy published files
Copy-Item ".\publish\*" -Destination "C:\iis-apps\devopsstack\" -Recurse -Force
```

### Step 2: Run IIS Configuration Script (AS ADMINISTRATOR)
```powershell
# Open PowerShell as Administrator, then run:
cd C:\Development\DevOps\DevOpsStack_RandD
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
.\iis-hosting\Configure-IIS-Localhost.ps1
```

### Step 3: Set Folder Permissions
```powershell
# Run as Administrator
$path = "C:\iis-apps\devopsstack"
$acl = Get-Acl -Path $path

# Add IIS_IUSRS permissions
$permission = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "IIS_IUSRS",
    "FullControl",
    "ContainerInherit,ObjectInherit",
    "None",
    "Allow"
)
$acl.SetAccessRule($permission)
Set-Acl -Path $path -AclObject $acl

Write-Host "✓ IIS permissions configured"
```

### Step 4: Test Access
Open browser and visit:
- **verify.html**: http://localhost:8082/verify.html
- **API**: http://localhost:8082/api/cipeline/info
- **Swagger**: http://localhost:8082/swagger/index.html

## Manual IIS Manager Configuration (Alternative)

If you prefer to configure manually:

1. **Create Application Pool**:
   - Open IIS Manager
   - Right-click "Application Pools" → "Add Application Pool"
   - Name: `DevOpsStack`
   - .NET CLR Version: `No Managed Code`
   - Managed Pipeline Mode: `Integrated`
   - Click OK, then Start it

2. **Create Website**:
   - Right-click "Sites" → "Add Website"
   - Site name: `DevOpsStack`
   - Physical path: `C:\iis-apps\devopsstack`
   - Binding protocol: `http`
   - IP address: `All Unassigned`
   - Port: `8082`
   - Hostname: `localhost`
   - Application pool: `DevOpsStack`
   - Click OK, then Start

3. **Configure Default Documents**:
   - Select the `DevOpsStack` site
   - Double-click "Default Document"
   - Add `verify.html` and move it to the top
   - Click "Apply"

4. **Enable Static Content**:
   - Select the `DevOpsStack` site
   - Double-click "MIME Types"
   - Verify `.html` is set to `text/html`
   - If not, click "Add", file extension: `.html`, MIME type: `text/html`

5. **Set Permissions**:
   - Right-click `C:\iis-apps\devopsstack` folder
   - Properties → Security → Edit
   - Add `IIS_IUSRS` with Full Control

## Troubleshooting

### Still Getting 404?

Check these IIS logs:
```powershell
# Check IIS logs
Get-Content "C:\inetpub\logs\LogFiles\W3SVC1\*.log" -Tail 20

# Check application logs
Get-Content "C:\iis-apps\devopsstack\logs\stdout*" -ErrorAction SilentlyContinue
```

### Application returns 500 error?

Enable detailed errors:
```powershell
Set-WebConfigurationProperty -PSPath "IIS:\Sites\DevOpsStack" -Filter "system.webServer/httpErrors" -Name "errorMode" -Value "Detailed"
```

Then check logs in `C:\iis-apps\devopsstack\logs\`

### Verify Application is Running

```powershell
# Check if site is running
Get-WebsiteState -Name "DevOpsStack"

# Check if app pool is running
Get-WebAppPoolState -Name "DevOpsStack"

# Check listening ports
netstat -ano | findstr :8082
```

## What We Fixed

✅ **Moved verify.html to wwwroot** - Required for static file serving  
✅ **Created IIS configuration script** - Automates app pool & site setup  
✅ **Port 8082 binding** - Configured for localhost  
✅ **Default documents** - verify.html will load by default  
✅ **Static content enabled** - HTML files will be served properly  

## Expected Behavior After Fix

After following these steps:
- `http://localhost:8082/` → loads verify.html ✓
- `http://localhost:8082/verify.html` → loads verify.html ✓
- `http://localhost:8082/api/cipeline/info` → returns JSON ✓
