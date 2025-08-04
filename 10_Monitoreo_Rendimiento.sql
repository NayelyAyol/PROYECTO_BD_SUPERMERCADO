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





