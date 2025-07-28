CREATE DATABASE Supermercado;
GO

USE Supermercado;
GO

-- Tabla 1: cliente
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    cedula NVARCHAR(10) NOT NULL UNIQUE CHECK (LEN(cedula) = 10),
    email NVARCHAR(100) UNIQUE,
    telefono NVARCHAR(20)
);

-- Tabla 2: empleado 
CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(20),
    fecha_contratacion DATE DEFAULT GETDATE()
);

-- Tabla 3: marca
CREATE TABLE marca (
    id_marca INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL UNIQUE,
    pais_origen NVARCHAR(50)
);

-- Tabla 4: categoria
CREATE TABLE categoria (
    id_categoria INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL UNIQUE,
    descripcion NVARCHAR(255)
);

-- Tabla 5: proveedor
CREATE TABLE proveedor (
    id_proveedor INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(20),
    direccion NVARCHAR(150)
);

-- Tabla 6: producto
CREATE TABLE producto (
    id_producto INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(255),
    precio_compra DECIMAL(10,2) NOT NULL CHECK (precio_compra > 0),
    precio_venta DECIMAL(10,2) NOT NULL CHECK (precio_venta > 0),
    id_marca INT,
    id_categoria INT NOT NULL,
    id_proveedor INT NOT NULL, 

    FOREIGN KEY (id_marca) REFERENCES marca(id_marca) ON DELETE SET NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor) -- clave foránea directa
);


-- Tabla 7: inventario 
CREATE TABLE inventario (
    id_inventario INT PRIMARY KEY IDENTITY(1,1),
    id_producto INT NOT NULL UNIQUE,
    stock_actual INT NOT NULL CHECK (stock_actual >= 0) DEFAULT 0,
    stock_minimo INT NOT NULL CHECK (stock_minimo >= 0) DEFAULT 10,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE
);

