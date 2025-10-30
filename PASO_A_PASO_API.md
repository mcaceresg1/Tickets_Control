# 🚀 GUÍA PASO A PASO - DESPLIEGUE DE LA API EN IIS

## ✅ PASO 1: VERIFICAR REQUISITOS PREVIOS

### 1.1 Verificar que Node.js está instalado

Abre **PowerShell** y ejecuta:

```powershell
node --version
npm --version
```

✔️ Deberías ver algo como: `v18.x.x` o superior  
❌ Si no está instalado, descarga desde: https://nodejs.org/

---

### 1.2 Verificar que IIS está instalado

1. Presiona `Win + R`
2. Escribe: `inetmgr` y presiona Enter
3. Debería abrirse el **IIS Manager**

❌ Si no está instalado:
- Ve a: Panel de Control → Programas → Activar o desactivar características de Windows
- Marca: **Internet Information Services**
- Click en Aceptar

---

### 1.3 Instalar iisnode

**¿Qué es iisnode?** Es un módulo que permite ejecutar aplicaciones Node.js en IIS.

1. Descarga desde: https://github.com/Azure/iisnode/releases
2. Busca la versión más reciente (ejemplo: `iisnode-full-v0.2.x-x64.msi`)
3. Descarga e instala el archivo `.msi`
4. Reinicia IIS después de instalar

**Para reiniciar IIS:**
```powershell
# Ejecutar como Administrador
iisreset
```

---

### 1.4 Instalar URL Rewrite Module

1. Descarga desde: https://www.iis.net/downloads/microsoft/url-rewrite
2. Instala el módulo
3. Reinicia IIS

```powershell
iisreset
```

---

## ✅ PASO 2: PREPARAR EL PROYECTO

### 2.1 Instalar dependencias

Abre **PowerShell** (como usuario normal, NO como administrador):

```powershell
cd C:\WS_Tickets_Control\Tickets-Backend
npm install
```

Espera a que termine de instalar todas las dependencias.

---

### 2.2 Compilar el proyecto TypeScript

```powershell
npm run build
```

✔️ Deberías ver: "Compilation successful"  
✔️ Se debe crear la carpeta `dist` con los archivos JavaScript compilados

**Verificar que la carpeta dist existe:**
```powershell
dir dist
```

---

### 2.3 Crear archivo .env

Crea el archivo `.env` en la raíz del proyecto `C:\WS_Tickets_Control\Tickets-Backend\.env`

Puedes usar el Bloc de notas:

```powershell
notepad .env
```

Pega este contenido (ajusta los valores según tu configuración):

```env
NODE_ENV=production
PORT=3000
API_PREFIX=/api

# Base de datos
DB_SERVER=161.132.56.68
DB_NAME=DB_A64885_tickets
DB_USER=sa
DB_PASSWORD=TuPasswordAqui
DB_PORT=1433
DB_ENCRYPT=false
DB_TRUST_CERT=true

# CORS
CORS_ORIGIN=https://tk.nexwork-peru.com:4200

# JWT - IMPORTANTE: Cambia este secret por uno seguro
JWT_SECRET=tu-clave-super-secreta-cambiar-en-produccion-123456
JWT_EXPIRES_IN=24h

# Frontend URL
FRONTEND_URL=https://tk.nexwork-peru.com:4200
```

**⚠️ IMPORTANTE:** 
- Cambia `TuPasswordAqui` por la contraseña real de tu base de datos
- Cambia `JWT_SECRET` por una clave aleatoria y segura

Guarda y cierra el archivo.

---

### 2.4 Verificar que web.config existe

```powershell
dir web.config
```

✔️ Este archivo ya debe existir (lo creamos anteriormente)

---

## ✅ PASO 3: CONFIGURAR IIS

### 3.1 Abrir IIS Manager como Administrador

1. Presiona `Win + R`
2. Escribe: `inetmgr`
3. Presiona Enter

---

### 3.2 Crear Application Pool

1. En el panel izquierdo, haz click en **Application Pools**
2. En el panel derecho, click en **Add Application Pool...**
3. Completa:
   - **Name:** `SisTickets-API-Pool`
   - **.NET CLR version:** `No Managed Code`
   - **Managed pipeline mode:** `Integrated`
4. Click **OK**

**Configurar el Application Pool:**
1. En la lista de Application Pools, click en `SisTickets-API-Pool`
2. En el panel derecho, click en **Advanced Settings...**
3. Busca **Enable 32-Bit Applications** → Cambia a `False`
4. Click **OK**

---

### 3.3 Crear el Sitio Web

1. En el panel izquierdo, click derecho en **Sites**
2. Selecciona **Add Website...**
3. Completa los campos:

   ```
   Site name: SisTickets-API
   Application pool: SisTickets-API-Pool
   Physical path: C:\WS_Tickets_Control\Tickets-Backend\dist
   ```

4. En la sección **Binding:**
   ```
   Type: http (por ahora, cambiaremos a https después)
   IP address: All Unassigned
   Port: 3000
   Host name: apitk.nexwork-peru.com
   ```

5. Click **OK**

---

### 3.4 Configurar Permisos de Carpeta

**Importante:** IIS necesita permisos para leer/ejecutar la carpeta del proyecto.

**Usando PowerShell como Administrador:**

