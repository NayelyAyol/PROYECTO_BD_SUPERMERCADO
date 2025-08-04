use Supermercado;
go

-- Seguridad ante SQL Injection
-- Simulación de formulario vulnerable
DECLARE @usuario NVARCHAR(100) = ''' OR ''1''=''1'
DECLARE @sql NVARCHAR(MAX)

SET @sql = 'SELECT * FROM usuarios WHERE usuario = ''' + @usuario + ''''
EXEC(@sql)
GO

-- Protección con consultas
DECLARE @usuario NVARCHAR(100) = 'admin'
DECLARE @sql NVARCHAR(MAX)

SET @sql = 'SELECT * FROM usuarios WHERE usuario =  @usr'
EXEC sp_executesql @sql, N'@usr NVARCHAR(50)', @usr = @usuario
GO

-- Validaciones previas
CREATE PROCEDURE login_seguro
    @usuario NVARCHAR(100),
    @clave NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);

    SET @sql = '
        SELECT u.usuario, e.nombre AS nombre_empleado
        FROM usuarios u
        JOIN empleado e ON u.id_empleado = e.id_empleado
        WHERE u.usuario = @userInput
          AND u.clave = HASHBYTES(''SHA2_256'', @passInput);
    ';

    EXEC sp_executesql
        @sql,
        N'@userInput NVARCHAR(100), @passInput NVARCHAR(100)',
        @userInput = @usuario,
        @passInput = @clave;
END;
GO

