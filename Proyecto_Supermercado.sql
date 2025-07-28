CREATE TABLE `cliente` (
  `id_cliente` int PRIMARY KEY AUTO_INCREMENT,
  `nombre` nvarchar(100),
  `cedula` nvarchar(10) UNIQUE,
  `email` nvarchar(100) UNIQUE,
  `telefono` nvarchar(20)
);

CREATE TABLE `empleado` (
  `id_empleado` int PRIMARY KEY AUTO_INCREMENT,
  `nombre` nvarchar(100),
  `telefono` nvarchar(20),
  `fecha_contratacion` date
);

CREATE TABLE `marca` (
  `id_marca` int PRIMARY KEY AUTO_INCREMENT,
  `nombre` nvarchar(100) UNIQUE,
  `pais_origen` nvarchar(50)
);

CREATE TABLE `categoria` (
  `id_categoria` int PRIMARY KEY AUTO_INCREMENT,
  `nombre` nvarchar(100) UNIQUE,
  `descripcion` nvarchar(255)
);

CREATE TABLE `proveedor` (
  `id_proveedor` int PRIMARY KEY AUTO_INCREMENT,
  `nombre` nvarchar(100),
  `telefono` nvarchar(20),
  `direccion` nvarchar(150)
);

CREATE TABLE `producto` (
  `id_producto` int PRIMARY KEY AUTO_INCREMENT,
  `nombre` nvarchar,
  `descripcion` nvarchar,
  `precio_compra` decimal,
  `precio_venta` decimal,
  `id_marca` int,
  `id_categoria` int,
  `id_proveedor` int
);

CREATE TABLE `inventario` (
  `id_inventario` int PRIMARY KEY AUTO_INCREMENT,
  `id_producto` int UNIQUE,
  `stock_actual` int,
  `stock_minimo` int
);

CREATE TABLE `venta` (
  `id_venta` int PRIMARY KEY AUTO_INCREMENT,
  `fecha` datetime,
  `total` decimal(10,2),
  `id_cliente` int,
  `id_empleado` int
);

CREATE TABLE `detalle_venta` (
  `id_detalle` int PRIMARY KEY AUTO_INCREMENT,
  `id_venta` int,
  `id_producto` int,
  `cantidad` int,
  `precio_unitario` decimal(10,2),
  `subtotal` decimal(10,2)
);

CREATE TABLE `promocion` (
  `id_promocion` int PRIMARY KEY AUTO_INCREMENT,
  `descripcion` nvarchar(255),
  `fecha_inicio` date,
  `fecha_fin` date
);

CREATE TABLE `producto_promocion` (
  `id_promocion` int,
  `id_producto` int,
  `descuento` decimal(5,2),
  PRIMARY KEY (`id_promocion`, `id_producto`)
);

ALTER TABLE `producto` COMMENT = 'Producto vendido por proveedor';

ALTER TABLE `inventario` COMMENT = 'stock_actual y stock_minimo >= 0';

ALTER TABLE `venta` COMMENT = 'total >= 0';

ALTER TABLE `detalle_venta` COMMENT = 'cantidad > 0, precio_unitario > 0, subtotal >= 0';

ALTER TABLE `promocion` COMMENT = 'fecha_fin > fecha_inicio';

ALTER TABLE `producto_promocion` COMMENT = 'descuento entre 0 y 100';

ALTER TABLE `producto` ADD FOREIGN KEY (`id_marca`) REFERENCES `marca` (`id_marca`);

ALTER TABLE `producto` ADD FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`);

ALTER TABLE `producto` ADD FOREIGN KEY (`id_proveedor`) REFERENCES `proveedor` (`id_proveedor`);

ALTER TABLE `inventario` ADD FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`);

ALTER TABLE `venta` ADD FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`);

ALTER TABLE `venta` ADD FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`);

ALTER TABLE `detalle_venta` ADD FOREIGN KEY (`id_venta`) REFERENCES `venta` (`id_venta`);

ALTER TABLE `detalle_venta` ADD FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`);

ALTER TABLE `producto_promocion` ADD FOREIGN KEY (`id_promocion`) REFERENCES `promocion` (`id_promocion`);

ALTER TABLE `producto_promocion` ADD FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`);
