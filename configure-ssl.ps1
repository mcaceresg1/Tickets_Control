# Script de Configuración SSL - Sistema de Tickets
# Ejecutar como Administrador

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  Configuración SSL - Sistema de Tickets" -ForegroundColor Cyan
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
$apiSiteName = "SisTickets-API"
$webSiteName = "SisTickets-Web"
$apiPort = 3000
$webPort = 4200
$apiHostName = "tk.nexwork-peru.com"
$webHostName = "tk.nexwork-peru.com"

# Verificar módulos de IIS
Write-Host "[1/5] Verificando módulos de IIS..." -ForegroundColor Yellow

Import-Module WebAdministration -ErrorAction SilentlyContinue

if (-not (Get-Module -Name WebAdministration)) {
    Write-Host "ERROR: Módulo WebAdministration no disponible. Asegúrese de que IIS está instalado." -ForegroundColor Red
    exit 1
}

Write-Host "  ✓ Módulo WebAdministration cargado" -ForegroundColor Green
Write-Host ""

# Verificar que los sitios existen
Write-Host "[2/5] Verificando sitios web..." -ForegroundColor Yellow

if (-not (Test-Path "IIS:\Sites\$apiSiteName")) {
    Write-Host "ERROR: Sitio $apiSiteName no existe. Ejecute primero deploy-api.ps1" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "IIS:\Sites\$webSiteName")) {
    Write-Host "ERROR: Sitio $webSiteName no existe. Ejecute primero deploy-web.ps1" -ForegroundColor Red
    exit 1
}

Write-Host "  ✓ Sitios web verificados" -ForegroundColor Green
Write-Host ""

# Listar certificados disponibles
Write-Host "[3/5] Certificados SSL disponibles:" -ForegroundColor Yellow

$certificates = Get-ChildItem -Path "Cert:\LocalMachine\My" | Where-Object { $_.Subject -like "*nexwork-peru.com*" -or $_.Subject -like "*tk.nexwork-peru.com*" }

if ($certificates.Count -eq 0) {
    Write-Host "  ⚠ ADVERTENCIA: No se encontraron certificados para nexwork-peru.com" -ForegroundColor Yellow
    Write-Host "  Debe importar los certificados SSL antes de continuar" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Para importar certificados:" -ForegroundColor Gray
    Write-Host "  1. Abra IIS Manager" -ForegroundColor Gray
    Write-Host "  2. Vaya a Server Certificates" -ForegroundColor Gray
    Write-Host "  3. Import Certificate" -ForegroundColor Gray
    Write-Host "  4. Seleccione el archivo .pfx" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host "  ✓ Certificados encontrados:" -ForegroundColor Green
    foreach ($cert in $certificates) {
        Write-Host "    - $($cert.Subject) (Expira: $($cert.NotAfter))" -ForegroundColor Gray
    }
}

Write-Host ""

# Configurar HTTPS bindings
Write-Host "[4/5] Configurando bindings HTTPS..." -ForegroundColor Yellow

# API Site HTTPS Binding
try {
    $apiCert = $certificates | Where-Object { $_.Subject -like "*tk.nexwork-peru.com*" -or $_.Subject -like "*nexwork-peru.com*" } | Select-Object -First 1
    
    if ($apiCert) {
        New-WebBinding -Name $apiSiteName -Protocol "https" -Port $apiPort -HostHeader $apiHostName -SslFlags 1
        $binding = Get-WebBinding -Name $apiSiteName -Protocol "https" -Port $apiPort
        $binding.AddSslCertificate($apiCert.Thumbprint, "my")
        Write-Host "  ✓ HTTPS configurado para API ($apiHostName`:$apiPort)" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ No se pudo configurar HTTPS para API - certificado no encontrado" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ⚠ Error configurando HTTPS para API: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Web Site HTTPS Binding
try {
    $webCert = $certificates | Where-Object { $_.Subject -like "*tk.nexwork-peru.com*" -or $_.Subject -like "*nexwork-peru.com*" } | Select-Object -First 1
    
    if ($webCert) {
        New-WebBinding -Name $webSiteName -Protocol "https" -Port $webPort -HostHeader $webHostName -SslFlags 1
        $binding = Get-WebBinding -Name $webSiteName -Protocol "https" -Port $webPort
        $binding.AddSslCertificate($webCert.Thumbprint, "my")
        Write-Host "  ✓ HTTPS configurado para Web ($webHostName`:$webPort)" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ No se pudo configurar HTTPS para Web - certificado no encontrado" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ⚠ Error configurando HTTPS para Web: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""

# Verificar configuración final
Write-Host "[5/5] Verificando configuración final..." -ForegroundColor Yellow

Write-Host "  Bindings configurados:" -ForegroundColor Gray

# API Bindings
$apiBindings = Get-WebBinding -Name $apiSiteName
foreach ($binding in $apiBindings) {
    $protocol = $binding.protocol
    $port = $binding.bindingInformation.Split(':')[1]
    $host = $binding.bindingInformation.Split(':')[2]
    Write-Host "    API: $protocol`://$host`:$port" -ForegroundColor Gray
}

# Web Bindings
$webBindings = Get-WebBinding -Name $webSiteName
foreach ($binding in $webBindings) {
    $protocol = $binding.protocol
    $port = $binding.bindingInformation.Split(':')[1]
    $host = $binding.bindingInformation.Split(':')[2]
    Write-Host "    Web: $protocol`://$host`:$port" -ForegroundColor Gray
}

Write-Host ""

# Resumen
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  CONFIGURACIÓN SSL COMPLETADA" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "URLs HTTPS configuradas:" -ForegroundColor White
Write-Host "  API:  https://$apiHostName`:$apiPort/api" -ForegroundColor White
Write-Host "  Web:  https://$webHostName`:$webPort" -ForegroundColor White
Write-Host ""
Write-Host "NOTAS IMPORTANTES:" -ForegroundColor Yellow
Write-Host "- Los redirects HTTP a HTTPS están configurados en web.config" -ForegroundColor Yellow
Write-Host "- Verifique que los certificados SSL sean válidos" -ForegroundColor Yellow
Write-Host "- Los headers de seguridad están configurados" -ForegroundColor Yellow
Write-Host "- HSTS está habilitado para mayor seguridad" -ForegroundColor Yellow
Write-Host ""
Write-Host "Presione cualquier tecla para salir..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
