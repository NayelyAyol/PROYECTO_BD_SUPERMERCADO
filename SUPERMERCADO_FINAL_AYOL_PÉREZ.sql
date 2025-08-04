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


USE Supermercado;
GO

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

CREATE PROCEDURE registrar_cliente
    @nombre NVARCHAR(100),
    @cedula NVARCHAR(10),
    @email NVARCHAR(100),
    @telefono NVARCHAR(20)
AS
BEGIN
    IF LEN(@cedula) != 10 OR ISNUMERIC(@cedula) = 0
    BEGIN
        RAISERROR('La cédula debe contener exactamente 10 dígitos numéricos.', 16, 1)
        RETURN
    END

    IF @email NOT LIKE '_%@_%._%' OR CHARINDEX(' ', @email) > 0
    BEGIN
        RAISERROR('Formato de correo electrónico inválido.', 16, 1)
        RETURN
    END

    INSERT INTO cliente (nombre, cedula, email, telefono)
    VALUES (@nombre, @cedula, @email, @telefono)
END
GO

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


use Supermercado;
go

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


use Supermercado;
go
-- PROCEDIMIENTOS ALMACENADOS
-- Inserciones cruzadas
-- 1) Insertar una venta si el cliente y el empleado existe previamente
create procedure Registrar_venta
	@fecha datetime,
	@id_cliente int,
	@id_empleado int,
	@total decimal(10,2)
as
begin
-- validar que al fecha sea correcta y no sea futura
	if @fecha > GETDATE()
	begin
		print 'Error: No se puede registrar una venta con una fecha futura';
		return;
	end
-- Validamos si el cliente existe
	if not exists (select 1 from cliente where id_cliente=@id_cliente)
	begin
		print 'El cliente no existe';
		return;
	end
-- Verificamos si el empleado existe
if not exists (select 1 from empleado where id_empleado=@id_empleado)
	begin 
		print 'El empleado no existe';
		return;
	end
-- Insertamos la venta si todo está correcto
	insert into venta(fecha, total, id_cliente,id_empleado) values
	(@fecha, @total, @id_cliente, @id_empleado);
end;
go

-- Verificando el funcionamiento
exec Registrar_venta 
    @fecha = '2025-07-31',
    @id_cliente = 1,
    @id_empleado = 2,
    @total = 30.50;
go

select * from venta where total=30.50;
go

------------------------------------------
exec Registrar_venta 
    @fecha = '2025-09-23',
    @id_cliente = 1,
    @id_empleado = 2,
    @total = 30.50;
go
------------------------------------------

-- Actualizaciones masivas por condición.
-- 2) Aumentar el stock minimo de un producto por categoría
create procedure ActualizarStockMinimoCategoria
	@id_categoria int,
	@nuevo_stock_minimo int 
as
begin
	-- Validar que el nuevo stck mínimo no sea menos a 0
	if @nuevo_stock_minimo <0
		begin
			print 'El stock mínimo no puede ser negativo';
			return;
		end
	-- Actualizar el stock mínimo de todos los datos dependiendo del id que se da
		update inventario
		set stock_minimo=@nuevo_stock_minimo
		where id_producto in(
			select id_producto from producto
			where id_categoria=@id_categoria);
		print 'Actualización masiva realizada de manera correcta';
end;
go
-- Para verificar 
exec ActualizarStockMinimoCategoria @id_categoria =2, @nuevo_stock_minimo= 7;
go

select i.id_producto, i.stock_minimo, p.nombre, p.id_categoria
from inventario i 
join producto p on i.id_producto = p.id_producto
where p.id_categoria=2; 
go

-----------------------------------------------------
exec ActualizarStockMinimoCategoria @id_categoria =2, @nuevo_stock_minimo= -3;
go
------------------------------------------------------

-- Eliminación segura
-- 3) Eliminacion de un cliente
create procedure Eliminar_Cliente
	@id_cliente int
as 
begin
-- Verificar si el cliente existe
	if not exists(select 1 from cliente where id_cliente=@id_cliente)
		begin 
			print 'El cleinte no existe';
			return;
		end
-- Verificar si el cliente tiene una venta registrada
	if not exists(select 1 from venta where id_cliente=@id_cliente)
		begin
			print 'El cliente no se puede eliminar, tiene ventas registradas';
			return;
		end
-- Eliminamos si todo está correcto
	delete from cliente where id_cliente=@id_cliente
	print 'El cliente ha sido eliminado correctamente';
end;
go

-- Verificar el funcionamiento
exec Eliminar_Cliente @id_cliente=3;
go 

