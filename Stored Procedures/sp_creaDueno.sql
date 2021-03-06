USE [corredora]
GO
/****** Object:  StoredProcedure [dbo].[sp_CreaDueno]    Script Date: 25-04-2015 0:36:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Valida si un Cliente Existe si no Existe lo Crea>
-- =============================================
ALTER PROCEDURE [dbo].[sp_CreaDueno]
		@rut INT,
		@dv CHAR(1),
		@nombre VARCHAR(50),
		@paterno VARCHAR(50),
		@materno VARCHAR(50),
		@fono INT,
		@direccion VARCHAR(200),
		@correo VARCHAR(200)
AS
BEGIN
	DECLARE @count AS INT
		SET @count = (SELECT COUNT(1) FROM DUENO WHERE RUTDUENO = @rut)
			IF @count = 0
			BEGIN
				INSERT INTO DUENO VALUES (@rut, @dv, @nombre, @paterno, @materno, @fono, @direccion, @correo)
			SELECT 'DUEÑO REGISTRADO' AS OK
			END
			IF @count = 1
			BEGIN
			SELECT 'DUEÑO EXISTE' AS ERROR
			END
				
END

