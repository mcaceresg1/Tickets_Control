# 🔒 CONFIGURACIÓN IIS OPTIMIZADA - SISTEMA DE TICKETS

## ✅ **OPTIMIZACIONES COMPLETADAS**

### **1. WEB.CONFIG DE API OPTIMIZADO**
- ✅ **SSL Redirect**: HTTP → HTTPS automático
- ✅ **Headers de Seguridad**: HSTS, CSP, X-Frame-Options, etc.
- ✅ **iisnode Optimizado**: Configuración avanzada de rendimiento
- ✅ **Seguridad Mejorada**: Ocultación de directorios sensibles
- ✅ **Compresión**: Habilitada para mejor rendimiento

### **2. WEB.CONFIG DE FRONTEND OPTIMIZADO**
- ✅ **SSL Redirect**: HTTP → HTTPS automático
- ✅ **Content Security Policy**: Configurado para Angular + API
- ✅ **Headers de Seguridad**: Completa suite de seguridad
- ✅ **MIME Types**: Soporte completo para fuentes y assets
- ✅ **Angular Router**: Configuración optimizada para SPA

### **3. SCRIPTS DE DESPLIEGUE MEJORADOS**
- ✅ **Application Pool Optimizado**: Configuración de rendimiento
- ✅ **Recycling Configurado**: Sin reinicios automáticos
- ✅ **Identity Seguro**: ApplicationPoolIdentity
- ✅ **Timeouts Optimizados**: Configuración para producción

### **4. CONFIGURACIÓN SSL AUTOMATIZADA**
- ✅ **Script SSL**: `configure-ssl.ps1` para configuración automática
- ✅ **Detección de Certificados**: Búsqueda automática de certificados válidos
- ✅ **Bindings HTTPS**: Configuración automática de puertos SSL
- ✅ **Verificación**: Validación de configuración final

---

## 🚀 **INSTRUCCIONES DE DESPLIEGUE COMPLETO**

### **PASO 1: Desplegar API**
```powershell
# Ejecutar como Administrador
.\deploy-api.ps1
```

### **PASO 2: Desplegar Frontend**
```powershell
# Ejecutar como Administrador
.\deploy-web.ps1
```

### **PASO 3: Configurar SSL**
```powershell
# Ejecutar como Administrador
.\configure-ssl.ps1
```

---

## 🔒 **CARACTERÍSTICAS DE SEGURIDAD IMPLEMENTADAS**

### **HEADERS DE SEGURIDAD**
- ✅ **Strict-Transport-Security**: HSTS habilitado
- ✅ **X-Content-Type-Options**: nosniff
- ✅ **X-Frame-Options**: DENY (API) / SAMEORIGIN (Web)
- ✅ **X-XSS-Protection**: 1; mode=block
- ✅ **Referrer-Policy**: strict-origin-when-cross-origin
- ✅ **Permissions-Policy**: Restricciones de geolocalización, micrófono, cámara

### **CONTENT SECURITY POLICY (Frontend)**
```
default-src 'self';
script-src 'self' 'unsafe-inline' 'unsafe-eval';
style-src 'self' 'unsafe-inline' https://fonts.googleapis.com;
font-src 'self' https://fonts.gstatic.com;
img-src 'self' data: https:;
connect-src 'self' https://apitk.nexwork-peru.com:3000;
frame-ancestors 'none';
```

### **CONFIGURACIÓN IIS**
- ✅ **Request Filtering**: Límites de tamaño de archivo
- ✅ **Hidden Segments**: Ocultación de directorios sensibles
- ✅ **Compression**: Habilitada para mejor rendimiento
- ✅ **Caching**: Cache optimizado para archivos estáticos

---

## 📊 **CONFIGURACIÓN DE RENDIMIENTO**

### **APPLICATION POOL OPTIMIZADO**
- ✅ **Identity**: ApplicationPoolIdentity
- ✅ **Idle Timeout**: 20 minutos
- ✅ **Recycling**: Deshabilitado para estabilidad
- ✅ **Memory Limits**: Sin límites automáticos
- ✅ **Overlapping Rotation**: Habilitado

### **IISNODE CONFIGURACIÓN AVANZADA**
- ✅ **Max Concurrent Requests**: 1024
- ✅ **Connection Pool**: 512 conexiones
- ✅ **Buffer Sizes**: Optimizados para producción
- ✅ **Graceful Shutdown**: 60 segundos
- ✅ **Logging**: Habilitado con rotación

---

## 🌐 **URLS DE PRODUCCIÓN**

### **HTTPS (Recomendado)**
- **API**: `https://apitk.nexwork-peru.com:3000/api`
- **Frontend**: `https://tk.nexwork-peru.com:4200`
- **Swagger**: `https://apitk.nexwork-peru.com:3000/api-docs`

### **HTTP (Redirige a HTTPS)**
- **API**: `http://apitk.nexwork-peru.com:3000/api` → HTTPS
- **Frontend**: `http://tk.nexwork-peru.com:4200` → HTTPS

---

## 🔧 **COMANDOS DE VERIFICACIÓN**

### **Verificar Sitios IIS**
```powershell
Get-Website | Where-Object { $_.Name -like "*SisTickets*" }
```

### **Verificar Application Pools**
```powershell
Get-WebAppPool | Where-Object { $_.Name -like "*SisTickets*" }
```

### **Verificar Bindings SSL**
```powershell
Get-WebBinding | Where-Object { $_.protocol -eq "https" }
```

### **Verificar Certificados**
```powershell
Get-ChildItem -Path "Cert:\LocalMachine\My" | Where-Object { $_.Subject -like "*nexwork-peru.com*" }
```

---

## ⚠️ **NOTAS IMPORTANTES**

### **CERTIFICADOS SSL**
- Los certificados deben estar importados en IIS antes de ejecutar `configure-ssl.ps1`
- Los certificados deben ser válidos para los dominios:
  - `apitk.nexwork-peru.com`
  - `tk.nexwork-peru.com`

### **FIREWALL**
- Asegúrese de que los puertos 3000 y 4200 estén abiertos
- Configure reglas para HTTPS (443) si es necesario

### **DNS**
- Verifique que los registros DNS apunten correctamente al servidor
- Configure registros A o CNAME según corresponda

### **MONITOREO**
- Los logs de IIS están en: `C:\inetpub\logs\LogFiles\`
- Los logs de iisnode están en: `[Sitio]\iisnode\`
- Monitoree el rendimiento con Performance Monitor

---

## 🎯 **RESULTADO FINAL**

**✅ CONFIGURACIÓN IIS COMPLETAMENTE OPTIMIZADA**

- **Seguridad**: Máxima protección con headers y SSL
- **Rendimiento**: Application Pool y iisnode optimizados
- **Disponibilidad**: Configuración robusta para producción
- **Mantenimiento**: Scripts automatizados para despliegue
- **Monitoreo**: Logging completo habilitado

**¡Tu aplicación está lista para producción con configuración IIS de nivel empresarial!** 🚀
