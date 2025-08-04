use Supermercado;
go

-- Trigger historico para la tabla marca

CREATE TRIGGER tr_historico_marcas
ON marca
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Para Insert
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO historico_marcas (id_marca, accion, nombre_nuevo, pais_nuevo )
        SELECT id_marca, 'INSERT', nombre, pais_origen
        FROM inserted;
    END
    
    -- Para Update
    ELSE IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO historico_marcas ( id_marca, accion,  nombre_anterior, nombre_nuevo, pais_anterior, pais_nuevo)
        SELECT  i.id_marca, 'UPDATE', d.nombre, i.nombre, d.pais_origen, i.pais_origen
        FROM inserted i
        JOIN deleted d ON i.id_marca = d.id_marca;
    END
    
    -- Para Delete
    ELSE IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO historico_marcas (id_marca, accion, nombre_anterior, pais_anterior)
        SELECT  id_marca, 'DELETE', nombre, pais_origen
        FROM deleted;
    END
END;
GO

-- Prueba del trigger
INSERT INTO marca (nombre, pais_origen)
VALUES ('Manicho', 'Ecuador');

SELECT * FROM historico_marcas;



-- En caso de necesitar
DROP ROLE rol_administrador;
DROP ROLE rol_auditor;
DROP ROLE rol_operador;
DROP ROLE rol_cliente;
DROP ROLE rol_proveedor;
DROP ROLE rol_usuario_final;


-- SEGURIDAD Y ROLES

-- Creacion de logins a nivel de servidor
CREATE LOGIN usuario_admin WITH PASSWORD = 'admin@123';
CREATE LOGIN usuario_auditor WITH PASSWORD = 'auditor@123';
CREATE LOGIN usuario_operador WITH PASSWORD = 'operador@123';
CREATE LOGIN usuario_cliente WITH PASSWORD = 'cliente@123';
CREATE LOGIN usuario_proveedor WITH PASSWORD = 'proveedor@123';


-- Creacion de usuarios
CREATE USER usuario_admin FOR LOGIN usuario_admin;
CREATE USER usuario_auditor FOR LOGIN usuario_auditor;
CREATE USER usuario_operador FOR LOGIN usuario_operador;
CREATE USER usuario_cliente FOR LOGIN usuario_cliente;
CREATE USER usuario_proveedor FOR LOGIN usuario_proveedor;
GO

-- Roles con permisos personalizados
-- Administrador
CREATE ROLE rol_administrador;
GRANT CONTROL ON DATABASE::Supermercado TO rol_administrador;
GO


-- Auditor
CREATE ROLE rol_auditor;
GRANT SELECT ON SCHEMA::dbo TO rol_auditor;
GRANT SELECT ON log_auditoria_productos TO rol_auditor;
GRANT SELECT ON notificaciones_sensibles TO rol_auditor;
GRANT SELECT ON historico_marcas TO rol_auditor;
GO

-- Operador
CREATE ROLE rol_operador;
GRANT SELECT, INSERT, UPDATE ON producto TO rol_operador;
GRANT SELECT, INSERT, UPDATE ON inventario TO rol_operador;
GRANT SELECT, INSERT ON venta TO rol_operador;
GRANT SELECT, INSERT ON detalle_venta TO rol_operador;
GRANT SELECT ON cliente TO rol_operador;
GRANT SELECT ON empleado TO rol_operador;
GO


-- Cliente
CREATE ROLE rol_cliente;
GRANT SELECT ON producto TO rol_cliente;
GRANT SELECT ON promocion TO rol_cliente;
GRANT SELECT ON producto_promocion TO rol_cliente;
GO

-- Proveedor
CREATE ROLE rol_proveedor;
GO

-- Vista para limitar el acceso del proveedor
CREATE VIEW vista_inventario_proveedor AS
SELECT p.id_producto, p.nombre, i.stock_actual
FROM producto p
JOIN inventario i ON p.id_producto = i.id_producto
WHERE p.nombre = SYSTEM_USER;
GO

GRANT SELECT ON vista_inventario_proveedor TO rol_proveedor;
GO

-- Usuario final
CREATE ROLE rol_usuario_final;
GRANT SELECT ON producto TO rol_usuario_final;
GRANT SELECT ON promocion TO rol_usuario_final;
GO


-- Asignacion de usuarios a roles
ALTER ROLE rol_administrador ADD MEMBER usuario_admin;
ALTER ROLE rol_auditor ADD MEMBER usuario_auditor;
ALTER ROLE rol_operador ADD MEMBER usuario_operador;
ALTER ROLE rol_cliente ADD MEMBER usuario_cliente;
ALTER ROLE rol_proveedor ADD MEMBER usuario_proveedor;
GO

-- Restriccion para mayor seguridad
DENY VIEW DEFINITION TO usuario_cliente, usuario_proveedor;
GO


-- ENCRIPTACION DE DATOS
-- Clave para la base de datos
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Super@123';

-- Se agregan columnas en la tabla de clientes actual para visualizar la encriptacion de los campos
ALTER TABLE cliente
ADD cedula_cifrada VARBINARY(MAX), email_cifrado VARBINARY(MAX), telefono_cifrado VARBINARY(MAX);
GO

UPDATE cliente
SET 
	cedula_cifrada = ENCRYPTBYPASSPHRASE('Super@123', cedula),
    email_cifrado = ENCRYPTBYPASSPHRASE('Super@123', email),
    telefono_cifrado = ENCRYPTBYPASSPHRASE('Super@123', telefono);
GO


-- Descifrado de datos
SELECT id_cliente, nombre, 
CONVERT(nvarchar, DECRYPTBYPASSPHRASE('Super@123', cedula_cifrada)) AS cedula, 
CONVERT(nvarchar, DECRYPTBYPASSPHRASE('Super@123', email_cifrado)) AS email,
CONVERT(nvarchar, DECRYPTBYPASSPHRASE('Super@123', telefono_cifrado)) AS telefono
FROM cliente;
GO

-- Se habilitan las opciones avanzadas que permitiran la simulacion de conexion segura
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

-- SIMULACIÓN DE CONEXIÓN SEGURA (SSL/TLS)
--EXEC sp_configure 'force protocol encryption', 1;
--RECONFIGURE;
--GO

--  REGISTRO DE INTENTOS FALLIDOS O SOSPECHOSOS
CREATE TABLE registro_intentos_fallidos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    usuario NVARCHAR(100),
    evento NVARCHAR(255),
    fecha DATETIME DEFAULT GETDATE()
);
GO

-- Ejemplo de inserción simulada
INSERT INTO registro_intentos_fallidos (usuario, evento)
VALUES ('usuario_cliente', 'Intento de acceso a tabla inventario sin privilegios');


-- VALIDACIONES COM EXPRESIONES REGULARES
--ALTER TABLE cliente
--ADD CONSTRAINT chk_email_valido CHECK(email_cifrado IS NULL OR email_cifrado LIKE '%@%.%');

-- AUDITORÍA DE PRIVILEGIOS ACTIVOS Y ROLES
SELECT r.name AS rol, m.name AS usuario
FROM sys.database_principals r
JOIN sys.database_role_members rm ON r.principal_id = rm.role_principal_id
JOIN sys.database_principals m ON rm.member_principal_id = m.principal_id;