select * from cliente where id_cliente=3;
go
-----------------------------------------------------------
exec Eliminar_Cliente @id_cliente=300;
go 

select * from cliente where id_cliente=300;
go
-----------------------------------------------------------

-- Generación de reportes por período.
-- 4) Reporte de ventas por perido
create procedure Reporte_Ventas_Periodo
	@fecha_inicio date,
	@fecha_fin date
as
begin
-- Validar que las fechas tengan sentido
	if @fecha_fin < @fecha_inicio
	begin
		print 'La fecha final no pued ser menor que la fecha de inicio';
		return;
	end
-- Mostar el reporte de ventas por periodo
	select id_venta, fecha, total from venta 
	where fecha between @fecha_inicio and @fecha_fin
	order by fecha; 
end; 
go 

-- Verificando el funcionamiento
exec Reporte_Ventas_Periodo
	@fecha_inicio = '2025-01-01',
	@fecha_fin='2025-12-31';
go
---------------------------------------------------------------------
exec Reporte_Ventas_Periodo
	@fecha_inicio = '2025-12-01',
	@fecha_fin='2025-03-31';
go
---------------------------------------------------------------------

-- Facturación automática
create procedure Facturacion_simple
	@id_cliente int,
	@id_empleado int, 
	@id_producto int,
	@cantidad int,
	@fecha datetime
as 
begin
-- validar que el stock sea suficiente
	if not exists(select 1 from inventario where id_producto= @id_producto
	and stock_actual>= @cantidad)
	begin
		print'Producto sin stock, o inexistente';
		return;
	end
	declare @precio_unitario decimal(10,2);
	declare @subtotal decimal(10,2);

	select @precio_unitario= precio_venta from producto
	where id_producto=@id_producto;
	set @subtotal=@precio_unitario*@cantidad;
-- Se inserta la venta principal
	declare @id_venta int;
	insert into venta(fecha, total, id_cliente, id_empleado)
	values (@fecha, @subtotal, @id_cliente, @id_empleado);
	set @id_venta= SCOPE_IDENTITY();
-- Insertamos el detalle de ventas
	insert into detalle_venta(id_venta, id_producto, cantidad, precio_unitario, subtotal)
	values(@id_venta, @id_producto, @cantidad, @precio_unitario, @subtotal);
-- Se descuenta a cantidad vendida del inventario
	update inventario
	set stock_actual=stock_actual - @cantidad
	where id_producto= @id_producto;
	print'Venta registrada exitosamente';
end;
go

-- Verificando
exec Facturacion_simple
    @id_cliente = 1,
    @id_empleado = 2,
    @id_producto = 3,
    @cantidad = 4,
    @fecha = '2025-08-01';
go
---------------------------------------------------------------------------
exec Facturacion_simple
    @id_cliente = 1,
    @id_empleado = 2,
    @id_producto = 80,
    @cantidad = 4,
    @fecha = '2025-08-01';
go
---------------------------------------------------------------------------

-- Transacciónn controlada
create procedure Facturacion_Transaccion
	@id_cliente int,
	@id_empleado int,
	@id_producto int,
	@cantidad int, 
	@fecha datetime
as
begin
	begin tran; -- Aquí inicializamos la transaccion
-- Verificar si hay el stock suficiente
	if not exists(select 1 from inventario
	where id_producto= @id_producto and stock_actual>= @cantidad)
	begin
		print'Stock insuficiente o producto inexistente';
		rollback;
		return;
	end
	declare @precio_unitario decimal(10,2);
	declare @subtotal decimal(10,2);
	declare @id_venta int;
-- Calcular el precio y subtotal
	select @precio_unitario=precio_venta from producto
	where id_producto=@id_producto;
	set @subtotal=@precio_unitario*@cantidad;
-- Insertar venta
	insert into venta(fecha, total, id_cliente, id_empleado)
	values(@fecha, @subtotal, @id_cliente, @id_empleado);
	set @id_venta= SCOPE_IDENTITY();
-- Insertar un detalle de venta
	insert into detalle_venta(id_venta, id_producto, cantidad, precio_unitario, subtotal)
	values(@id_venta, @id_producto, @cantidad, @precio_unitario, @subtotal);
-- Actualizar el inventario
	update inventario
	set  stock_actual=stock_actual-@cantidad
	where id_producto= @id_producto;
	commit;
	print'Venta realizada correctamente';
end;
go

-- Verificando
exec Facturacion_Transaccion
    @id_cliente = 1,
    @id_empleado = 2,
    @id_producto = 3,
    @cantidad = 2,
    @fecha = '2025-08-01';  
