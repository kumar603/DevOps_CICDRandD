Import-Module WebAdministration

$appPoolName = "DevOpsStack"
$siteName = "DevOpsStack"
$physicalPath = "C:\iis-apps\devopsstack"
$port = 8082
$bindingHost = "localhost"

Write-Host "========================================"
Write-Host "IIS Configuration for DevOpsStack"
Write-Host "========================================"
Write-Host ""

Write-Host "[1] Creating Application Pool..."
if (-not (Test-Path "IIS:\AppPools\$appPoolName")) {
    New-WebAppPool -Name $appPoolName
} else {
    Write-Host "    (Already exists)"
}

Write-Host "[2] Configuring Application Pool..."
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "managedRuntimeVersion" -Value ""
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "managedPipelineMode" -Value "Integrated"
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "autoStart" -Value $true

Write-Host "[3] Starting Application Pool..."
$poolState = (Get-WebAppPoolState -Name $appPoolName).Value
if ($poolState -ne "Started") {
    Start-WebAppPool -Name $appPoolName
}

Write-Host "[4] Creating Website..."
if (-not (Test-Path "IIS:\Sites\$siteName")) {
    New-Website -Name $siteName -PhysicalPath $physicalPath -Port $port -HostHeader $bindingHost -ApplicationPool $appPoolName
} else {
    Write-Host "    (Already exists)"
}

Write-Host "[5] Assigning Application Pool..."
Set-ItemProperty "IIS:\Sites\$siteName" -Name "applicationPool" -Value $appPoolName

Write-Host "[6] Starting Website..."
$siteState = (Get-WebsiteState -Name $siteName).Value
if ($siteState -ne "Started") {
    Start-Website -Name $siteName
}

Write-Host "[7] Configuring Default Documents..."
Remove-WebConfigurationProperty -PSPath "IIS:\Sites\$siteName" -Filter "system.webServer/defaultDocument/files/*" -ErrorAction SilentlyContinue

$defaultDocs = @("index.html", "verify.html", "default.html", "index.htm")
foreach ($doc in $defaultDocs) {
    Add-WebConfigurationProperty -PSPath "IIS:\Sites\$siteName" -Filter "system.webServer/defaultDocument/files" -Name "." -Value @{value=$doc}
}

Write-Host "[8] Enabling Static Content..."
Set-WebConfigurationProperty -PSPath "IIS:\Sites\$siteName" -Filter "system.webServer/staticContent" -Name "enabled" -Value $true

Write-Host ""
Write-Host "========================================"
Write-Host "Configuration Complete!"
Write-Host "========================================"
Write-Host ""
Write-Host "Test in browser:"
Write-Host "  http://localhost:8082/verify.html"
Write-Host ""