-- Tabla 8: venta
CREATE TABLE venta (
    id_venta INT PRIMARY KEY IDENTITY(1,1),
    fecha DATETIME NOT NULL DEFAULT GETDATE(),
    total DECIMAL(10,2) NOT NULL CHECK (total >= 0),
    id_cliente INT,
    id_empleado INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE SET NULL,
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

-- Tabla 9: detalle_venta 
CREATE TABLE detalle_venta (
    id_detalle INT PRIMARY KEY IDENTITY(1,1),
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario > 0),
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    FOREIGN KEY (id_venta) REFERENCES venta(id_venta) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- Tabla 10: promocion 
CREATE TABLE promocion (
    id_promocion INT PRIMARY KEY IDENTITY(1,1),
    descripcion NVARCHAR(255),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    CHECK (fecha_fin > fecha_inicio)
);

-- Tabla 11: producto_promocion
CREATE TABLE producto_promocion (
    id_promocion INT NOT NULL,
    id_producto INT NOT NULL,
    descuento DECIMAL(5,2) NOT NULL CHECK (descuento BETWEEN 0 AND 100),
    PRIMARY KEY (id_promocion, id_producto),
    FOREIGN KEY (id_promocion) REFERENCES promocion(id_promocion) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE
);


-- Datos para la tabla marca
INSERT INTO marca (nombre, pais_origen) VALUES
('Supermaxi', 'Ecuador'),
('Mi Comisariato', 'Ecuador'),
('Granja Victoria', 'Ecuador'),
('Toni', 'Ecuador'),
('La Fabril', 'Ecuador'),
('Pilsener', 'Ecuador'),
('La Universal', 'Ecuador'),
('Fybeca', 'Ecuador'),
('Pronaca', 'Ecuador'),
('La Favorita', 'Ecuador'),
('Nestlé', 'Suiza'),
('Coca-Cola', 'EE.UU.'),
('Unilever', 'Reino Unido'),
('Knorr', 'Alemania'),
('Maggi', 'Suiza'),
('Frito Lay', 'EE.UU.'),
('La Ibérica', 'Ecuador'),
('Tía', 'Ecuador'),
('Marinela', 'México'),
('Dorina', 'Ecuador'),
('Lays', 'EE.UU.'),
('Act II', 'EE.UU.'),
('San Francisco', 'Ecuador');


-- Datos para la tabla categoría
INSERT INTO categoria (nombre, descripcion) VALUES
('Lácteos', 'Leche, quesos y derivados'),
('Bebidas', 'Refrescos, jugos y aguas'),
('Abarrotes', 'Productos básicos de despensa'),
('Carnes', 'Carnes frescas y procesadas'),
('Frutas/Verduras', 'Productos frescos'),
('Limpieza', 'Artículos de limpieza del hogar'),
('Higiene', 'Productos de cuidado personal'),
('Panadería', 'Pan y productos de repostería'),
('Congelados', 'Alimentos congelados'),
('Snacks', 'Botanas y pasapalos'),
('Dulces', 'Chocolates y caramelos'),
('Enlatados', 'Conservas y alimentos enlatados'),
('Bebé', 'Productos para bebés'),
('Mascotas', 'Alimentos para mascotas'),
('Electro', 'Pequeños electrodomésticos');


-- Datos para la tabla proveedor
INSERT INTO proveedor (nombre, telefono, direccion) VALUES
('Distribuidora Andina', '022345678', 'Av. Amazonas N34-122, Quito'),
('Alimentos Ecuador', '022987654', 'Av. Occidental 456, Quito'),
('Lácteos del Valle', '022111222', 'Autopista Norte Km 5, Quito'),
('Carnes Premium SA', '022333444', 'Av. Mariscal Sucre Oe1-23, Quito'),
('Importadora Clean', '022555666', 'Av. 10 de Agosto N20-34, Quito'),
('Distribuidora Hogar', '022777888', 'Av. América N32-145, Quito'),
('Panadería La Moderna', '022999000', 'Av. 6 de Diciembre N24-56, Quito'),
('Congelados Polar', '022123456', 'Av. Río Coca E12-34, Quito'),
('Electro Import', '022654321', 'Av. Eloy Alfaro N45-67, Quito'),
('Higiene Personal SA', '022789012', 'Av. de los Shyris N41-28, Quito');

-- Datos para la tabla producto
INSERT INTO producto (nombre, descripcion, precio_compra, precio_venta, id_marca, id_categoria, id_proveedor) VALUES
('Leche Entera Vita', 'Leche entera en caja 1L', 0.85, 1.20, 4, 1, 3),
('Yogurt Natural La Favorita', 'Yogurt natural 200g', 0.45, 0.75, 10, 1, 3),
('Queso Fresco Pronaca', 'Queso fresco 500g', 2.50, 3.50, 9, 1, 3),
('Mantequilla La Fabril', 'Mantequilla con sal 250g', 1.20, 1.80, 5, 1, 3),
('Leche Deslactosada Toni', 'Leche sin lactosa 1L', 1.00, 1.40, 4, 1, 3),
('Agua Mineral Tesalia', 'Agua sin gas 500ml', 0.30, 0.50, 10, 2, 1),
('Gaseosa Coca-Cola', 'Refresco de cola 1L', 0.70, 1.00, 12, 2, 1),
('Jugo de Naranja Tang', 'Jugo en polvo 500g', 1.20, 1.80, 11, 2, 1),
('Arroz Supremo', 'Arroz grano largo 1kg', 0.80, 1.20, 10, 3, 2),
('Aceite La Fabril', 'Aceite vegetal 1L', 1.50, 2.00, 5, 3, 2),
('Pechuga de Pollo Pronaca', 'Pechuga fresca por kg', 3.50, 4.90, 9, 4, 4),
('Carne Molida La Favorita', 'Carne molida de res 500g', 4.20, 5.80, 10, 4, 4),
('Manzanas Delicia', 'Manzanas rojas por kg', 1.20, 1.80, NULL, 5, 2),
('Lechuga Fresca', 'Lechuga orgánica', 0.50, 0.90, NULL, 5, 2),
('Detergente Ace', 'Detergente líquido 1L', 2.50, 3.50, 13, 6, 5),
('Cloro Magia Blanca', 'Cloro líquido 1L', 0.80, 1.20, 10, 6, 5),
('Shampoo Pantene', 'Shampoo reparación 400ml', 3.50, 4.90, 15, 7, 10),
('Jabón Líquido Dove', 'Jabón líquido 250ml', 2.80, 3.90, 16, 7, 10),
('Pan Integral Moderna', 'Pan integral 500g', 1.50, 2.20, 7, 8, 7),
('Pan de Avena San Francisco', 'Pan de avena 400g', 1.80, 2.50, 23, 8, 7),
('Pizza Congelada Polar', 'Pizza de pepperoni 400g', 4.20, 6.00, 8, 9, 8),
('Helado Toni', 'Helado de vainilla 1L', 3.80, 5.40, 4, 9, 8),
('Papas Fritas Lay''s', 'Papas fritas 150g', 1.20, 1.80, 21, 10, 1),
('Palomitas Act II', 'Palomitas para microondas', 1.50, 2.20, 22, 10, 1),
('Chocolate Nestlé', 'Tableta de chocolate 100g', 2.50, 3.60, 11, 11, 1),
('Caramelos Adams', 'Caramelos surtidos 200g', 1.80, 2.60, 19, 11, 1),
('Atún Real en Aceite', 'Atún en aceite 200g', 1.50, 2.20, 9, 12, 2),
('Sardinas La Sirena', 'Sardinas en aceite 125g', 1.20, 1.80, 17, 12, 2),
('Pañales Huggies', 'Pañales etapa 3 30un', 8.50, 12.00, 11, 13, 6),
('Toallitas Huggies', 'Toallitas húmedas 80un', 7.80, 11.00, 11, 13, 6),
('Croquetas Dog Chow', 'Alimento para perro 3kg', 6.50, 9.00, 11, 14, 6),
('Alimento Cat Chow', 'Alimento para gato 2kg', 5.80, 8.20, 16, 14, 6),
('Ventilador de Mesa', 'Ventilador 16"', 15.00, 22.00, 19, 15, 9),
('Licuadora Oster', 'Licuadora 600W', 25.00, 35.00, 18, 15, 9);


-- Datos para la tabla inventario
INSERT INTO inventario (id_producto, stock_actual, stock_minimo) VALUES
(1, 50, 10), (2, 40, 8), (3, 30, 5), (4, 60, 15), (5, 45, 10),
(6, 35, 7), (7, 25, 5), (8, 40, 8), (9, 30, 6), (10, 50, 10),
(11, 45, 9), (12, 55, 11), (13, 65, 13), (14, 35, 7), (15, 40, 8),
(16, 30, 6), (17, 25, 5), (18, 50, 10), (19, 45, 9), (20, 60, 12),
(21, 70, 14), (22, 40, 8), (23, 35, 7), (24, 30, 6), (25, 25, 5),
(26, 50, 10), (27, 45, 9), (28, 40, 8), (29, 35, 7), (30, 30, 6),
(31, 25, 5), (32, 50, 10), (33, 45, 9), (34, 40, 8);

-- Clientes
INSERT INTO cliente (nombre, cedula, email, telefono) VALUES
('Juan Pérez', '1701234567', 'juan.perez@gmail.com', '0991234567'),
('María Gómez', '1702345678', 'maria.gomez@outlook.com', '0992345678'),
('Carlos Andrade', '1703456789', 'carlos.andrade@gmail.com', '0993456789'),
('Ana Beltrán', '1704567890', 'ana.beltran@yahoo.com', '0994567890'),
('Luis Vásquez', '1705678901', 'luis.vasquez@hotmail.com', '0995678901');

-- Empleados
INSERT INTO empleado (nombre, telefono, fecha_contratacion) VALUES
('Mónica Patricia Zurita', '0832109876', '2023-03-15'),
('Ricardo Andrés Zambrano', '0821098765', '2023-04-20'),
('Verónica Elizabeth Ponce', '0810987654', '2023-05-10');

-- Ventas (solo 5 para evitar conflictos)
INSERT INTO venta (fecha, total, id_cliente, id_empleado) VALUES
('2023-07-01 09:00:00', 18.75, 1, 1),
('2023-07-01 10:15:00', 7.90, 2, 2),
('2023-07-01 11:30:00', 24.50, 3, 3),
('2023-07-01 14:45:00', 6.25, NULL, 1),
('2023-07-01 16:30:00', 19.30, 4, 2);

-- Detalle venta solo para productos existentes
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, subtotal) VALUES
(1, 1, 2, 1.20, 2.40), (1, 6, 1, 0.50, 0.50), (1, 11, 1, 4.90, 4.90),
(2, 2, 1, 0.75, 0.75), (2, 7, 2, 1.00, 2.00),
(3, 3, 1, 3.50, 3.50), (3, 8, 1, 1.80, 1.80), (3, 13, 2, 1.80, 3.60),
(4, 4, 1, 1.80, 1.80), (4, 9, 1, 1.20, 1.20),
(5, 5, 1, 1.40, 1.40), (5, 10, 1, 2.00, 2.00), (5, 15, 1, 3.50, 3.50);

