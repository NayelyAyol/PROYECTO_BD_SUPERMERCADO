use Supermercado;
go

-- Protecci�n de Datos y Gesti�n Cr�tica
-- Simulaci�n de anonimizaci�n y enmascaramiento.
CREATE FUNCTION enmascarar_email (@email NVARCHAR(100))
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @arroba INT = CHARINDEX('@', @email)
    IF @arroba <= 3
        RETURN 'Email inv�lido'

    RETURN LEFT(@email, 3) + '***' + SUBSTRING(@email, @arroba, LEN(@email))
END;
GO


SELECT nombre, dbo.enmascarar_email(email) AS email_mask
FROM cliente;
GO

CREATE FUNCTION enmascarar_cedula (
    @cedula NVARCHAR(10)
)
RETURNS NVARCHAR(10)
AS
BEGIN
    IF LEN(@cedula) != 10
        RETURN 'C�dula inv�lida'

    RETURN LEFT(@cedula, 2) + '*****' + RIGHT(@cedula, 3)
END
GO

-- Prueba del Enmascaramiento de la cedula
SELECT nombre, dbo.enmascarar_cedula(cedula) AS cedula_mask
FROM cliente;
GO