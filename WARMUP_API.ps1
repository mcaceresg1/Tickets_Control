# Script de Warmup para mantener la API activa
Write-Host "Calentando API..." -ForegroundColor Yellow

# Esperar a que IIS esté listo
Start-Sleep -Seconds 5

# Hacer petición a la API para iniciarla
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api" -Method GET -UseBasicParsing -TimeoutSec 30 -ErrorAction Stop
    Write-Host "API iniciada correctamente - Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "Intentando con HTTPS..." -ForegroundColor Yellow
    try {
        # Ignorar errores de certificado para el warmup local
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
        $response = Invoke-WebRequest -Uri "https://localhost:3000/api" -Method GET -UseBasicParsing -TimeoutSec 30 -ErrorAction Stop
        Write-Host "API iniciada con HTTPS - Status: $($response.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "Error al iniciar API: $_" -ForegroundColor Red
    }
}

Write-Host "Warmup completado" -ForegroundColor Cyan

