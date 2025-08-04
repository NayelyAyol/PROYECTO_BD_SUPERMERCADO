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
('Nestl�', 'Suiza'),
('Coca-Cola', 'EE.UU.'),
('Unilever', 'Reino Unido'),
('Knorr', 'Alemania'),
('Maggi', 'Suiza'),
('Frito Lay', 'EE.UU.'),
('La Ib�rica', 'Ecuador'),
('T�a', 'Ecuador'),
('Marinela', 'M�xico'),
('Dorina', 'Ecuador'),
('Lays', 'EE.UU.'),
('Act II', 'EE.UU.'),
('San Francisco', 'Ecuador');


-- Datos para la tabla categor�a
INSERT INTO categoria (nombre, descripcion) VALUES
('L�cteos', 'Leche, quesos y derivados'),
('Bebidas', 'Refrescos, jugos y aguas'),
('Abarrotes', 'Productos b�sicos de despensa'),
('Carnes', 'Carnes frescas y procesadas'),
('Frutas/Verduras', 'Productos frescos'),
('Limpieza', 'Art�culos de limpieza del hogar'),
('Higiene', 'Productos de cuidado personal'),
('Panader�a', 'Pan y productos de reposter�a'),
('Congelados', 'Alimentos congelados'),
('Snacks', 'Botanas y pasapalos'),
('Dulces', 'Chocolates y caramelos'),
('Enlatados', 'Conservas y alimentos enlatados'),
('Beb�', 'Productos para beb�s'),
('Mascotas', 'Alimentos para mascotas'),
('Electro', 'Peque�os electrodom�sticos');


-- Datos para la tabla proveedor
INSERT INTO proveedor (nombre, telefono, direccion) VALUES
('Distribuidora Andina', '022345678', 'Av. Amazonas N34-122, Quito'),
('Alimentos Ecuador', '022987654', 'Av. Occidental 456, Quito'),
('L�cteos del Valle', '022111222', 'Autopista Norte Km 5, Quito'),
('Carnes Premium SA', '022333444', 'Av. Mariscal Sucre Oe1-23, Quito'),
('Importadora Clean', '022555666', 'Av. 10 de Agosto N20-34, Quito'),
('Distribuidora Hogar', '022777888', 'Av. Am�rica N32-145, Quito'),
('Panader�a La Moderna', '022999000', 'Av. 6 de Diciembre N24-56, Quito'),
('Congelados Polar', '022123456', 'Av. R�o Coca E12-34, Quito'),
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
('Lechuga Fresca', 'Lechuga org�nica', 0.50, 0.90, NULL, 5, 2),
('Detergente Ace', 'Detergente l�quido 1L', 2.50, 3.50, 13, 6, 5),
('Cloro Magia Blanca', 'Cloro l�quido 1L', 0.80, 1.20, 10, 6, 5),
('Shampoo Pantene', 'Shampoo reparaci�n 400ml', 3.50, 4.90, 15, 7, 10),
('Jab�n L�quido Dove', 'Jab�n l�quido 250ml', 2.80, 3.90, 16, 7, 10),
('Pan Integral Moderna', 'Pan integral 500g', 1.50, 2.20, 7, 8, 7),
('Pan de Avena San Francisco', 'Pan de avena 400g', 1.80, 2.50, 23, 8, 7),
('Pizza Congelada Polar', 'Pizza de pepperoni 400g', 4.20, 6.00, 8, 9, 8),
('Helado Toni', 'Helado de vainilla 1L', 3.80, 5.40, 4, 9, 8),
('Papas Fritas Lay''s', 'Papas fritas 150g', 1.20, 1.80, 21, 10, 1),
('Palomitas Act II', 'Palomitas para microondas', 1.50, 2.20, 22, 10, 1),
('Chocolate Nestl�', 'Tableta de chocolate 100g', 2.50, 3.60, 11, 11, 1),
('Caramelos Adams', 'Caramelos surtidos 200g', 1.80, 2.60, 19, 11, 1),
('At�n Real en Aceite', 'At�n en aceite 200g', 1.50, 2.20, 9, 12, 2),
('Sardinas La Sirena', 'Sardinas en aceite 125g', 1.20, 1.80, 17, 12, 2),
('Pa�ales Huggies', 'Pa�ales etapa 3 30un', 8.50, 12.00, 11, 13, 6),
('Toallitas Huggies', 'Toallitas h�medas 80un', 7.80, 11.00, 11, 13, 6),
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
        RAISERROR('La c�dula debe contener exactamente 10 d�gitos num�ricos.', 16, 1)
        RETURN
    END

    IF @email NOT LIKE '_%@_%._%' OR CHARINDEX(' ', @email) > 0
    BEGIN
        RAISERROR('Formato de correo electr�nico inv�lido.', 16, 1)
        RETURN
    END

    INSERT INTO cliente (nombre, cedula, email, telefono)
    VALUES (@nombre, @cedula, @email, @telefono)
END
GO

-- Clientes
INSERT INTO cliente (nombre, cedula, email, telefono) VALUES
('Juan P�rez', '1701234567', 'juan.perez@gmail.com', '0991234567'),
('Mar�a G�mez', '1702345678', 'maria.gomez@outlook.com', '0992345678'),
('Carlos Andrade', '1703456789', 'carlos.andrade@gmail.com', '0993456789'),
('Ana Beltr�n', '1704567890', 'ana.beltran@yahoo.com', '0994567890'),
('Luis V�squez', '1705678901', 'luis.vasquez@hotmail.com', '0995678901');

-- Empleados
INSERT INTO empleado (nombre, telefono, fecha_contratacion) VALUES
('M�nica Patricia Zurita', '0832109876', '2023-03-15'),
('Ricardo Andr�s Zambrano', '0821098765', '2023-04-20'),
('Ver�nica Elizabeth Ponce', '0810987654', '2023-05-10');

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
('Descuento en L�cteos', '2023-06-01', '2023-06-30'),
('2x1 en Bebidas', '2023-06-15', '2023-06-30'),
('Oferta de Carnes', '2023-06-10', '2023-06-25'),
('Promoci�n de Limpieza', '2023-06-01', '2023-06-15'),
('Oferta de Panader�a', '2023-06-10', '2023-06-30');

-- Producto_Promocion solo para productos existentes
INSERT INTO producto_promocion (id_promocion, id_producto, descuento) VALUES
(1, 1, 15.00), (1, 2, 10.00), (1, 3, 12.00),
(2, 6, 50.00), (2, 7, 40.00), (2, 8, 30.00),
(3, 11, 20.00), (3, 12, 15.00),
(4, 15, 30.00), (4, 16, 25.00),
(5, 19, 20.00), (5, 20, 15.00);