go
exec Facturacion_Transaccion
    @id_cliente = 1,
    @id_empleado = 2,
    @id_producto = 3,
    @cantidad = 9999,  
	@fecha = '2025-08-02';
go

-------------------------------------
exec Facturacion_Transaccion
    @id_cliente = 1,
    @id_empleado = 2,
    @id_producto = 3,
    @cantidad = 2,
    @fecha = '2025-08-02 14:30:00';  
go
-- Tbl venta
------------------------------------



use Supermercado;
go
-- FUNCIONES

-- 1.	Función para calcular el IVA de una compra.

GO

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

GO

-- Uso de la función dbo.ObtenerTotalConIVA

SELECT dbo.ObtenerTotalConIVA(2, 12.00) AS Total_Con_IVA;

GO

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

GO

-- Uso de la función ObtenerStockProducto

SELECT dbo.ObtenerStockProducto(8) AS Stock_Producto;

GO

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

GO

-- Uso de la función dbo.ProductosPorCategoria

SELECT dbo.ProductosPorCategoria(10) AS Total_Productos;



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

---------------------------------------------------------------------------------------

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


use Supermercado;
go

-- 1) Crear índices simples para campos clave en WHERE, JOIN, ORDER BY.
-- INDICE PARA WHERE
-- Buscar ventas por fecha
create index odx_venta on venta(fecha);
-- Activando las estadísticas de tiempo
set statistics time on;
-- Probar el índice
select* from venta
where fecha>='2025-07-31';

-- INDICE PARA JOIN
-- Joins por producto
create index idx_producto on detalle_venta(id_producto);
-- Activando las estadísticas de tiempo
set statistics time on;
--JOIN entre detalle_venta y producto
-- para obtener el nombre del producto vendido junto con la cantidad, precio, etc.
-- Consulta que hace JOIN usando id_producto
select dv.*, p.nombre
from detalle_venta dv
join producto p on dv.id_producto = p.id_producto;
--Probando
SELECT dv.*, p.nombre
FROM detalle_venta dv
JOIN producto p ON dv.id_producto = p.id_producto
WHERE dv.id_producto = 8;


-- INDICE PARA ORDER BY
--Ordenar por precio
create index idx_precio on producto(precio_venta);
-- Activando las estadísticas de tiempo
set statistics time on;
-- Consulta que ordena por precio de venta
select * from producto
order by precio_venta desc;


-- 2) Crear índices compuestos para combinaciones comunes.
-- Búsquedas por id_venta + id_producto
create index idx_detalle_venta_compu on detalle_venta(id_venta, id_producto);
-- Activando las estadísticas de tiempo
set statistics time on;
-- Consulta para la verificación de el procedimiento
select * from detalle_venta
where id_venta=5 and id_producto=10;

-- Consultar ventas por fecha y total
create index idx_venta_fecha_total on venta(fecha, total);
-- Activando las estadísticas de tiempo
set statistics time on;
-- Verificando el funcionamiento del procedimiento
select * from venta
where fecha>='2025-08-01' and total='14.00' order by total desc;


-- 3) Analizar rendimiento con EXPLAIN o herramientas gráficas según el motor.
select * from detalle_venta
where id_venta=5 and id_producto=10;


-- 4) Simular carga con 500+ registros y medir tiempos antes/después de los índices.
declare @i int = 1;
while @i <= 500
begin
    insert into producto (nombre, descripcion, precio_compra, precio_venta, id_marca, id_categoria, id_proveedor)
    values (
        CONCAT('ProductoPrueba', @i),
        'Descripción genérica',
        1.00,
        5.00 + (@i % 10),  
        1,
        1,
        1
    );
    set @i = @i + 1;
end;

-- Eliminamos el indice que creamos anteriormente
drop index if exists idx_precio on producto;

-- Medimos el tiempo de la consulta que usa precio_venta
set statistics time on;
select * from producto where precio_venta>10;
set statistics time off;

-- Creamos de nuevo el índice
create index idx_precio_producto on producto(precio_venta);

-- Medimos el tiempo con índice
set statistics time on;
select * from producto where precio_venta>10;
set statistics time off;


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


-- BACKUP EN CALIENTE
use master;
go

-- Realiza un backup de la base de datos Supermercado
backup database Supermercado
to disk = 'C:\Backup\supermercado_caliente.bak'
with format, name = 'Backup en caliente de Supermercado';


