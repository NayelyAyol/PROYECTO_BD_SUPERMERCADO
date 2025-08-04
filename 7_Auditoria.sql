use Supermercado;
go

-- AUDITORÍA
-- Tabla Log
CREATE TABLE log_acciones (
	id_log INT PRIMARY KEY IDENTITY(1,1),
	usuario NVARCHAR(100),
	ip_origen NVARCHAR(100),
	fecha DATETIME DEFAULT GETDATE(),
	accion NVARCHAR(20),
	tabla NVARCHAR(100),
	id_afectado INT,
	rol_activo NVARCHAR(100),
	transaccion NVARCHAR(MAX),
	hash_cambio AS CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 
	CONCAT(usuario, accion, tabla, id_afectado, 
	CONVERT(VARCHAR, fecha, 120))), 2) PERSISTED
);
GO

-- Triggers para las operaciones clave

-- Tabla cliente
-- Trigger para INSERT
CREATE TRIGGER trg_insertar_cliente ON cliente
AFTER INSERT
AS
BEGIN
	INSERT INTO log_acciones (usuario, ip_origen, accion, tabla, id_afectado, rol_activo, transaccion)
    SELECT SYSTEM_USER, HOST_NAME(), 'INSERT', 'cliente', id_cliente, USER_NAME(), 'INSERT INTO cliente'
    FROM inserted;
END;
GO

-- Trigger para UPDATE
CREATE TRIGGER trg_actualizar_cliente ON cliente
AFTER UPDATE
AS
BEGIN
    INSERT INTO log_acciones (usuario, ip_origen, accion, tabla, id_afectado, rol_activo, transaccion)
    SELECT SYSTEM_USER, HOST_NAME(), 'UPDATE', 'cliente', id_cliente, USER_NAME(), 'UPDATE cliente'
    FROM inserted;
END;
GO

-- Trigger para DELETE
CREATE TRIGGER trg_eliminar_cliente ON cliente
AFTER DELETE
AS
BEGIN
	INSERT INTO log_acciones(usuario, ip_origen, accion, tabla, id_afectado, rol_activo, transaccion)
	SELECT SYSTEM_USER, HOST_NAME(), 'DELETE', 'cliente', id_cliente, USER_NAME(), 'DELETE cliente'
	FROM inserted;
END;
GO


-- REPORTE POR USUARIO, ACCION, MODULO O FECHA
-- Reporte por usuario
CREATE VIEW reporte_accion_usuario AS
SELECT usuario, accion, tabla, COUNT(*) AS total, MIN(fecha) AS primera_accion,
MAX(fecha) AS ultima_accion FROM log_acciones
GROUP BY usuario, accion, tabla;
GO


-- Control de versiones con hash
CREATE TABLE bitacora_precio_producto(
	id_bitacora INT PRIMARY KEY IDENTITY(1,1),
	id_producto INT,
	precio_anterior DECIMAL(10,2),
	precio_nuevo DECIMAL(10,2),
	fecha DATETIME DEFAULT GETDATE(),
	usuario NVARCHAR(100)
);
GO


-- Trigger para registrar los cambios
CREATE TRIGGER trg_actualizar_precio_producto ON producto
AFTER UPDATE
AS 
BEGIN
	INSERT INTO bitacora_precio_producto(id_producto, precio_anterior, precio_nuevo, usuario)
	SELECT i.id_producto, d.precio_venta, i.precio_venta, SYSTEM_USER
	FROM inserted i
	JOIN deleted d ON i.id_producto=d.id_producto
	WHERE i.precio_venta <> d.precio_venta;
END;
GO

CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
    id_empleado INT NOT NULL,
    usuario NVARCHAR(100) UNIQUE NOT NULL,
    clave VARBINARY(64) NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

-- Insertar el usuario 'carlos' con clave '12345' para el empleado con id_empleado = 1
INSERT INTO usuarios (id_empleado, usuario, clave)
VALUES (
    1,
    'carlos',
    HASHBYTES('SHA2_256', CONVERT(NVARCHAR(100), '12345'))
);


