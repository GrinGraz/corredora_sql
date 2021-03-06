USE [corredora]
GO
/**** Object: StoredProcedure [dbo].[sp_CreaContrato] Script Date: 25-04-2015 01:50:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-Crea los contratos de Arriendo, con sus respectivo Detalle de Cuotas de Arriendo
--Se realizan Validaciones de Rut, Propiedad no sea = a la Arrendada(mismo inmueble)
- =============================================
ALTER PROCEDURE [dbo].[sp_CreaContrato]
 @rut INT,
 @propiedad INT,
 @fechaContrato DATE
AS
BEGIN
--obtengo id de propiedad que esten disponibles
 DECLARE @idPro AS INT
 DECLARE @idP AS INT
 DECLARE @count AS INT
 DECLARE @valor AS INT
 DECLARE @terminoContrato AS DATE
 DECLARE @existe AS INT
 DECLARE @id AS INT

 SET @idPro = (SELECT IDPROPIEDAD FROM PROPIEDAD WHERE ARRENDADO='N' AND IDPROPIEDAD = @propiedad)
 SET @idP = (SELECT COUNT(1) FROM PROPIEDAD WHERE ARRENDADO='N' AND IDPROPIEDAD = @propiedad)
 SET @count = (SELECT COUNT(1) FROM ARRENDATARIO WHERE RUTARRENDATARIO = @rut)
 SET @valor = (SELECT VALORARRIENDO FROM PROPIEDAD WHERE IDPROPIEDAD = @propiedad)
 SET @terminoContrato = (SELECT DATEADD(month, 12, @fechaContrato) AS T)
 SET @existe = (SELECT COUNT(1) FROM CONTRATO WHERE RUTARRENDATARIO = @rut AND IDPROPIEDAD=@propiedad)
  
 IF @existe = 0 AND @count = 1 AND @idP = 1
 	BEGIN
 	INSERT INTO CONTRATO VALUES (@idPro, @valor, @rut, @fechaContrato, @terminoContrato)
 	UPDATE PROPIEDAD SET ARRENDADO = 'S' WHERE IDPROPIEDAD= @idPro
 END

 ELSE IF @idP = 0
 	SELECT 'PROPIEDAD YA SE ENCUENTRA ARRENDADA'
 ELSE IF @count = 0
 	SELECT 'RUT NO EXISTE'
 ELSE IF @existe = 1
 	SELECT 'RUT CUENTA CON ARRIENDO MISMA PROPIEDAD'
  

END