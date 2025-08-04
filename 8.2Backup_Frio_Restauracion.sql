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
