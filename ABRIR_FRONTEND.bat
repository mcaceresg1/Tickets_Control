@echo off
echo Abriendo Frontend en modo incognito...
start msedge --inprivate https://tk.nexwork-peru.com:4200/
timeout /t 2
echo.
echo ========================================
echo   Frontend abierto en modo incognito
echo ========================================
echo.
echo IMPORTANTE:
echo - Acepta el certificado SSL cuando aparezca
echo - El frontend ahora usa: https://apitk.nexwork-peru.com:3000/api
echo.
pause

