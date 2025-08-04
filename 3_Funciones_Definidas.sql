
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