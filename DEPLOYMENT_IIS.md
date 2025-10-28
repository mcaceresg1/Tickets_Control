# Guía de Despliegue en IIS - Sistema de Tickets

## 📋 Requisitos Previos

1. **Windows Server con IIS instalado**
2. **Node.js** instalado (versión 18 o superior)
3. **iisnode** instalado ([Descargar aquí](https://github.com/Azure/iisnode/releases))
4. **URL Rewrite Module para IIS** ([Descargar aquí](https://www.iis.net/downloads/microsoft/url-rewrite))
5. **Certificados SSL** configurados para los dominios

---

## 🚀 Parte 1: Despliegue de la API (Node.js)

### Dominio: https://apitp.nexwork-peru.com/
### Puerto: 3000

### Paso 1: Preparar la API

1. **Compilar el proyecto TypeScript:**
   ```bash
   cd C:\WS_Tickets_ver\Sis.Tickets-Api
   npm install
   npm run build
   ```

2. **Crear archivo .env en la raíz del proyecto:**
   ```env
   NODE_ENV=production
   PORT=3000
   API_PREFIX=/api
   
   # Base de datos
   DB_SERVER=161.132.56.68
   DB_NAME=DB_A64885_tickets
   DB_USER=sa
   DB_PASSWORD=YourPassword
   DB_PORT=1433
   DB_ENCRYPT=false
   DB_TRUST_CERT=true
   
   # CORS
   CORS_ORIGIN=https://tp.nexwork-peru.com
   
   # JWT
   JWT_SECRET=your-secret-key-change-in-production
   JWT_EXPIRES_IN=24h
   
   # Frontend URL
   FRONTEND_URL=https://tp.nexwork-peru.com
   ```

3. **Verificar que web.config existe** (ya está creado en la raíz del proyecto)

### Paso 2: Configurar IIS para la API

1. **Abrir IIS Manager**

2. **Crear un nuevo sitio web:**
   - Click derecho en "Sites" → "Add Website"
   - **Site name:** `SisTickets-API`
   - **Physical path:** `C:\WS_Tickets_ver\Sis.Tickets-Api\dist`
   - **Binding:**
     - Type: https
     - IP address: All Unassigned
     - Port: 3000
     - Host name: `apitp.nexwork-peru.com`
     - SSL certificate: Seleccionar el certificado correspondiente

3. **Configurar Application Pool:**
   - Nombre: `SisTickets-API-Pool`
   - .NET CLR version: No Managed Code
   - Managed pipeline mode: Integrated
   - Identity: ApplicationPoolIdentity (o cuenta específica con permisos)

4. **Permisos de carpeta:**
   - Click derecho en la carpeta del proyecto → Properties → Security
   - Agregar permisos de lectura/escritura para:
     - `IIS_IUSRS`
     - `IUSR`
     - Usuario del Application Pool

5. **Verificar módulos instalados:**
   - En IIS Manager → Server → Modules
   - Verificar que `iisnode` está instalado
   - Verificar que `URL Rewrite` está instalado

6. **Iniciar el sitio**

### Paso 3: Probar la API

Abrir navegador y visitar:
```
https://apitp.nexwork-peru.com/api
```

---

## 🌐 Parte 2: Despliegue del Frontend (Angular)

### Dominio: https://tp.nexwork-peru.com/
### Puerto: 4200

### Paso 1: Preparar el Frontend

1. **Compilar el proyecto Angular para producción:**
   ```bash
   cd C:\WS_Tickets_ver\Sis.Tickets-Web
   npm install
   npm run build:prod
   ```
   
   Esto generará los archivos en: `dist/sis-tickets-frontend/`

2. **Copiar web.config a la carpeta dist:**
   ```bash
   copy web.config dist\sis-tickets-frontend\
   ```

### Paso 2: Configurar IIS para el Frontend

1. **Abrir IIS Manager**

2. **Crear un nuevo sitio web:**
   - Click derecho en "Sites" → "Add Website"
   - **Site name:** `SisTickets-Web`
   - **Physical path:** `C:\WS_Tickets_ver\Sis.Tickets-Web\dist\sis-tickets-frontend`
   - **Binding:**
     - Type: https
     - IP address: All Unassigned
     - Port: 4200
     - Host name: `tp.nexwork-peru.com`
     - SSL certificate: Seleccionar el certificado correspondiente

3. **Configurar Application Pool:**
   - Nombre: `SisTickets-Web-Pool`
   - .NET CLR version: No Managed Code
   - Managed pipeline mode: Integrated
   - Identity: ApplicationPoolIdentity

4. **Permisos de carpeta:**
   - Click derecho en la carpeta dist → Properties → Security
   - Agregar permisos de lectura para:
     - `IIS_IUSRS`
     - `IUSR`

5. **Verificar URL Rewrite Module:**
   - En IIS Manager → Server → Modules
   - Verificar que `URL Rewrite` está instalado

6. **Iniciar el sitio**

### Paso 3: Probar el Frontend

Abrir navegador y visitar:
```
https://tp.nexwork-peru.com/
```

---

## 🔧 Configuración Adicional

### Configurar CORS en el Firewall

Si tienes firewall de Windows activo, asegúrate de permitir el tráfico en los puertos:
```powershell
# PowerShell como Administrador
New-NetFirewallRule -DisplayName "Allow Port 3000" -Direction Inbound -LocalPort 3000 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Port 4200" -Direction Inbound -LocalPort 4200 -Protocol TCP -Action Allow
```

### Logs de IIS

**Para la API (Node.js):**
- Logs de iisnode: `C:\WS_Tickets_ver\Sis.Tickets-Api\dist\iisnode\`
- Logs de IIS: `C:\inetpub\logs\LogFiles\`

**Para el Frontend:**
- Logs de IIS: `C:\inetpub\logs\LogFiles\`

### Solución de Problemas Comunes

#### API no arranca:
1. Verificar que Node.js está en PATH del sistema
2. Verificar permisos de carpeta
3. Revisar logs en `dist\iisnode\`
4. Verificar que el archivo `dist/index.js` existe
5. Verificar conexión a la base de datos

#### Frontend muestra error 404:
1. Verificar que el módulo URL Rewrite está instalado
2. Verificar que web.config está en la carpeta correcta
3. Verificar que la ruta física apunta a `dist\sis-tickets-frontend`

#### Error de CORS:
1. Verificar que el `.env` tiene el CORS_ORIGIN correcto
2. Verificar que el frontend está usando la URL correcta de la API
3. Reiniciar el Application Pool de la API

#### Certificado SSL:
1. Asegurarse de que los certificados SSL estén instalados en el servidor
2. Vincular los certificados correctos en cada sitio de IIS

---

## 📦 Actualización del Proyecto

### Para actualizar la API:

```bash
cd C:\WS_Tickets_ver\Sis.Tickets-Api
git pull
npm install
npm run build
```

Luego en IIS Manager → Application Pools → Click derecho en `SisTickets-API-Pool` → Recycle

### Para actualizar el Frontend:

```bash
cd C:\WS_Tickets_ver\Sis.Tickets-Web
git pull
npm install
npm run build:prod
copy web.config dist\sis-tickets-frontend\
```

Luego en IIS Manager → Application Pools → Click derecho en `SisTickets-Web-Pool` → Recycle

---

## 🔒 Seguridad

1. **Cambiar el JWT_SECRET** en el archivo `.env` por una clave segura
2. **Actualizar contraseña de base de datos** si es necesaria
3. **Configurar HTTPS** obligatorio en ambos sitios
4. **Deshabilitar listado de directorios** en IIS
5. **Configurar límites de tamaño de solicitud** según necesidad

---

## 📞 Soporte

Si encuentras problemas durante el despliegue:
1. Revisar los logs de IIS y iisnode
2. Verificar que todos los módulos necesarios están instalados
3. Verificar permisos de carpetas
4. Verificar que los puertos no están en uso por otras aplicaciones

---

## ✅ Checklist de Despliegue

### API:
- [ ] Node.js instalado
- [ ] iisnode instalado
- [ ] URL Rewrite Module instalado
- [ ] Proyecto compilado (`npm run build`)
- [ ] Archivo `.env` configurado
- [ ] Sitio IIS creado en puerto 3000
- [ ] Application Pool configurado
- [ ] Permisos de carpeta establecidos
- [ ] Certificado SSL configurado
- [ ] Sitio iniciado
- [ ] API responde en https://apitp.nexwork-peru.com/api

### Frontend:
- [ ] Proyecto compilado (`npm run build:prod`)
- [ ] web.config copiado a dist
- [ ] environment.prod.ts con URL correcta de API
- [ ] Sitio IIS creado en puerto 4200
- [ ] Application Pool configurado
- [ ] Permisos de carpeta establecidos
- [ ] Certificado SSL configurado
- [ ] Sitio iniciado
- [ ] Frontend responde en https://tp.nexwork-peru.com:4200/

---

**Fecha de creación:** Octubre 2025  
**Última actualización:** Octubre 2025

