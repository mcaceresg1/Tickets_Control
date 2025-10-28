@echo off
echo ========================================
echo   REINICIANDO API
echo ========================================
echo.
powershell -Command "Import-Module WebAdministration; Restart-WebAppPool -Name 'SisTickets-API-Pool'"
echo.
echo API reiniciada. Esperando 5 segundos...
timeout /t 5 /nobreak
echo.
echo Abriendo API para probar...
start https://apitp.nexwork-peru.com:3000/api
echo.
echo ========================================
echo   LISTO
echo ========================================
echo.
pause

