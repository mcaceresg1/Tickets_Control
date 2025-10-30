@echo off
echo ========================================
echo   REINICIANDO API (Node.js)
echo ========================================
echo.
echo Deteniendo procesos de Node.js...
powershell -Command "Get-Process | Where-Object { $_.ProcessName -eq 'node' } | Stop-Process -Force"
echo.
echo Iniciando API con el script...
start "" powershell -ExecutionPolicy Bypass -File "C:\WS_Tickets_Control\Tickets-Backend\start-api.ps1"
echo.
echo API reiniciada. Esperando 10 segundos...
timeout /t 10 /nobreak
echo.
echo Abriendo API para probar...
start http://localhost:3000/api
echo.
echo ========================================
echo   LISTO
echo ========================================
echo.
pause

