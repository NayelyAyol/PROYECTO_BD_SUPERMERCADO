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