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