use Supermercado;
go

-- 1) Crear �ndices simples para campos clave en WHERE, JOIN, ORDER BY.
-- INDICE PARA WHERE
-- Buscar ventas por fecha
create index odx_venta on venta(fecha);
-- Activando las estad�sticas de tiempo
set statistics time on;
-- Probar el �ndice
select* from venta
where fecha>='2024-01-01';

-- INDICE PARA JOIN
-- Joins por producto
create index idx_producto on detalle_venta(id_producto);
-- Activando las estad�sticas de tiempo
set statistics time on;
-- Consulta que hace JOIN usando id_producto
select dv.*, p.nombre
from detalle_venta dv
join producto p on dv.id_producto = p.id_producto;

-- INDICE PARA ORDER BY
--Ordenar por precio
create index idx_precio on producto(precio_venta);
-- Activando las estad�sticas de tiempo
set statistics time on;
-- Consulta que ordena por precio de venta
select * from producto
order by precio_venta desc;


-- 2) Crear �ndices compuestos para combinaciones comunes.
-- B�squedas por id_venta + id_producto
create index idx_detalle_venta_compu on detalle_venta(id_venta, id_producto);
-- Activando las estad�sticas de tiempo
set statistics time on;
-- Consulta para la verificaci�n de el procedimiento
select * from detalle_venta
where id_venta=5 and id_producto=10;

-- Consultar ventas por fecha y total
create index idx_venta_fecha_total on venta(fecha, total);
-- Activando las estad�sticas de tiempo
set statistics time on;
-- Verificando el funcionamiento del procedimiento
select * from venta
where fecha>='2025-08-01' order by total desc;


-- 3) Analizar rendimiento con EXPLAIN o herramientas gr�ficas seg�n el motor.
select * from detalle_venta
where id_venta=5 and id_producto=10;


-- 4) Simular carga con 500+ registros y medir tiempos antes/despu�s de los �ndices.
declare @i int = 1;
while @i <= 500
begin
    insert into producto (nombre, descripcion, precio_compra, precio_venta, id_marca, id_categoria, id_proveedor)
    values (
        CONCAT('ProductoPrueba', @i),
        'Descripci�n gen�rica',
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

-- Creamos de nuevo el �ndice
create index idx_precio_producto on producto(precio_venta);

-- Medimos el tiempo con �ndice
set statistics time on;
select * from producto where precio_venta>10;
set statistics time off;