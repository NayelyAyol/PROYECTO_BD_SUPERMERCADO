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