-- Promociones
INSERT INTO promocion (descripcion, fecha_inicio, fecha_fin) VALUES
('Descuento en Lácteos', '2023-06-01', '2023-06-30'),
('2x1 en Bebidas', '2023-06-15', '2023-06-30'),
('Oferta de Carnes', '2023-06-10', '2023-06-25'),
('Promoción de Limpieza', '2023-06-01', '2023-06-15'),
('Oferta de Panadería', '2023-06-10', '2023-06-30');

-- Producto_Promocion solo para productos existentes
INSERT INTO producto_promocion (id_promocion, id_producto, descuento) VALUES
(1, 1, 15.00), (1, 2, 10.00), (1, 3, 12.00),
(2, 6, 50.00), (2, 7, 40.00), (2, 8, 30.00),
(3, 11, 20.00), (3, 12, 15.00),
(4, 15, 30.00), (4, 16, 25.00),
(5, 19, 20.00), (5, 20, 15.00);


-- CONSULTAS
-- Joins

-- 1.   Productos con información completa.

SELECT p.id_producto, p.nombre AS Producto, m.nombre AS Marca, 
       c.nombre AS Categoria, pr.nombre AS Proveedor, 
       p.precio_venta, i.stock_actual
FROM producto p
JOIN marca m ON p.id_marca = m.id_marca
JOIN categoria c ON p.id_categoria = c.id_categoria
JOIN proveedor pr ON p.id_proveedor = pr.id_proveedor
JOIN inventario i ON p.id_producto = i.id_producto;


