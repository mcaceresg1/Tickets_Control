# ✅ CHECKLIST DE DESPLIEGUE - API

Imprime esta lista y marca cada paso conforme lo completes.

---

## REQUISITOS PREVIOS

- [ ] Node.js instalado (v18+)
- [ ] IIS instalado y funcionando
- [ ] iisnode instalado
- [ ] URL Rewrite Module instalado
- [ ] IIS reiniciado después de instalar módulos

---

## PREPARACIÓN DEL PROYECTO

- [ ] Navegar a: `C:\WS_Tickets_ver\Sis.Tickets-Api`
- [ ] Ejecutar: `npm install`
- [ ] Ejecutar: `npm run build`
- [ ] Verificar que la carpeta `dist` fue creada
- [ ] Crear archivo `.env` con configuración de producción
- [ ] Actualizar contraseña de base de datos en `.env`
- [ ] Cambiar `JWT_SECRET` por una clave segura
- [ ] Verificar que `web.config` existe en la raíz del proyecto

---

## CONFIGURACIÓN DE IIS

### Application Pool
- [ ] Abrir IIS Manager
- [ ] Crear Application Pool: `SisTickets-API-Pool`
- [ ] .NET CLR version: `No Managed Code`
- [ ] Managed pipeline mode: `Integrated`
- [ ] Enable 32-Bit Applications: `False`

### Sitio Web
- [ ] Crear nuevo sitio: `SisTickets-API`
- [ ] Application pool: `SisTickets-API-Pool`
- [ ] Physical path: `C:\WS_Tickets_ver\Sis.Tickets-Api\dist`
- [ ] Binding HTTP - Puerto: `3000`
- [ ] Host name: `apitp.nexwork-peru.com`

### SSL/HTTPS
- [ ] Agregar binding HTTPS
- [ ] Puerto: `3000`
- [ ] Seleccionar certificado SSL correcto
- [ ] (Opcional) Eliminar binding HTTP si solo quieres HTTPS

### Permisos
- [ ] Otorgar permisos a `IIS_IUSRS` en carpeta `dist`
- [ ] Otorgar permisos a `IUSR` en carpeta `dist`

---

## INICIAR SERVICIOS

- [ ] Iniciar Application Pool: `SisTickets-API-Pool`
- [ ] Iniciar Sitio: `SisTickets-API`
- [ ] Verificar que no hay errores en IIS

---

## PRUEBAS

- [ ] Abrir navegador
- [ ] Visitar: `https://apitp.nexwork-peru.com:3000/api`
- [ ] Probar health check: `https://apitp.nexwork-peru.com:3000/health`
- [ ] Verificar que responde (aunque sea con error, debe responder)
- [ ] Probar un endpoint de login o similar
- [ ] Verificar que puede conectarse a la base de datos

---

## LOGS Y MONITOREO

- [ ] Revisar logs en: `C:\WS_Tickets_ver\Sis.Tickets-Api\dist\iisnode\`
- [ ] Verificar que no hay errores críticos
- [ ] Verificar conexión a base de datos en logs

---

## SI HAY PROBLEMAS

**503 Service Unavailable:**
- [ ] Revisar logs de iisnode
- [ ] Verificar que Application Pool está iniciado
- [ ] Verificar que todos los módulos npm están instalados

**404 Not Found:**
- [ ] Verificar que URL Rewrite Module está instalado
- [ ] Verificar que web.config está en la carpeta dist

**Error de permisos:**
- [ ] Ejecutar comandos de icacls para otorgar permisos
- [ ] Reiniciar Application Pool

**Error de base de datos:**
- [ ] Verificar credenciales en .env
- [ ] Probar conexión a SQL Server
- [ ] Verificar que el servidor de base de datos es accesible

---

## ✅ COMPLETADO

- [ ] API responde correctamente
- [ ] Todos los endpoints funcionan
- [ ] Base de datos conectada
- [ ] Sin errores en logs
- [ ] Listo para continuar con el Frontend

---

**Fecha de despliegue:** ___________________

**Desplegado por:** ___________________

**Notas:**
________________________________________
________________________________________
________________________________________

