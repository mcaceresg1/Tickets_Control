# Script para compilar y publicar el frontend a IIS
# Autor: Sistema de Tickets
# Fecha: 2025-10-31

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  PUBLICAR FRONTEND - SISTEMA TICKETS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Navegar a la carpeta del frontend
$frontendPath = "C:\WS_Tickets_Control\Tickets-Frontend"
if (-not (Test-Path $frontendPath)) {
    Write-Host "❌ ERROR: No se encuentra la carpeta del frontend: $frontendPath" -ForegroundColor Red
    exit 1
}

Set-Location $frontendPath

Write-Host "📁 Directorio actual: $(Get-Location)" -ForegroundColor Yellow
Write-Host ""

# Paso 1: Verificar configuración de IIS
Write-Host "🔍 Verificando configuración de IIS..." -ForegroundColor Cyan
try {
    $website = Get-WebSite -Name "Tickets_Frontend" -ErrorAction Stop
    $iisPath = $website.physicalPath
    Write-Host "✅ IIS configurado apuntando a: $iisPath" -ForegroundColor Green
} catch {
    Write-Host "❌ ERROR: No se encuentra el sitio IIS 'Tickets_Frontend'" -ForegroundColor Red
    Write-Host "   Verifica que el sitio esté creado en IIS Manager" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Paso 2: Compilar el proyecto
Write-Host "🔨 Compilando proyecto Angular..." -ForegroundColor Cyan
Write-Host "   (Esto puede tomar varios minutos)" -ForegroundColor Yellow
Write-Host ""

npm run build -- --configuration production

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ ERROR: La compilación falló" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ Compilación completada exitosamente" -ForegroundColor Green
Write-Host ""

# Paso 3: Verificar que existe la carpeta de salida
$distPath = "dist\sis-tickets-frontend\browser"
if (-not (Test-Path $distPath)) {
    Write-Host "❌ ERROR: No se encuentra la carpeta de salida: $distPath" -ForegroundColor Red
    exit 1
}

# Paso 4: Copiar archivos a IIS
Write-Host "📦 Copiando archivos a IIS..." -ForegroundColor Cyan
Write-Host "   Origen: $frontendPath\$distPath" -ForegroundColor Yellow
Write-Host "   Destino: $iisPath" -ForegroundColor Yellow
Write-Host ""

# Asegurar que la carpeta de destino existe
if (-not (Test-Path $iisPath)) {
    Write-Host "⚠️  La carpeta de destino no existe, creándola..." -ForegroundColor Yellow
    New-Item -Path $iisPath -ItemType Directory -Force | Out-Null
}

# Copiar archivos
try {
    Copy-Item -Path "$frontendPath\$distPath\*" -Destination $iisPath -Recurse -Force
    Write-Host "✅ Archivos copiados exitosamente" -ForegroundColor Green
} catch {
    Write-Host "❌ ERROR al copiar archivos: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Paso 5: Reciclar Application Pool (opcional)
Write-Host "🔄 ¿Deseas reciclar el Application Pool? (S/N)" -ForegroundColor Cyan
$reciclar = Read-Host
if ($reciclar -eq "S" -or $reciclar -eq "s" -or $reciclar -eq "Y" -or $reciclar -eq "y") {
    try {
        $appPool = Get-WebAppPoolState -Name "Tickets_Frontend_Pool" -ErrorAction SilentlyContinue
        if ($appPool) {
            Restart-WebAppPool -Name "Tickets_Frontend_Pool"
            Write-Host "✅ Application Pool reciclado" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Application Pool 'Tickets_Frontend_Pool' no encontrado" -ForegroundColor Yellow
            Write-Host "   Verifica el nombre del Application Pool en IIS Manager" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "⚠️  No se pudo reciclar el Application Pool: $_" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ✅ PUBLICACIÓN COMPLETADA" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 RESUMEN:" -ForegroundColor Yellow
Write-Host "   - Proyecto compilado: ✅" -ForegroundColor White
Write-Host "   - Archivos copiados a: $iisPath" -ForegroundColor White
Write-Host "   - Sitio IIS: Tickets_Frontend" -ForegroundColor White
Write-Host ""
Write-Host "🌐 URL: https://tk.nexwork-peru.com" -ForegroundColor Cyan
Write-Host ""

