# 🚀 CONFIGURACIÓN DEL SISTEMA DE TICKETS

## 📋 RESUMEN DE CONFIGURACIÓN COMPLETADA

### ✅ **CAMBIOS REALIZADOS**

#### 1. **ARCHIVO DE CONFIGURACIÓN DE PRODUCCIÓN**
- ✅ Creado: `CONFIGURACION_PRODUCCION.env`
- ✅ Configurado para entorno de producción
- ✅ Puerto API: 3000
- ✅ Puerto Frontend: 4200
- ✅ URLs de producción configuradas

#### 2. **CONFIGURACIÓN DEL BACKEND (API)**
- ✅ Puerto cambiado de 3001 a 3000 en `environment.ts`
- ✅ CORS actualizado para puerto 3000 en `cors.config.ts`
- ✅ Swagger configurado con URLs de producción
- ✅ Base de datos optimizada con variables de entorno

#### 3. **CONFIGURACIÓN DEL FRONTEND**
- ✅ `environment.prod.ts` actualizado con URL de producción
- ✅ API URL: `https://apitk.nexwork-peru.com:3000/api`

#### 4. **CONFIGURACIÓN DE BASE DE DATOS**
- ✅ Variables de entorno para timeouts configurables
- ✅ Pool de conexiones optimizado
- ✅ Configuración SSL para producción

---

## 🔧 **CONFIGURACIÓN ACTUAL**

### **PUERTOS**
- **API**: 3000 (producción) / 3000 (desarrollo)
- **Frontend**: 4200 (producción) / 4200 (desarrollo)

### **URLS DE PRODUCCIÓN**
- **API**: `https://apitk.nexwork-peru.com:3000/api`
- **Frontend**: `https://tk.nexwork-peru.com:4200`
- **Swagger**: `https://apitk.nexwork-peru.com:3000/api-docs`

### **BASE DE DATOS**
- **Servidor**: 161.132.56.68
- **Base de datos**: DB_A64885_tickets
- **Usuario**: sa
- **Puerto**: 1433
- **SSL**: Habilitado para producción

---

## 🚀 **INSTRUCCIONES DE DESPLIEGUE**

### **PASO 1: Configurar Variables de Entorno**
1. Copia `CONFIGURACION_PRODUCCION.env` a `Sis.Tickets-Api/.env`
2. Ajusta las credenciales de base de datos si es necesario
3. Cambia el `JWT_SECRET` por uno más seguro

### **PASO 2: Desplegar API**
```powershell
# Ejecutar como Administrador
.\deploy-api.ps1
```

### **PASO 3: Desplegar Frontend**
```powershell
# Ejecutar como Administrador
.\deploy-web.ps1
```

### **PASO 4: Verificar Despliegue**
1. Abrir: `https://apitk.nexwork-peru.com:3000/api`
2. Abrir: `https://tk.nexwork-peru.com:4200`
3. Verificar Swagger: `https://apitk.nexwork-peru.com:3000/api-docs`

---

## 🔒 **CONFIGURACIÓN SSL**

### **CERTIFICADOS REQUERIDOS**
- Certificado para `apitk.nexwork-peru.com` (API)
- Certificado para `tk.nexwork-peru.com` (Frontend)

### **CONFIGURACIÓN EN IIS**
1. Importar certificados en IIS
2. Configurar bindings HTTPS
3. Redirigir HTTP a HTTPS

---

## ⚠️ **NOTAS IMPORTANTES**

### **SEGURIDAD**
- ✅ CORS configurado para dominios específicos
- ✅ SSL habilitado para producción
- ✅ JWT con secret configurable
- ✅ Headers de seguridad en IIS

### **RENDIMIENTO**
- ✅ Pool de conexiones optimizado
- ✅ Compresión habilitada
- ✅ Cache de archivos estáticos
- ✅ Timeouts configurables

### **MONITOREO**
- ✅ Logs de IIS habilitados
- ✅ Health check endpoint: `/health`
- ✅ Swagger para documentación API

---

## 🛠️ **COMANDOS ÚTILES**

### **Desarrollo Local**
```bash
# API
cd Sis.Tickets-Api
npm run dev

# Frontend
cd Sis.Tickets-Web
npm start
```

### **Producción**
```bash
# Compilar API
cd Sis.Tickets-Api
npm run build

# Compilar Frontend
cd Sis.Tickets-Web
npm run build:prod
```

---

## 📞 **SOPORTE**

Si encuentras problemas:
1. Verifica los logs de IIS
2. Revisa la configuración de certificados SSL
3. Confirma que los puertos están disponibles
4. Verifica la conectividad a la base de datos

**¡Configuración completada exitosamente!** 🎉
