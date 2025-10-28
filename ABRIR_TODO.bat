@echo off
echo ========================================
echo   ABRIENDO API Y FRONTEND EN EDGE
echo ========================================
echo.
echo Paso 1: Abriendo API...
start msedge https://apitk.nexwork-peru.com:3000/api
timeout /t 3 /nobreak
echo.
echo Paso 2: Abriendo Frontend...
start msedge https://tk.nexwork-peru.com:4200/
echo.
echo ========================================
echo   INSTRUCCIONES
echo ========================================
echo.
echo 1. Acepta el certificado SSL en AMBAS pestañas
echo 2. En la pestaña del frontend, haz login
echo 3. Deberia funcionar correctamente
echo.
pause

