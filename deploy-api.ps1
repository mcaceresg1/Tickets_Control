# Script de Despliegue - API de Tickets
# Ejecutar como Administrador

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  Despliegue de API - Sistema de Tickets" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si se está ejecutando como administrador
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: Este script debe ejecutarse como Administrador" -ForegroundColor Red
    Write-Host "Click derecho en PowerShell y seleccione 'Ejecutar como Administrador'" -ForegroundColor Yellow
    exit 1
}

# Variables
$projectPath = "C:\WS_Tickets_Control\Sis.Tickets-Api"
$siteName = "SisTickets-API"
$appPoolName = "SisTickets-API-Pool"
$port = 3000
$hostName = "apitk.nexwork-peru.com"

# Paso 1: Compilar el proyecto
Write-Host "[1/6] Compilando proyecto TypeScript..." -ForegroundColor Yellow
Set-Location $projectPath

# Instalar dependencias
Write-Host "  - Instalando dependencias..." -ForegroundColor Gray
npm install

# Compilar
Write-Host "  - Compilando..." -ForegroundColor Gray
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Falló la compilación del proyecto" -ForegroundColor Red
    exit 1
}

Write-Host "  ✓ Proyecto compilado exitosamente" -ForegroundColor Green
Write-Host ""

# Paso 2: Verificar módulos de IIS
Write-Host "[2/6] Verificando módulos de IIS..." -ForegroundColor Yellow

Import-Module WebAdministration -ErrorAction SilentlyContinue

if (-not (Get-Module -Name WebAdministration)) {
    Write-Host "ERROR: Módulo WebAdministration no disponible. Asegúrese de que IIS está instalado." -ForegroundColor Red
    exit 1
}

Write-Host "  ✓ Módulo WebAdministration cargado" -ForegroundColor Green
Write-Host ""

# Paso 3: Crear Application Pool si no existe
Write-Host "[3/6] Configurando Application Pool..." -ForegroundColor Yellow

if (Test-Path "IIS:\AppPools\$appPoolName") {
    Write-Host "  - Application Pool ya existe, deteniéndolo..." -ForegroundColor Gray
    Stop-WebAppPool -Name $appPoolName -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
} else {
    Write-Host "  - Creando Application Pool..." -ForegroundColor Gray
    New-WebAppPool -Name $appPoolName
}

# Configurar Application Pool
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "managedRuntimeVersion" -Value ""
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "managedPipelineMode" -Value "Integrated"
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "processModel.identityType" -Value "ApplicationPoolIdentity"
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "processModel.loadUserProfile" -Value $false
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "processModel.idleTimeout" -Value "00:20:00"
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "recycling.periodicRestart.time" -Value "00:00:00"
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "recycling.periodicRestart.memory" -Value 0
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "recycling.periodicRestart.requests" -Value 0
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "recycling.periodicRestart.schedule" -Value @()
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "recycling.disallowOverlappingRotation" -Value $true
Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name "recycling.disallowRotationOnConfigChange" -Value $false

Write-Host "  ✓ Application Pool configurado" -ForegroundColor Green
Write-Host ""

# Paso 4: Crear o actualizar sitio web
Write-Host "[4/6] Configurando sitio web en IIS..." -ForegroundColor Yellow

$physicalPath = Join-Path $projectPath "dist"

if (Test-Path "IIS:\Sites\$siteName") {
    Write-Host "  - Sitio ya existe, actualizando configuración..." -ForegroundColor Gray
    Remove-Website -Name $siteName
    Start-Sleep -Seconds 2
}

Write-Host "  - Creando sitio web..." -ForegroundColor Gray
Write-Host "    Ruta física: $physicalPath" -ForegroundColor Gray
Write-Host "    Puerto: $port" -ForegroundColor Gray
Write-Host "    Host: $hostName" -ForegroundColor Gray

# Crear sitio con binding HTTP (cambiar a HTTPS manualmente con certificado)
New-Website -Name $siteName `
    -PhysicalPath $physicalPath `
    -ApplicationPool $appPoolName `
    -Port $port `
    -HostHeader $hostName `
    -Force

Write-Host "  ✓ Sitio web configurado" -ForegroundColor Green
Write-Host ""

# Paso 5: Configurar permisos
Write-Host "[5/6] Configurando permisos de carpeta..." -ForegroundColor Yellow

$acl = Get-Acl $physicalPath
$permissions = @("IIS_IUSRS", "IUSR")

foreach ($user in $permissions) {
    Write-Host "  - Agregando permisos para $user..." -ForegroundColor Gray
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        $user, "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow"
    )
    $acl.AddAccessRule($rule)
}

Set-Acl $physicalPath $acl
Write-Host "  ✓ Permisos configurados" -ForegroundColor Green
Write-Host ""

# Paso 6: Iniciar sitio
Write-Host "[6/6] Iniciando sitio web..." -ForegroundColor Yellow

Start-WebAppPool -Name $appPoolName
Start-Website -Name $siteName

Write-Host "  ✓ Sitio iniciado" -ForegroundColor Green
Write-Host ""

# Resumen
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  DESPLIEGUE COMPLETADO" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Sitio: $siteName" -ForegroundColor White
Write-Host "Puerto: $port" -ForegroundColor White
Write-Host "URL: http://$hostName`:$port" -ForegroundColor White
Write-Host ""
Write-Host "NOTA IMPORTANTE:" -ForegroundColor Yellow
Write-Host "- Para usar HTTPS, configure manualmente el certificado SSL en IIS" -ForegroundColor Yellow
Write-Host "- Verifique que el archivo .env existe en: $projectPath" -ForegroundColor Yellow
Write-Host "- Verifique los logs en: $physicalPath\iisnode" -ForegroundColor Yellow
Write-Host ""
Write-Host "Presione cualquier tecla para salir..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

