-- Script para actualizar nombres del menu en GEN_Menu
-- BD: DB_A64885_Tickets
-- Usuario: sa
-- Password: 12335599

USE DB_A64885_Tickets;
GO

BEGIN TRANSACTION;

-- 1. Cambiar "MODULOS" o "1. MODULOS" a "1. APLICACION"
UPDATE GEN_Menu
SET sDescripcionMenu = '1. APLICACION'
WHERE sDescripcionMenu IN ('MODULOS', '1. MODULOS');
GO

-- 2. Cambiar "PAGINAS" o "2. PAGINAS" a "2. MODULO"
UPDATE GEN_Menu
SET sDescripcionMenu = '2. MODULO'
WHERE sDescripcionMenu IN ('PAGINAS', '2. PAGINAS');
GO

-- 3. Crear la nueva opcion "3. OPCION" que repite la pagina de "PAGINAS" (ahora "2. MODULO")
-- Primero obtenemos los datos del registro PAGINAS/MODULO
DECLARE @IdMenuPaginas INT;
DECLARE @IdPadrePaginas INT;
DECLARE @VistaPaginas VARCHAR(100);
DECLARE @ControladorPaginas VARCHAR(100);
DECLARE @OrdenPaginas INT;
DECLARE @IconoPaginas VARCHAR(100);
DECLARE @MaxOrden INT;

-- Obtener datos del registro que ahora se llama "2. MODULO"
SELECT 
    @IdMenuPaginas = iID_Menu,
    @IdPadrePaginas = iID_MenuPadre,
    @VistaPaginas = sVistaMenu,
    @ControladorPaginas = sControladorMenu,
    @OrdenPaginas = iOrden,
    @IconoPaginas = sIcono
FROM GEN_Menu
WHERE sDescripcionMenu = '2. MODULO';

-- Obtener el maximo Orden para colocar la nueva opcion despues
SELECT @MaxOrden = MAX(iOrden) + 1 FROM GEN_Menu;

-- Insertar la nueva opcion "3. OPCION"
INSERT INTO GEN_Menu (iID_Sistema, iID_MenuPadre, iOrden, sDescripcionMenu, sVistaMenu, sControladorMenu, sUserReg, dFechaReg, sEstado, sIcono, sVerMenu)
VALUES (
    1, -- iID_Sistema
    @IdPadrePaginas, -- iID_MenuPadre
    @MaxOrden, -- iOrden
    '3. OPCION', -- sDescripcionMenu
    @VistaPaginas, -- sVistaMenu
    @ControladorPaginas, -- sControladorMenu
    'SISTEMA', -- sUserReg
    GETDATE(), -- dFechaReg
    'A', -- sEstado
    @IconoPaginas, -- sIcono
    1 -- sVerMenu
);
GO

-- Verificar los cambios
SELECT iID_Menu, sDescripcionMenu, sVistaMenu, sControladorMenu, iID_MenuPadre, iOrden, sEstado
FROM GEN_Menu
WHERE sDescripcionMenu IN ('1. APLICACION', '2. MODULO', '3. OPCION')
ORDER BY iOrden;
GO

-- Confirmar los cambios
COMMIT;
GO

PRINT 'Actualizacion del menu completada exitosamente!';
PRINT '   - MODULOS → 1. APLICACION';
PRINT '   - PAGINAS → 2. MODULO';
PRINT '   - Nueva opcion 3. OPCION creada';
GO