-- PARA LA RESTAURACIÓN EN CALIENTE 
use master;
go
-- Debemos cerrar las conexiones a la base original para evitar problemas
alter database Supermercado 
set single_user with rollback immediate;
-- Restauramos el backup como una nueva base, otro nombre
restore database Supermercado_Restaurada
from disk = 'C:\BackupCaliente\supermercado_caliente.bak'
with move 'Supermercado' to 'C:\BackupCaliente\Supermercado_Restaurada.mdf',
     move 'Supermercado_log' to 'C:\BackupCaliente\Supermercado_Restaurada_log.ldf';


-- Para confirmar su correcta restauración
-- Mostrar la lista de bases de datos con sus archivos físicos y rutas
print'La base de datos Supermercado_Restaurada se restauró correctamente.';
select 
    db.name as NombreBaseDatos,
    mf.physical_name as RutaArchivo,
    mf.type_desc as TipoArchivo
from
    sys.master_files mf
inner join
    sys.databases db on mf.database_id = db.database_id
where
    db.name = 'Supermercado_Restaurada';

-- Vemos que nomás tiene nuestra base de datos restaurada
use Supermercado_Restaurada;
go
select top 10 * from cliente;



-- Para reactivar la conexión de mi base de datos
alter database Supermercado
set multi_user;
go

-- Para comprobar que si se reactivo correctamente 
use Supermercado;
go
select top 5 * from cliente;



USE master;
GO

-- Si existe una base con ese nombre, la eliminamos para evitar conflictos
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Supermercado_Restaurada_Frio')
BEGIN
    ALTER DATABASE Supermercado_Restaurada_Frio SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Supermercado_Restaurada_Frio;
END
GO

-- Restauración desde backup en frío (archivos .mdf y .ldf)
CREATE DATABASE Supermercado_Restaurada_Frio
ON 
(FILENAME = 'C:\BackupFrio\Supermercado.mdf'),
(FILENAME = 'C:\BackupFrio\Supermercado_log.ldf')
FOR ATTACH;
GO


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


use Supermercado;
go

-- MONITOREO Y RENDIMIENTO

-- Tamaño de las tablas y sus índices en la base de datos Supermercado
EXEC sp_MSforeachtable 
    @command1 = 'EXEC sp_spaceused ''?''';
 

 -- Registros creados por semana en la tabla venta 
SELECT 
    DATEPART(YEAR, fecha) AS Año,
    DATEPART(WEEK, fecha) AS Semana,
    COUNT(*) AS Cantidad_ventas
FROM venta
GROUP BY DATEPART(YEAR, fecha), DATEPART(WEEK, fecha)
ORDER BY Año DESC, Semana DESC;


-- Consultas más lentas en el plan de ejecución 

SELECT TOP 10
    qs.total_elapsed_time / qs.execution_count AS avg_elapsed_time_ms,
    qs.execution_count,
    qs.total_elapsed_time,
    SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
        ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(st.text)
            ELSE qs.statement_end_offset END
            - qs.statement_start_offset)/2) + 1) AS query_text,
    qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY avg_elapsed_time_ms DESC;


-- Registro del uso de funciones, procedimientos y recursos
SELECT 
    OBJECT_NAME(st.objectid) AS nombre_procedimiento,
    COUNT(*) AS ejecuciones
FROM sys.dm_exec_cached_plans cp
CROSS APPLY sys.dm_exec_query_stats qs -- sin parámetro porque es una vista
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) AS st -- función con parámetro
WHERE cp.cacheobjtype = 'Compiled Plan'
AND st.dbid = DB_ID('Supermercado')
GROUP BY st.objectid
ORDER BY ejecuciones DESC;





use Supermercado;
go

-- Protección de Datos y Gestión Crítica
-- Simulación de anonimización y enmascaramiento.
CREATE FUNCTION enmascarar_email (@email NVARCHAR(100))
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @arroba INT = CHARINDEX('@', @email)
    IF @arroba <= 3
        RETURN 'Email inválido'

    RETURN LEFT(@email, 3) + '***' + SUBSTRING(@email, @arroba, LEN(@email))
END;
GO


SELECT nombre, dbo.enmascarar_email(email) AS email_mask
FROM cliente;
GO

CREATE FUNCTION enmascarar_cedula (
    @cedula NVARCHAR(10)
)
RETURNS NVARCHAR(10)
AS
BEGIN
    IF LEN(@cedula) != 10
        RETURN 'Cédula inválida'

    RETURN LEFT(@cedula, 2) + '*****' + RIGHT(@cedula, 3)
END
GO

-- Prueba del Enmascaramiento de la cedula
SELECT nombre, dbo.enmascarar_cedula(cedula) AS cedula_mask
FROM cliente;
GO




use Supermercado;
go
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