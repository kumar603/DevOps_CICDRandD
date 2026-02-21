# IIS Hosting Setup Instructions for DevOpsStack

## Prerequisites
- Windows Server with IIS installed
- .NET Core 8 Hosting Bundle installed
- Administrative access to IIS Manager

## Installation Steps

### 1. Install .NET Core 8 Hosting Bundle
Download and install from: https://dotnet.microsoft.com/en-us/download/dotnet/8.0
Select the "Hosting Bundle" for Windows Server

### 2. Create Application Pool in IIS

```
IIS Manager > Application Pools > Add Application Pool
Name: DevOpsStack
.NET CLR Version: No Managed Code
Managed Pipeline Mode: Integrated
```

### 3. Deploy Application Files

1. Publish the application:
   ```bash
   dotnet publish src\DevopsStack.API\DevopsStack.API.csproj -c Release -o C:\iis-apps\devopsstack
   ```

2. Copy the `web.config` from `iis-hosting\` folder to the published application root

3. Create a `logs` folder for stdout logging

### 4. Create Website in IIS

```
IIS Manager > Sites > Add Website
Site Name: DevOpsStack
Physical Path: C:\iis-apps\devopsstack
Binding: 
  - Type: http
  - IP Address: All Unassigned
  - Port: 80
  - Hostname: devopsstack.local
```

### 5. Assign Application Pool

Right-click Website > Edit Binding > Select "DevOpsStack" Application Pool

### 6. Configure Permissions

Grant IIS_IUSRS full control on:
- `C:\iis-apps\devopsstack` folder
- `C:\iis-apps\devopsstack\logs` folder

### 7. Start Website

In IIS Manager, right-click the website and click "Start"

### 8. Test

Navigate to: `http://devopsstack.local/api/cipeline/info`

## Deployment for Updates

When new versions are released:

1. Stop the website in IIS
2. Backup current files
3. Copy new published files
4. Start the website

## Health Check Endpoint

Use this endpoint to monitor the application:
```
GET http://devopsstack.local/api/cipeline/info
```

Expected response:
```json
{
  "application": "DevOpsStack CI/CD Demo",
  "version": "1.0.0",
  "status": "Running",
  "framework": "ASP.NET Core 8",
  "timestamp": "2026-02-19T..."
}
```

## Troubleshooting

### Application fails to start
- Check IIS logs: `C:\inetpub\logs\LogFiles`
- Check application logs: `C:\iis-apps\devopsstack\logs`
- Ensure .NET Core 8 Hosting Bundle is installed

### 500 errors
- Enable detailed error messages in IIS (Development only)
- Check the logs folder for stdout logs

### Permission issues
- Verify IIS_IUSRS has Full Control on application folder
- Check file ownership
