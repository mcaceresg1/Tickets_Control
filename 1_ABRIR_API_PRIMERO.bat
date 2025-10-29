@echo off
echo ========================================
echo   PASO 1: INICIANDO API (Node.js)
echo ========================================
echo.
echo Deteniendo procesos previos...
powershell -Command "Get-Process | Where-Object { $_.ProcessName -eq 'node' } | Stop-Process -Force -ErrorAction SilentlyContinue"
echo.
echo Iniciando API...
start "" powershell -ExecutionPolicy Bypass -File "C:\WS_Tickets_Control\Tickets-Api\start-api.ps1"
echo.
echo Esperando 10 segundos a que la API inicie...
timeout /t 10 /nobreak
echo.
echo Abriendo API en el navegador...
start http://localhost:3000/api
echo.
echo ========================================
echo   IMPORTANTE
echo ========================================
echo.
echo 1. Deberas ver un JSON con la info de la API
echo 2. MANTEN ESTA VENTANA DE POWERSHELL ABIERTA (la azul)
echo 3. Si ves el JSON, la API esta funcionando correctamente
echo 4. Luego ejecuta: ABRIR_FRONTEND.bat
echo.
pause

