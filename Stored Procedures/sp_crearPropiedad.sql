USE [corredora]
GO
/****** Object:  StoredProcedure [dbo].[sp_CrearPropiedad]    Script Date: 25-04-2015 0:39:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Crear Propiedades por defecto tendra N en Arrendado>
-- =============================================
ALTER PROCEDURE [dbo].[sp_CrearPropiedad]
	@rutDueno INT,
	@comuna VARCHAR(50),
	@ciudad VARCHAR(50),
	@direccion VARCHAR(200),
	@valor INT,
	@tipo INT,
	@piezas INT,
	@banos INT

AS
BEGIN

	DECLARE @count AS INT
		SET @count = (SELECT COUNT(1) FROM DUENO WHERE RUTDUENO = @rutDueno)
			IF @count = 1
			BEGIN
				INSERT INTO [dbo].[PROPIEDAD] VALUES (@comuna, @ciudad, @direccion, @valor, @tipo, @rutDueno, @piezas, @banos, 'N')
			SELECT 'PROPIEDAD REGISTRADA' AS OK
			END

			ELSE 
				SELECT 'DUEÑO NO EXISTE' AS ERROR

END

