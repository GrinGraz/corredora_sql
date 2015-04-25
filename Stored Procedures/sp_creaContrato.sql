USE [corredora]
GO
/****** Object:  StoredProcedure [dbo].[sp_CreaContrato]    Script Date: 25-04-2015 0:35:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--Crea los contratos de Arriendo, con sus respectivo Detalle de Cuotas de Arriendo
--Se realizan Validaciones de Rut, Propiedad no sea = a la Arrendada(mismo inmueble)
-- =============================================
ALTER PROCEDURE [dbo].[sp_CreaContrato]
	@rut INT,
	@propiedad INT,
	@diaPago INT,
	@fechaContrato DATE,
	@numeroCuotas INT
AS
BEGIN
--obtengo id de propiedad que esten disponibles
	DECLARE @idPro AS INT
	SET @idPro = (SELECT IDPROPIEDAD FROM  PROPIEDAD WHERE ARRENDADO='N' AND IDPROPIEDAD = @propiedad)
	DECLARE @idP AS INT
	SET @idP = (SELECT COUNT(1) FROM  PROPIEDAD WHERE ARRENDADO='N' AND IDPROPIEDAD = @propiedad)
--busca que exista un arrendatario para poder generar el contrato si no existe se debe registrar primero el arrendatario
	DECLARE @count AS INT
	SET @count = (SELECT COUNT(1) FROM ARRENDATARIO WHERE RUTARRENDATARIO = @rut)
--obtengo el valor del arriendo de la propiedad
	DECLARE @valor AS INT
	SET @valor = (SELECT VALORARRIENDO FROM PROPIEDAD WHERE IDPROPIEDAD = @propiedad)
--calcular fecha de termino de contrato
	DECLARE @terminoContrato AS DATE
	SET @terminoContrato = (SELECT DATEADD(month, @numeroCuotas, @fechaContrato) AS T)

--busca que propiedades tiene en arriendo para que cuando contrate sea distinto del que tiene
	DECLARE @existe AS INT
	SET @existe = (SELECT COUNT(1) FROM CONTRATO WHERE RUTARRENDATARIO = @rut AND IDPROPIEDAD=@propiedad)
--cuenta si existe un contrato para el arrendatario consultado
	DECLARE @si AS INT
	SET @si = (SELECT COUNT(1) FROM CONTRATO WHERE RUTARRENDATARIO = @rut)

--controla el exeso de contratos a la misma propiedad
	IF @existe = 0 AND @count = 1 AND @idP = 1
		BEGIN
		INSERT INTO CONTRATO VALUES (@idPro, @valor, @rut, @diaPago, @fechaContrato, @terminoContrato, @numeroCuotas)
--fin
			IF @existe = 0 AND @count = 1 AND @idP = 1
				BEGIN
--llamar al procedimineto que llena la tabla cuotas arriendo y se declara un ID para poder obneter el ultimo id generado en contrato para 
--construir las cuotas de arriendo
				DECLARE @id AS INT
				SET @id = (SELECT TOP 1 IDCONTRATO FROM CONTRATO ORDER BY IDCONTRATO DESC)
				EXEC [dbo].[sp_RegistraCuotasArriendo] @id , @numeroCuotas, @propiedad
				SELECT 'CONTRATO OK'
				END
		END
--fin
	ELSE IF @idP = 0
		SELECT 'PROPIEDAD YA SE ENCUENTRA ARRENDADA'
	ELSE IF @count = 0
		SELECT 'RUT NO EXISTE'
	ELSE IF @existe = 1
		SELECT 'RUT CUENTA CON ARRIENDO MISMA PROPIEDAD'
	

END
