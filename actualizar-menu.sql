-- Script para actualizar nombres del menú en GEN_Menu
-- BD: DB_A64885_Tickets
-- Usuario: sa
-- Password: 12335599

USE DB_A64885_Tickets;
GO

BEGIN TRANSACTION;

-- 1. Cambiar "MODULOS" o "1. MODULOS" a "1. APLICACION"
UPDATE GEN_Menu
SET Menu = '1. APLICACION'
WHERE Menu IN ('MODULOS', '1. MODULOS');
GO

-- 2. Cambiar "PAGINAS" o "2. PAGINAS" a "2. MODULO"
UPDATE GEN_Menu
SET Menu = '2. MODULO'
WHERE Menu IN ('PAGINAS', '2. PAGINAS');
GO

-- 3. Crear la nueva opción "3. OPCION" que repite la página de "PAGINAS" (ahora "2. MODULO")
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
    @IdMenuPaginas = IdMenu,
    @IdPadrePaginas = IdPadre,
    @VistaPaginas = Vista,
    @ControladorPaginas = Controlador,
    @OrdenPaginas = Orden,
    @IconoPaginas = sIcono
FROM GEN_Menu
WHERE Menu = '2. MODULO';

-- Obtener el máximo Orden para colocar la nueva opción después
SELECT @MaxOrden = MAX(Orden) + 1 FROM GEN_Menu;

-- Insertar la nueva opción "3. OPCION"
-- Usamos un ID que no cause conflictos (multiplicamos por 10000 + 1)
INSERT INTO GEN_Menu (Menu, Vista, Controlador, IdPadre, Orden, sIcono, sEstado, sUserReg, dFechaReg)
VALUES (
    '3. OPCION',
    @VistaPaginas,
    @ControladorPaginas,
    @IdPadrePaginas,
    @MaxOrden,
    @IconoPaginas,
    'A', -- Activo
    'SISTEMA', -- Usuario que registra
    GETDATE() -- Fecha de registro
);
GO

-- Verificar los cambios
SELECT IdMenu, Menu, Vista, Controlador, IdPadre, Orden, sEstado
FROM GEN_Menu
WHERE Menu IN ('1. APLICACION', '2. MODULO', '3. OPCION')
ORDER BY Orden;
GO

-- Confirmar los cambios
COMMIT;
GO

PRINT '✅ Actualización del menú completada exitosamente!';
PRINT '   - MODULOS → 1. APLICACION';
PRINT '   - PAGINAS → 2. MODULO';
PRINT '   - Nueva opción 3. OPCION creada';
GO