```powershell
# Navegar a la carpeta dist
cd C:\WS_Tickets_Control\Tickets-Backend\dist

# Otorgar permisos a IIS_IUSRS
icacls . /grant "IIS_IUSRS:(OI)(CI)RX" /T

# Otorgar permisos a IUSR
icacls . /grant "IUSR:(OI)(CI)RX" /T
```

✔️ Deberías ver mensajes de "processed files successfully"

---

### 3.5 Configurar HTTPS (SSL)

1. En IIS Manager, selecciona el sitio **SisTickets-API**
2. En el panel derecho, click en **Bindings...**
3. Click en **Add...**
4. Completa:
   ```
   Type: https
   IP address: All Unassigned
   Port: 3000
   Host name: apitk.nexwork-peru.com
   SSL certificate: [Selecciona tu certificado SSL para apitk.nexwork-peru.com]
   ```
5. Click **OK**
6. **OPCIONAL:** Si solo quieres HTTPS, puedes eliminar el binding HTTP

---

## ✅ PASO 4: INICIAR EL SITIO

### 4.1 Iniciar el Application Pool

1. En IIS Manager → **Application Pools**
2. Click en `SisTickets-API-Pool`
3. En el panel derecho, click en **Start**

---

### 4.2 Iniciar el Sitio Web

1. En IIS Manager → **Sites**
2. Click en `SisTickets-API`
3. En el panel derecho, click en **Start**

✔️ El sitio debería iniciar sin errores

---

## ✅ PASO 5: PROBAR LA API

### 5.1 Probar desde el navegador

Abre tu navegador y visita:

```
https://apitk.nexwork-peru.com:3000/api
```

O prueba el health check:

```
https://apitk.nexwork-peru.com:3000/health
```

✔️ **Debería responder con JSON** (aunque sea un error 404, eso significa que el servidor está respondiendo)

---

### 5.2 Probar un endpoint específico

Si tienes un endpoint de login:

```
https://apitk.nexwork-peru.com:3000/api/auth/login
```

---

## 🔍 PASO 6: VERIFICAR LOGS (Si hay problemas)

### 6.1 Logs de iisnode

Los logs de Node.js se guardan en:

```
C:\WS_Tickets_Control\Tickets-Backend\dist\iisnode\
```

Abre los archivos de log para ver errores.

---

### 6.2 Logs de IIS

Los logs de IIS están en:

```
C:\inetpub\logs\LogFiles\
```

---

## ❌ SOLUCIÓN DE PROBLEMAS COMUNES

### Problema 1: "Cannot GET /"

**Causa:** El sitio está funcionando, pero no hay una ruta definida en `/`

**Solución:** Prueba con `/api` o `/health`

---

### Problema 2: "503 Service Unavailable"

**Causas posibles:**
1. El Application Pool está detenido
2. Hay un error en el código Node.js
3. Falta algún módulo o archivo

**Solución:**
1. Verifica que el Application Pool está iniciado
2. Revisa los logs en `dist\iisnode\`
3. Verifica que la carpeta `dist` tiene todos los archivos
4. Verifica que `node_modules` existe y está completo

---

### Problema 3: "404 Not Found"

**Causa:** El archivo web.config no está funcionando correctamente

**Solución:**
1. Verifica que URL Rewrite Module está instalado
2. Verifica que el archivo `web.config` está en la carpeta `dist`
3. Reinicia el sitio en IIS

---

### Problema 4: Error de permisos

**Causa:** IIS no tiene permisos para acceder a la carpeta

**Solución:**
```powershell
# Como Administrador
cd C:\WS_Tickets_Control\Tickets-Backend\dist
icacls . /grant "IIS_IUSRS:(OI)(CI)F" /T
icacls . /grant "IUSR:(OI)(CI)F" /T
```

---

### Problema 5: Error de base de datos

**Causa:** No puede conectarse a SQL Server

**Solución:**
1. Verifica que el archivo `.env` está en la raíz del proyecto (NO en dist)
2. Verifica las credenciales de la base de datos
3. Verifica que SQL Server está accesible desde el servidor
4. Prueba la conexión con SQL Server Management Studio

---

## 🎉 VERIFICACIÓN FINAL

Si todo está bien, deberías poder:

- ✅ Acceder a `https://apitk.nexwork-peru.com:3000/api`
- ✅ Ver el sitio corriendo en IIS Manager
- ✅ Ver logs en la carpeta `iisnode`
- ✅ Hacer peticiones POST/GET a tus endpoints

---

## 📝 COMANDOS ÚTILES

### Reiniciar el sitio
```powershell
# En PowerShell como Administrador
Import-Module WebAdministration
Restart-WebAppPool -Name "SisTickets-API-Pool"
Restart-WebItem -PSPath "IIS:\Sites\SisTickets-API"
```

### Ver logs en tiempo real
```powershell
# PowerShell
Get-Content C:\WS_Tickets_Control\Tickets-Backend\dist\iisnode\*.log -Wait
```

### Detener el sitio
```powershell
Import-Module WebAdministration
Stop-WebItem -PSPath "IIS:\Sites\SisTickets-API"
```

---

## 🔄 ACTUALIZAR LA API (Para futuras actualizaciones)

Cuando hagas cambios en el código:

```powershell
# 1. Compilar
cd C:\WS_Tickets_Control\Tickets-Backend
npm run build

# 2. Reiniciar en IIS
Import-Module WebAdministration
Restart-WebAppPool -Name "SisTickets-API-Pool"
```

---

**¿Listo para continuar con el Frontend?** Avísame cuando la API esté funcionando correctamente.

