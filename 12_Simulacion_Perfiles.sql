-- SIMULACION DE PERFILES PROFESIONALES
-- ADMINISTRADOR DE BD
--Mantenimiento de índices
-- 1. CREACIÓN DE ÍNDICES PARA MEJORAR CONSULTAS
CREATE NONCLUSTERED INDEX idx_producto_nombre ON producto(nombre);
CREATE NONCLUSTERED INDEX idx_cliente_cedula ON cliente(cedula);
CREATE NONCLUSTERED INDEX idx_venta_fecha ON venta(fecha);
GO

-- Reorganizar (menos costoso)
EXEC sp_MSforeachtable 'ALTER INDEX ALL ON ? REORGANIZE';
go

-- 3. RESPALDO DE LA BASE DE DATOS (simulado)
BACKUP DATABASE Supermercado
TO DISK = 'C:\Backups\Supermercado_backup.bak'
WITH FORMAT,
     MEDIANAME = 'SupermercadoBackup',
     NAME = 'Full Backup of Supermercado';
GO


-- Programación de tarea automatizada
-- Esto normalmente se configura con el SQL Server Agent, aquí solo mostramos el script que ejecutaría una tarea:
-- Simulación: procedimiento para realizar respaldo diario
CREATE PROCEDURE sp_backup_diario
AS
BEGIN
    BACKUP DATABASE Supermercado
    TO DISK = 'C:\Backups\Supermercado_backup_diario.bak'
    WITH INIT, NAME = 'Backup Diario';
END;
GO

-- Nota: para ejecutarlo automáticamente cada día, se debe crear un Job en SQL Server Agent (fuera del alcance de solo T-SQL).
-- EXEC sp_backup_diario;


-- Monitoreo del sistema
EXEC sp_MSforeachtable 'EXEC sp_spaceused [?]';
GO

-- Últimas conexiones
SELECT 
    login_name, 
    host_name, 
    program_name, 
    login_time
FROM sys.dm_exec_sessions
WHERE is_user_process = 1;
GO
-- Consultas más costosas (top 5 por uso de CPU)
SELECT TOP 5 
    total_worker_time/1000.0 AS CPU_ms,
    execution_count,
    total_elapsed_time/1000.0 AS ElapsedTime_ms,
    query_hash,
    SUBSTRING(qt.text, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset
          WHEN -1 THEN DATALENGTH(qt.text)
          ELSE qs.statement_end_offset END
          - qs.statement_start_offset)/2)+1) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY total_worker_time DESC;
GO


-- ARQUITECTO DE BD
-- Vista del diseño lógico 
SELECT 
    t.name AS tabla,
    c.name AS columna,
    ty.name AS tipo_dato,
    c.max_length AS longitud,
    c.is_nullable AS permite_nulo,
    i.is_primary_key AS clave_primaria
FROM sys.tables t
JOIN sys.columns c ON t.object_id = c.object_id
JOIN sys.types ty ON c.user_type_id = ty.user_type_id
LEFT JOIN sys.index_columns ic ON t.object_id = ic.object_id AND c.column_id = ic.column_id
LEFT JOIN sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id;

-- Detectar tablas que no sigan el prefijo estándar 
SELECT name AS tabla_sin_prefijo
FROM sys.tables
WHERE name NOT LIKE 'tbl_%';

-- Validar si las PK cumplen el estándar de nombre 'id_<tabla>'
SELECT 
    t.name AS tabla,
    c.name AS columna_pk,
    CASE 
        WHEN c.name = 'id_' + t.name THEN 'Cumple'
        ELSE 'No cumple'
    END AS cumple_estandar
FROM sys.tables t
JOIN sys.indexes i ON t.object_id = i.object_id AND i.is_primary_key = 1
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON t.object_id = c.object_id AND ic.column_id = c.column_id;
GO

-- Proyeccion de escalabilidad
SELECT 
    t.name AS tabla,
    SUM(p.rows) AS total_filas
FROM sys.tables t
JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0,1)
GROUP BY t.name
ORDER BY total_filas DESC;
GO

EXEC sp_MSforeachtable 'EXEC sp_spaceused ''?''';

-- Revisión de integridad
SELECT 
    f.name AS restriccion,
    OBJECT_NAME(f.parent_object_id) AS tabla_hija,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS columna_hija,
    OBJECT_NAME(f.referenced_object_id) AS tabla_padre,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS columna_padre
FROM sys.foreign_keys AS f
INNER JOIN sys.foreign_key_columns AS fc ON f.object_id = fc.constraint_object_id;
GO


USE Supermercado;
GO

-- OFICIAL DE SEGURIDAD
-- Creación de roles
CREATE ROLE rol_ventas;
CREATE ROLE rol_inventario;
CREATE ROLE rol_admin;

