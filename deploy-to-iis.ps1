# Script de Deployment para IIS - Sistema de Tickets
# Ejecutar como Administrador

$ErrorActionPreference = "Continue"

$deployPath = "C:\inetpub\wwwroot\Tickets_Control"
$apiSource = "C:\WS_Tickets_Control\Tickets-Api\dist"
$webSource = "C:\WS_Tickets_Control\Tickets-Web\dist\sis-tickets-frontend"
$certSource = "C:\WS_Tickets_Control\Tickets-Web\cettificado_ssl\certificado.pfx"

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  DEPLOYMENT A IIS - tk.nexwork-peru.com" -ForegroundColor Yellow
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# Paso 1: Limpiar directorio de deployment
Write-Host "[1/5] Limpiando directorio de deployment..." -ForegroundColor Yellow
if (Test-Path $deployPath) {
    Remove-Item "$deployPath\*" -Recurse -Force -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Path "$deployPath\api" -Force | Out-Null
New-Item -ItemType Directory -Path "$deployPath\web" -Force | Out-Null
Write-Host "  ✓ Directorio limpiado" -ForegroundColor Green
Write-Host ""

# Paso 2: Copiar API
Write-Host "[2/5] Copiando archivos de la API..." -ForegroundColor Yellow
Copy-Item "$apiSource\*" -Destination "$deployPath\api" -Recurse -Force -Exclude "node_modules"
if (Test-Path "$apiSource\node_modules") {
    Copy-Item "$apiSource\node_modules" -Destination "$deployPath\api" -Recurse -Force
} elseif (Test-Path "C:\WS_Tickets_Control\Tickets-Api\node_modules") {
    Copy-Item "C:\WS_Tickets_Control\Tickets-Api\node_modules" -Destination "$deployPath\api" -Recurse -Force
}
Write-Host "  ✓ API copiada" -ForegroundColor Green
Write-Host ""

# Paso 3: Copiar Frontend
Write-Host "[3/5] Copiando archivos del Frontend..." -ForegroundColor Yellow
if (Test-Path "$webSource\browser") {
    Copy-Item "$webSource\browser\*" -Destination "$deployPath\web" -Recurse -Force
} else {
    $files = Get-ChildItem $webSource -File | Where-Object { $_.Extension -ne ".map" }
    foreach ($file in $files) {
        Copy-Item $file.FullName -Destination "$deployPath\web" -Force
    }
    $dirs = Get-ChildItem $webSource -Directory
    foreach ($dir in $dirs) {
        Copy-Item $dir.FullName -Destination "$deployPath\web" -Recurse -Force
    }
}
Copy-Item "C:\WS_Tickets_Control\Tickets-Web\web.config" -Destination "$deployPath\web\web.config" -Force
Write-Host "  ✓ Frontend copiado" -ForegroundColor Green
Write-Host ""

# Paso 4: Copiar certificado SSL
Write-Host "[4/5] Copiando certificado SSL..." -ForegroundColor Yellow
if (Test-Path $certSource) {
    Copy-Item $certSource -Destination "$deployPath\api\certificado.pfx" -Force
    Write-Host "  ✓ Certificado copiado" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Certificado no encontrado en: $certSource" -ForegroundColor Yellow
}
Write-Host ""

# Paso 5: Configurar IIS
Write-Host "[5/5] Configurando IIS..." -ForegroundColor Yellow
Import-Module WebAdministration

$siteName = "Tickets_Control_Web"
$appPoolName = "Tickets_Control_Web"

# Crear o actualizar Application Pool
if (Test-Path "IIS:\AppPools\$appPoolName") {
    Stop-WebAppPool -Name $appPoolName -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
} else {
    New-WebAppPool -Name $appPoolName
}

Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "managedRuntimeVersion" -Value "" | Out-Null
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "processModel.identityType" -Value "ApplicationPoolIdentity" | Out-Null

# Crear o actualizar sitio web
if (Test-Path "IIS:\Sites\$siteName") {
    Remove-Website -Name $siteName -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

New-Website -Name $siteName `
    -PhysicalPath "$deployPath\web" `
    -ApplicationPool $appPoolName `
    -Port 80 `
    -HostHeader "tk.nexwork-peru.com" `
    -Force | Out-Null

# Configurar bindings HTTPS
$httpsBinding = Get-WebBinding -Name $siteName -Protocol https -ErrorAction SilentlyContinue
if (-not $httpsBinding) {
    New-WebBinding -Name $siteName -Protocol https -Port 443 -HostHeader "tk.nexwork-peru.com" | Out-Null
}

# Asociar certificado SSL
$thumbprint = "B82D3E07C67DB5A4DAFF9D73990B0E1B9F152101"
$cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Thumbprint -eq $thumbprint }
if ($cert) {
    $binding = Get-WebBinding -Name $siteName -Protocol https -Port 443 -ErrorAction SilentlyContinue
    if ($binding) {
        try {
            $binding.AddSslCertificate($thumbprint, "my")
            Write-Host "  ✓ Certificado SSL asociado" -ForegroundColor Green
        } catch {
            Write-Host "  ⚠ Error al asociar certificado: $_" -ForegroundColor Yellow
        }
    }
}

# Configurar autenticación anónima
Set-WebConfigurationProperty -Filter "/system.webServer/security/authentication/anonymousAuthentication" -Name enabled -Value $true -PSPath "IIS:\Sites\$siteName" | Out-Null

# Iniciar Application Pool y Sitio
Start-WebAppPool -Name $appPoolName
Start-Website -Name $siteName

Write-Host "  ✓ IIS configurado" -ForegroundColor Green
Write-Host ""

# Resumen
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  DEPLOYMENT COMPLETADO" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Sitio Web:" -ForegroundColor Yellow
Write-Host "  Nombre: $siteName" -ForegroundColor White
Write-Host "  URL: http://tk.nexwork-peru.com" -ForegroundColor White
Write-Host "  URL HTTPS: https://tk.nexwork-peru.com" -ForegroundColor White
Write-Host "  Ruta física: $deployPath\web" -ForegroundColor White
Write-Host ""
Write-Host "API:" -ForegroundColor Yellow
Write-Host "  Ruta: $deployPath\api" -ForegroundColor White
Write-Host "  Puerto: 3000 (ejecutar manualmente)" -ForegroundColor White
Write-Host ""
Write-Host "Archivos desplegados: $((Get-ChildItem $deployPath -Recurse -File | Measure-Object).Count)" -ForegroundColor Cyan
Write-Host ""

