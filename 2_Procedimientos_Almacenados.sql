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
	-- Actualizar el stock mínimo de todos los datos depensidendo del id que se da
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