-- Privilegios
-- rol_ventas puede leer y agregar ventas
GRANT SELECT, INSERT ON venta TO rol_ventas;
GRANT SELECT, INSERT ON detalle_venta TO rol_ventas;

-- rol_inventario puede actualizar productos e inventario
GRANT SELECT, UPDATE ON producto TO rol_inventario;
GRANT SELECT, UPDATE ON inventario TO rol_inventario;

-- rol_admin puede hacer todo
GRANT CONTROL ON DATABASE::Supermercado TO rol_admin;

-- Crear usuarios (sin login) para la base de datos Supermercado
CREATE USER nombre_usuario WITHOUT LOGIN;
CREATE USER nombre_admin WITHOUT LOGIN;

-- Asignar un usuario a un rol
ALTER ROLE rol_ventas ADD MEMBER nombre_usuario;
ALTER ROLE rol_admin ADD MEMBER nombre_admin;

-- Revision de logs
CREATE TABLE log_cambios_producto (
    id_log INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT,
    accion NVARCHAR(50),
    fecha DATETIME DEFAULT GETDATE()
);

GO

CREATE TRIGGER trg_producto_update
ON producto
AFTER UPDATE
AS
BEGIN
    INSERT INTO log_cambios_producto (id_producto, accion)
    SELECT id_producto, 'UPDATE' FROM inserted;
END


CREATE TRIGGER trg_producto_insert
ON producto
AFTER INSERT
AS
BEGIN
    INSERT INTO log_cambios_producto (id_producto, accion)
    SELECT id_producto, 'INSERT' FROM inserted;
END;
GO

CREATE TRIGGER trg_producto_delete
ON producto
AFTER DELETE
AS
BEGIN
    INSERT INTO log_cambios_producto (id_producto, accion)
    SELECT id_producto, 'DELETE' FROM deleted;
END;
GO

-- Ver usuarios que hacen cambios
ALTER TABLE log_cambios_producto ADD usuario NVARCHAR(100);
GO

-- Ver las conexiones actuales
SELECT session_id, login_name, status, host_name, program_name
FROM sys.dm_exec_sessions
WHERE is_user_process = 1;
GO

-- Insertar producto para prueba
INSERT INTO producto (nombre, descripcion, precio_compra, precio_venta, id_categoria, id_proveedor)
VALUES ('Producto Test', 'Descripcion', 10, 15, 1, 1);

-- Actualizar producto
UPDATE producto SET precio_venta = 20 WHERE nombre = 'Producto Test';

-- Eliminar producto
DELETE FROM producto WHERE nombre = 'Producto Test';

-- Consultar logs
SELECT 
    l.id_log,
    l.id_producto,
    p.nombre AS nombre_producto,
    l.accion,
    l.usuario,
    l.fecha
FROM log_cambios_producto l
LEFT JOIN producto p ON l.id_producto = p.id_producto
ORDER BY l.fecha DESC;
GO
-- Revision de los logs
SELECT * FROM log_cambios_producto ORDER BY fecha DESC;
GO

-- Pruebas de vulnerabilidad
--  Usuarios con roles y permisos
SELECT dp.name AS Usuario, r.name AS Rol
FROM sys.database_principals dp
LEFT JOIN sys.database_role_members drm ON dp.principal_id = drm.member_principal_id
LEFT JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
WHERE dp.type NOT IN ('R', 'C')
ORDER BY Usuario;

--  Permisos peligrosos asignados (como CONTROL o ALTER)
SELECT princ.name, perm.permission_name, OBJECT_NAME(perm.major_id) AS Objeto
FROM sys.database_permissions perm
JOIN sys.database_principals princ ON perm.grantee_principal_id = princ.principal_id
WHERE perm.permission_name IN ('CONTROL', 'ALTER')
ORDER BY princ.name;

--  Conexiones activas para detectar accesos extraños
SELECT session_id, login_name, status, host_name, program_name
FROM sys.dm_exec_sessions
WHERE is_user_process = 1;

--  Revisión rápida de logs de cambios
SELECT TOP 10 * FROM log_cambios_producto ORDER BY fecha DESC;
GO

-- GEstión de datos sensibles
ALTER TABLE cliente
ALTER COLUMN cedula NVARCHAR(10) MASKED WITH (FUNCTION = 'partial(0,"XXXXXXX",3)') NOT NULL;

ALTER TABLE cliente
ALTER COLUMN email NVARCHAR(100) MASKED WITH (FUNCTION = 'email()') NULL;
GO


-- Insertar datos de prueba
INSERT INTO cliente (nombre, cedula, email, telefono)
VALUES ('Juanito Perez', '1234567890', 'juan.perez@mail.com', '0999999999');
GO