-- 2.   Clientes con más compras realizadas.

SELECT c.id_cliente, c.nombre AS cliente, COUNT(v.id_venta) AS total_compras
FROM cliente c
JOIN venta v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre
ORDER BY total_compras DESC;


-- 3.	Productos en promoción.

SELECT p.nombre as Producto, p.precio_venta as Precio_Inicial, prom.descuento,
		p.precio_venta * (1-prom.descuento/100) as Precio_Final
FROM producto p
JOIN producto_promocion prom ON p.id_producto = prom.id_producto
JOIN promocion pr ON prom.id_promocion = pr.id_promocion
ORDER BY prom.descuento DESC;


-- 4.	Productos con stock bajo.

SELECT p.nombre as Producto, i.stock_actual, i.stock_minimo,
		pr.nombre as Proveedor, pr.telefono as Contacto_Proveedor
FROM inventario i
JOIN producto p ON i.id_producto = p.id_producto
JOIN proveedor pr ON p.id_proveedor = pr.id_proveedor
WHERE i.stock_actual < i.stock_minimo;


-- 5.	Ventas con sus clientes, productos y categorías (solo de los clientes asociados).

SELECT v.id_venta, v.fecha, c.nombre as Cliente, p.nombre as Producto,
		ct.nombre as Categoria
FROM venta v
JOIN cliente c ON v.id_cliente = c.id_cliente
JOIN detalle_venta dv ON v.id_venta = dv.id_venta
JOIN producto p ON dv.id_producto = p.id_producto
JOIN categoria ct ON p.id_categoria = ct.id_categoria;


-- FUNCIONES

-- 1.	Función para calcular el IVA de una compra.

CREATE FUNCTION dbo.ObtenerTotalConIVA( @id_cliente INT,
    @porcentaje_iva DECIMAL(5,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total_con_iva DECIMAL(10,2);
    IF @porcentaje_iva < 0 OR @porcentaje_iva > 100
    BEGIN
        RETURN 0; 
    END
    SELECT @total_con_iva = SUM(v.total) * (1 + (@porcentaje_iva/100))
    FROM venta v
    WHERE v.id_cliente = @id_cliente;
    RETURN ISNULL(@total_con_iva, 0);
END;

-- Uso de la función dbo.ObtenerTotalConIVA

SELECT dbo.ObtenerTotalConIVA(2, 12.00) AS Total_Con_IVA;


-- 2.	Función para consultar el stock del producto.

CREATE FUNCTION dbo.ObtenerStockProducto(@id_producto INT)
RETURNS INT
AS
BEGIN
	DECLARE @stock INT
	SELECT @stock = stock_actual FROM inventario
	WHERE id_producto = @id_producto
	RETURN @stock
END;

-- Uso de la función ObtenerStockProducto

SELECT dbo.ObtenerStockProducto(8) AS Stock_Producto;


-- 3.	Función para obtener el total de productos por categoría.

CREATE FUNCTION dbo.ProductosPorCategoria(@id_categoria INT)
RETURNS INT
AS 
BEGIN
	DECLARE @cantidad INT
	SELECT @cantidad = COUNT(*)
	FROM producto
	WHERE id_categoria = @id_categoria
	RETURN @cantidad
END;

-- Uso de la función dbo.ProductosPorCategoria

SELECT dbo.ProductosPorCategoria(10) AS Total_Productos;


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


-- Prueba del trigger creado
INSERT INTO producto (nombre, descripcion, precio_compra, precio_venta, id_marca, id_categoria, id_proveedor)
VALUES ('Yogurt de Durazno con Chispas', 'Edicion limitada', 10.50, 15.99, 1, 1, 1);

-- Verificar el registro en la tabla de auditoria
SELECT * FROM log_auditoria_productos WHERE accion = 'INSERT';


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

-- Prueba del Trigger
UPDATE producto 
SET precio_venta = precio_venta * 1.2
WHERE id_producto = 14;

SELECT * FROM notificaciones_sensibles;



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


-- Prueba del trigger
INSERT INTO marca (nombre, pais_origen)
VALUES ('Manicho', 'Ecuador');

SELECT * FROM historico_marcas;