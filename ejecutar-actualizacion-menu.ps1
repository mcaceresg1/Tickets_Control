# Script para ejecutar la actualizacion del menu en la base de datos
# BD: DB_A64885_Tickets
# Servidor: 161.132.56.68 (o localhost si esta en el mismo servidor)

param(
    [string]$Server = "161.132.56.68",
    [string]$Database = "DB_A64885_Tickets",
    [string]$User = "sa",
    [string]$Password = "12335599"
)

Write-Host "`n🔄 Ejecutando actualizacion del menu en la base de datos..." -ForegroundColor Cyan
Write-Host "   Servidor: $Server" -ForegroundColor Yellow
Write-Host "   Base de datos: $Database" -ForegroundColor Yellow
Write-Host ""

# Verificar que el archivo SQL existe
$sqlFile = Join-Path $PSScriptRoot "actualizar-menu.sql"
if (-not (Test-Path $sqlFile)) {
    Write-Host "❌ Error: No se encontro el archivo actualizar-menu.sql" -ForegroundColor Red
    exit 1
}

# Instalar modulo SqlServer si no esta instalado
if (-not (Get-Module -ListAvailable -Name SqlServer)) {
    Write-Host "📦 Instalando modulo SqlServer..." -ForegroundColor Yellow
    Install-Module -Name SqlServer -Scope CurrentUser -Force -SkipPublisherCheck
}

# Importar modulo
Import-Module SqlServer -ErrorAction Stop

try {
    # Leer el contenido del archivo SQL
    $sqlScript = Get-Content $sqlFile -Raw
    
    Write-Host "🔌 Conectando a la base de datos..." -ForegroundColor Cyan
    
    # Ejecutar el script SQL
    Invoke-Sqlcmd `
        -ServerInstance $Server `
        -Database $Database `
        -Username $User `
        -Password $Password `
        -Query $sqlScript `
        -ErrorAction Stop
    
    Write-Host "✅ Actualizacion completada exitosamente!" -ForegroundColor Green
    Write-Host "`n📋 Cambios realizados:" -ForegroundColor Cyan
    Write-Host "   ✓ 'MODULOS' → '1. APLICACION'" -ForegroundColor Green
    Write-Host "   ✓ 'PAGINAS' → '2. MODULO'" -ForegroundColor Green
    Write-Host "   ✓ Nueva opcion '3. OPCION' creada" -ForegroundColor Green
    Write-Host ""
    
} catch {
    Write-Host "❌ Error al ejecutar el script SQL:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Alternativa: Ejecuta el archivo actualizar-menu.sql manualmente en SQL Server Management Studio" -ForegroundColor Cyan
    exit 1
}