-- Consultar como usuario normal 
SELECT id_cliente, nombre, cedula, email FROM cliente;
GO

-- Crear login y usuario para prueba
CREATE LOGIN prueba_masking WITH PASSWORD = 'Prueba@123';
USE Supermercado;
CREATE USER prueba_masking FOR LOGIN prueba_masking;
GRANT SELECT ON cliente TO prueba_masking;
GO

-- Consulta simulada con el usuario de prueba
EXECUTE AS USER = 'prueba_masking';
SELECT id_cliente, nombre, cedula, email FROM cliente;
REVERT;
GO


-- DESARROLLADOR DE CONSULTAS
-- COnstrucción de vistas eficientes
CREATE VIEW vw_ventas_detalle
AS
SELECT 
    v.id_venta,
    v.fecha,
    c.nombre AS cliente,
    e.nombre AS empleado,
    p.nombre AS producto,
    dv.cantidad,
    dv.precio_unitario,
    dv.subtotal
FROM venta v
LEFT JOIN cliente c ON v.id_cliente = c.id_cliente
LEFT JOIN empleado e ON v.id_empleado = e.id_empleado
INNER JOIN detalle_venta dv ON v.id_venta = dv.id_venta
INNER JOIN producto p ON dv.id_producto = p.id_producto;

-- Probando
SELECT * FROM vw_ventas_detalle;
-- ventas de un cliente específico
SELECT * FROM vw_ventas_detalle WHERE cliente = 'Juan Pérez';
-- O ventas en una fecha específica
SELECT * FROM vw_ventas_detalle WHERE fecha >= '2025-01-01';

-- Reporte complejo
SELECT 
    e.nombre AS empleado,
    p.nombre AS producto,
    SUM(dv.cantidad) AS total_cantidad,
    SUM(dv.subtotal) AS total_ventas
FROM venta v
JOIN detalle_venta dv ON v.id_venta = dv.id_venta
JOIN empleado e ON v.id_empleado = e.id_empleado
JOIN producto p ON dv.id_producto = p.id_producto
WHERE v.fecha >= DATEADD(MONTH, -1, GETDATE())
GROUP BY e.nombre, p.nombre
ORDER BY total_ventas DESC;

-- Procedimiento almacenado reutilizable
CREATE PROCEDURE sp_ventas_por_cliente
    @id_cliente INT,
    @fecha_inicio DATE,
    @fecha_fin DATE
AS
BEGIN
    SELECT v.id_venta, v.fecha, v.total
    FROM venta v
    WHERE v.id_cliente = @id_cliente
      AND v.fecha BETWEEN @fecha_inicio AND @fecha_fin
    ORDER BY v.fecha;
END;
--Probando
EXEC sp_ventas_por_cliente @id_cliente = 1, @fecha_inicio = '2025-01-01', @fecha_fin = '2025-12-31';
GO
-- Función reutilizable
CREATE FUNCTION fn_descuento_producto (
    @id_venta INT,
    @id_producto INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @descuento DECIMAL(5,2);
    
    SELECT @descuento = ISNULL(pp.descuento, 0)
    FROM detalle_venta dv
    LEFT JOIN producto_promocion pp ON dv.id_producto = pp.id_producto
    WHERE dv.id_venta = @id_venta AND dv.id_producto = @id_producto;
    
    RETURN @descuento;
END;
-- Probando
-- Asegúrate de tener un producto y una venta
SELECT TOP 5 id_venta, id_producto FROM detalle_venta WHERE id_producto = 1;
SELECT dbo.fn_descuento_producto(1, 1) AS descuento_aplicado;
GO

-- Usuario final
CREATE VIEW vw_ventas_detalle
AS
SELECT 
    v.id_venta,
    v.fecha,
    c.nombre AS cliente,
    e.nombre AS empleado,
    p.nombre AS producto,
    dv.cantidad,
    dv.precio_unitario,
    dv.subtotal
FROM venta v
LEFT JOIN cliente c ON v.id_cliente = c.id_cliente
LEFT JOIN empleado e ON v.id_empleado = e.id_empleado
INNER JOIN detalle_venta dv ON v.id_venta = dv.id_venta
INNER JOIN producto p ON dv.id_producto = p.id_producto;
GO
-- Dando permisos
GRANT SELECT ON vw_ventas_detalle TO usuario_cliente;
GO

EXECUTE AS USER = 'usuario_cliente';
SELECT * FROM vw_ventas_detalle;
REVERT;
GO
-- Otra prueba
EXECUTE AS USER = 'usuario_cliente';
SELECT id_venta, cliente, producto, cantidad, subtotal 
FROM vw_ventas_detalle
WHERE fecha > '2025-01-01';
REVERT;