use Supermercado;
go
-- TRIGGERS

-- 1.   Creacion de una tabla para auditorias
CREATE TABLE log_auditoria_productos (
    id_log INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    accion VARCHAR(10) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT GETDATE(),
    usuario VARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    datos_anteriores NVARCHAR(MAX),
    datos_nuevos NVARCHAR(MAX)
);

GO

-- 2.	Trigger para registrar todas las acciones realizadas en la tabla producto

CREATE TRIGGER tr_auditoria_productos ON producto
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Para Actualizaciones
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO log_auditoria_productos (id_producto, accion, datos_anteriores, 
			datos_nuevos)
        SELECT d.id_producto,'UPDATE', (SELECT d.* FOR JSON PATH), (SELECT i.* FOR JSON PATH)
        FROM deleted d
        JOIN inserted i ON d.id_producto = i.id_producto;
    END
    
    -- Para Inserciones
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO log_auditoria_productos (id_producto, accion, datos_nuevos)
        SELECT id_producto, 'INSERT', (SELECT i.* FOR JSON PATH)
        FROM inserted i;
    END
    
    -- Para Eliminaciones
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO log_auditoria_productos (id_producto, accion, datos_anteriores)
        SELECT id_producto, 'DELETE', (SELECT d.* FOR JSON PATH)
        FROM deleted d;
    END
END;

GO

-- Prueba del trigger creado
INSERT INTO producto (nombre, descripcion, precio_compra, precio_venta, id_marca, id_categoria, id_proveedor)
VALUES ('Yogurt de Durazno con Chispas', 'Edicion limitada', 10.50, 15.99, 1, 1, 1);

-- Verificar el registro en la tabla de auditoria
SELECT * FROM log_auditoria_productos WHERE accion = 'INSERT';

GO

-- 3.   Trigger para controlar el stock

CREATE TRIGGER tr_actualizar_inventario ON detalle_venta
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE i
    SET stock_actual = i.stock_actual - d.cantidad
    FROM inventario i
    JOIN inserted d ON i.id_producto = d.id_producto;

    -- Validacion para que no haya stock negativo
    IF EXISTS (
        SELECT 1 FROM inventario i
        JOIN inserted d ON i.id_producto = d.id_producto
        WHERE i.stock_actual < 0
    )
    BEGIN
        RAISERROR('Stock insuficiente para la venta.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

GO

-- 4.   Trigger para notificaciones sencibles

-- Tabla para registrar las notificaciones
CREATE TABLE notificaciones_sensibles (
    id_notificacion INT IDENTITY(1,1) PRIMARY KEY,
    tipo_accion VARCHAR(50) NOT NULL,
    tabla_afectada VARCHAR(50) NOT NULL,
    id_registro INT,
    descripcion NVARCHAR(500) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT GETDATE(),
    usuario VARCHAR(100) NOT NULL DEFAULT SYSTEM_USER
);

GO

-- Trigger para registrar cambios sensibles en precios
CREATE TRIGGER tr_notificar_cambios_precios
ON producto
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Solo si cambió el precio de venta
    IF UPDATE(precio_venta)
    BEGIN
        INSERT INTO notificaciones_sensibles ( tipo_accion, tabla_afectada, id_registro, descripcion )
        SELECT 'CAMBIO DE PRECIO', 'producto', i.id_producto, 'Producto: ' + i.nombre + ' ; Precio Anterior: ' + 
            CAST(d.precio_venta AS VARCHAR) + ' ;Precio Actual: ' + CAST(i.precio_venta AS VARCHAR)
        FROM inserted i
        JOIN deleted d ON i.id_producto = d.id_producto
        WHERE i.precio_venta <> d.precio_venta;
    END
END;

GO

-- Prueba del Trigger
UPDATE producto 
SET precio_venta = precio_venta * 1.2
WHERE id_producto = 14;

-- Uson con un rol
-- EXECUTE AS USER = 'auditor';
-- SELECT * FROM notificaciones_sensibles;
-- REVERT;



-- 5.  Trigger historico para la tabla marcas

-- Creacion de la tabla para el registro
CREATE TABLE historico_marcas (
    id_historico INT IDENTITY(1,1) PRIMARY KEY,
    id_marca INT NOT NULL,
    fecha_cambio DATETIME NOT NULL DEFAULT GETDATE(),
    usuario VARCHAR(100) NOT NULL DEFAULT SYSTEM_USER,
    accion VARCHAR(10) NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE'
    nombre_anterior VARCHAR(100),
    nombre_nuevo VARCHAR(100),
    pais_anterior VARCHAR(50),
    pais_nuevo VARCHAR(50)
);

GO

