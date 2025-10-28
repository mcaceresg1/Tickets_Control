# Script para limpiar caché y abrir el frontend
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  LIMPIAR CACHE Y ABRIR FRONTEND" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Cerrar todos los navegadores Edge
Write-Host "1. Cerrando todos los navegadores Edge..." -ForegroundColor Yellow
Get-Process msedge -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Limpiar caché de Edge
Write-Host "2. Limpiando cache de Edge..." -ForegroundColor Yellow
$edgeCachePaths = @(
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\Cache_Data",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Code Cache",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Service Worker\CacheStorage"
)

foreach ($path in $edgeCachePaths) {
    if (Test-Path $path) {
        Remove-Item -Path "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "   - Limpiado: $path" -ForegroundColor Gray
    }
}

Write-Host "3. Esperando..." -ForegroundColor Yellow
Start-Sleep -Seconds 2

# Abrir en modo incógnito
Write-Host "4. Abriendo frontend en modo incognito..." -ForegroundColor Yellow
Start-Process msedge -ArgumentList "-inprivate","https://tk.nexwork-peru.com:4200/"

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "  LISTO!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "El frontend se abrió en modo incognito." -ForegroundColor White
Write-Host ""
Write-Host "IMPORTANTE:" -ForegroundColor Yellow
Write-Host "1. Acepta el certificado SSL" -ForegroundColor White
Write-Host "2. Abre la consola (F12)" -ForegroundColor White
Write-Host "3. Verifica que AHORA use: https://apitk.nexwork-peru.com:3000" -ForegroundColor White
Write-Host ""
pause

