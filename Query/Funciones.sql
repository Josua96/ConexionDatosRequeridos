--Provincias

-- insertar provincia
CREATE OR REPLACE FUNCTION insertar_provincia
( 
	p_nombreProvincia	VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO Direccion.Provincias (NombreProvincia) VALUES (p_nombreProvincia);
END;
$BODY$ 
LANGUAGE plpgsql;

-- modificar provincia
CREATE OR REPLACE FUNCTION modificar_provincias
( 
	p_idProvincia		INTEGER,
	p_nombreProvincia 	VARCHAR(50)	
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE Direccion.Provincias SET 
		NombreProvincia = p_nombreProvincia
	WHERE IdProvincia = p_idProvincia;
END;
$BODY$ 
LANGUAGE plpgsql;

-- borrar provincia
CREATE OR REPLACE FUNCTION borrar_provincia
( 
	p_idProvincia	INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM Direccion.Provincias AS P where P.IdProvincia = p_idProvincia;	
END;
$BODY$ 
LANGUAGE plpgsql;



--Cantones

--insertar
select * from Direccion.Cantones
CREATE OR REPLACE FUNCTION insertar_cantones
(
	p_idProvincia INTEGER,
	p_nombreCanton VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO Direccion.Cantones(IdProvincia,NombreCanton) VALUES(CAST(p_idProvincia AS SMALLINT),p_nombreCanton);
END;
$BODY$ 
LANGUAGE plpgsql;

Select insertar_cantones();

--modificar
CREATE OR REPLACE FUNCTION modificar_cantones
(
	p_idCanton INTEGER,
	p_nombreCanton VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE Direccion.Cantones SET 
		NombreCanton=p_nombreCanton
	WHERE IdCanton = p_idCanton;
END;
$BODY$ 
LANGUAGE plpgsql;

--ELIMINAR
CREATE OR REPLACE FUNCTION borrar_cantones
(
	p_idCanton INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM Direccion.Cantones  where IdCanton = p_idCanton;
END;
$BODY$ 
LANGUAGE plpgsql;


--Distritos

-- insertar distrito
CREATE OR REPLACE FUNCTION insertar_distritos
(
	p_IdCanton 		INTEGER,
	p_nombreDistrito 	VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO Direccion.Distritos(IdCanton,nombreDistrito) VALUES (p_IdCanton,p_nombreDistrito);
END;
$BODY$ 
LANGUAGE plpgsql;

-- modificar distrito
CREATE OR REPLACE FUNCTION modificar_distritos
( 
	p_idDistrito 		INTEGER,
	p_nombreDistrito 	VARCHAR(50)	
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE Direccion.Distritos SET 
		NombreDistrito = p_nombreDistrito
	WHERE IdDistrito = p_idDistrito;
END;
$BODY$ 
LANGUAGE plpgsql;

-- borrar distrito
CREATE OR REPLACE FUNCTION borrar_distrito
( 
	p_idDistrito	INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM Direccion.Distritos AS D where D.IdDistrito = p_idDistrito;	
END;
$BODY$ 
LANGUAGE plpgsql;

--Accidentes
-- insertar accidente
CREATE OR REPLACE FUNCTION insertar_accidente
(
	p_idTipoLesion 		INTEGER,
	p_fechaAccidente 	DATE
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO AccidentesTran.Accidentes(IdTipoLesion, Fecha) VALUES (p_idTipoLesion, p_fechaAccidente);
END;
$BODY$ 
LANGUAGE plpgsql;

-- modificar accidente
CREATE OR REPLACE FUNCTION modificar_accidente
( 
	p_idAccidente		INTEGER,
	p_idTipoLesion 		INTEGER,
	p_fechaAccidente 	VARCHAR(50)	
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE AccidentesTran.Accidentes SET 
		IdTipoLesion = p_idDistrito,
		Fecha = p_fechaAccidente
	WHERE Id = p_idAccidente;
END;
$BODY$ 
LANGUAGE plpgsql;

-- borrar accidente
CREATE OR REPLACE FUNCTION borrar_accidente
( 
	p_idAccidente	INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM AccidentesTran.Accidentes AS A where A.Id = p_idAccidente;	
END;
$BODY$ 
LANGUAGE plpgsql;

--Accidentes Generales

--INSERTAR
CREATE OR REPLACE FUNCTION insertar_accidentesGenerales
(	p_idAccidente INTEGER,
	p_horaInicio TIME,
	p_horaFinal TIME,
	p_areaGeografica CHAR(1),
	p_idDistrito INTEGER,
	p_tipoRuta CHAR(1),
	p_idTipoCirculacion INTEGER,
	p_idEstadoTiempo INTEGER,
	p_idTipoCalzada INTEGER,
	p_idDescripcionCalzadaVertical INTEGER,
	p_idDescripcionCalzadaHorizontal INTEGER,
	p_idTipoAccidente INTEGER,
	p_idKilometro INTEGER,
	p_idRuta INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO AccidentesTran.AccidentesGenerales 
	VALUES(p_idAccidente,p_horaInicio,p_horaFinal,p_areaGeografica,CAST(p_idDistrito AS SMALLINT),
	p_tipoRuta,CAST(p_idTipoCirculacion AS SMALLINT),CAST(p_idEstadoTiempo AS SMALLINT),
	CAST(p_idTipoCalzada AS SMALLINT),CAST(p_idDescripcionCalzadaVertical AS SMALLINT),
	CAST(p_idDescripcionCalzadaHorizontal AS SMALLINT),CAST(p_idTipoAccidente AS SMALLINT),CAST(p_idKilometro AS SMALLINT),CAST(p_idRuta AS SMALLINT));
END;
$BODY$ 
LANGUAGE plpgsql;

--MODIFICAR
select * from AccidentesTran.AccidentesGenerales
CREATE OR REPLACE FUNCTION modificar_accidentesGenerales
(	p_idAccidente INTEGER,
	p_horaInicio TIME,
	p_horaFinal TIME,
	p_areaGeografica CHAR(1),
	p_idDistrito INTEGER,
	p_tipoRuta CHAR(1),
	p_idTipoCirculacion INTEGER,
	p_idEstadoTiempo INTEGER,
	p_idTipoCalzada INTEGER,
	p_idDescripcionCalzadaVertical INTEGER,
	p_idDescripcionCalzadaHorizontal INTEGER,
	p_idTipoAccidente INTEGER,
	p_idKilometro INTEGER,
	p_idRuta INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE AccidentesTran.AccidentesGenerales SET
	HoraInicio=p_horaInicio,HoraFinal=p_horaFinal,AreaGeografica=p_areaGeografica,IdDistrito=p_idDistrito,TipoRuta=p_tipoRuta,IdTipoCirculacion=p_idTipoCirculacion,
	IdEstadoTiempo=p_idEstadoTiempo,IdTipoCalzada=p_idTipoCalzada,IdDescripcionCalzadaVertical=p_idDescripcionCalzadaVertical,
	IdDescripcionCalzadaHorizontal=p_idDescripcionCalzadaHorizontal,IdTipoAccidente=p_idTipoAccidente,IdKilometro=p_idKilometro,IdRuta=p_idRuta
	WHERE IdAccidente=p_idAccidente;
END;
$BODY$ 
LANGUAGE plpgsql;


--ELIMINAR
CREATE OR REPLACE FUNCTION borrar_accidentesGenerales
(	p_idAccidente INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM AccidentesTran.AccidentesGenerales  where IdAccidente = p_idAccidente;
END;
$BODY$ 
LANGUAGE plpgsql;


--Accidentes Personas

-- insertar accidente persona
CREATE OR REPLACE FUNCTION insertar_accidentePersona
(
	p_edad		 	INTEGER,
	p_sexo		 	BOOLEAN,
	p_idRolPersona	 	INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO AccidentesTran.Accidentes(Edad, Sexo, IdRolPersona) VALUES (p_idAccidente, p_edad, p_sexo, p_idRolPersona);
END;
$BODY$ 
LANGUAGE plpgsql;

-- modificar accidente persona
CREATE OR REPLACE FUNCTION modificar_accidentePersona
( 
	p_idAccidentePersona 	INTEGER,
	p_edad		 	INTEGER,
	p_sexo		 	BOOLEAN,
	p_idRolPersona	 	INTEGER	
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE AccidentesTran.Accidentes SET 
		Edad = p_edad,
		Sexo = p_sexo,
		IdRolPersona = p_idRolPersona
	WHERE IdAccidente = p_idAccidentePersona;
END;
$BODY$ 
LANGUAGE plpgsql;

-- borrar accidente persona
CREATE OR REPLACE FUNCTION borrar_accidentePersona
( 
	p_idAccidentePersona	INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM AccidentesTran.Accidentes AS A where A.IdAccidente = p_idAccidentePersona;	
END;
$BODY$ 
LANGUAGE plpgsql;


--Heridos

--INSERTAR
CREATE OR REPLACE FUNCTION insertar_Heridos
(
	p_idAccidente INTEGER,
	p_idDistrito INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO AccidentesTran.Heridos VALUES(p_idAccidente,p_idDistrito);
END
$BODY$ 
LANGUAGE plpgsql;

--MODIFICIAR
CREATE OR REPLACE FUNCTION modificar_Heridos
(
	p_idAccidente INTEGER,
	p_idDistrito INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE AccidentesTran.Heridos SET
	IdDistrito=p_idDistrito
	WHERE IdAccidente=p_idAccidente;
END
$BODY$ 
LANGUAGE plpgsql;

--ELIMINAR
CREATE OR REPLACE FUNCTION borrar_Heridos
(
	p_idAccidente INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM AccidentesTran.Heridos  where IdAccidente = p_idAccidente;
END
$BODY$ 
LANGUAGE plpgsql;

--Fallecidos

-- insertar fallecido
CREATE OR REPLACE FUNCTION insertar_fallecido
(
	p_idCanton	 	INTEGER,
	p_horaInicio	 	TIME,
	p_horaFinal	 	TIME,
	p_idTipoAccidente 	INTEGER,
	p_idRuta	 	INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO AccidentesTran.Fallecidos(IdCanton, HoraInicio, HoraFinal, IdTipoAccidente, IdRuta) 
	VALUES (p_idCanton, p_horaInicio, p_horaFinal, p_idTipoAccidente, p_idRuta);
END;
$BODY$ 
LANGUAGE plpgsql;


-- modificar fallecido
CREATE OR REPLACE FUNCTION modificar_fallecido
( 
	p_idFallecido	 	INTEGER,
	p_idCanton	 	INTEGER,
	p_horaInicio	 	TIME,
	p_horaFinal	 	TIME,
	p_idTipoAccidente 	INTEGER,
	p_idRuta	 	INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE AccidentesTran.Fallecidos SET 
		IdCanton = p_idCanton,
		HoraInicio = p_horaInicio,
		HoraFinal = p_horaFinal,
		IdTipoAccidente = p_idTipoAccidente,
		IdRuta = p_idRuta
	WHERE IdAccidente = p_idFallecido;
END;
$BODY$ 
LANGUAGE plpgsql;

-- borrar fallecido
CREATE OR REPLACE FUNCTION borrar_fallecido
( 
	p_idFallecido	INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM AccidentesTran.Fallecidos AS F where F.IdAccidente = p_idFallecido;	
END;
$BODY$ 
LANGUAGE plpgsql;



--TiposCirculacion

--INSERTAR 
CREATE OR REPLACE FUNCTION insertar_TiposCirculacion
(
	p_tipo VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO DetallesAccidentes.TiposCirculacion (Tipo) VALUES(p_tipo);
END
$BODY$ 
LANGUAGE plpgsql;

--MODIFICAR
CREATE OR REPLACE FUNCTION modificar_TiposCirculacion
(
	p_id INTEGER,
	p_tipo VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE DetallesAccidentes.TiposCirculacion SET
	Tipo=p_tipo WHERE Id=p_id;
END
$BODY$ 
LANGUAGE plpgsql;

--ELIMINAR
CREATE OR REPLACE FUNCTION borrar_TiposCirculacion
(
	p_id INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM DetallesAccidentes.TiposCirculacion WHERE Id=p_id;
END
$BODY$ 
LANGUAGE plpgsql;

--EstadosTiempo
-- insertar estados tiempo
CREATE OR REPLACE FUNCTION insertar_estadoTiempo
(
	p_estadoTiempo	 	VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO DetallesAccidentes.EstadosTiempo(Estado) VALUES (p_estadoTiempo);
END;
$BODY$ 
LANGUAGE plpgsql;

-- modificar estados tiempo
CREATE OR REPLACE FUNCTION modificar_estadoTiempo
(
	p_idEstadoTiempo	INTEGER,
	p_estadoTiempo	 	VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE DetallesAccidentes.EstadosTiempo SET 
		Estado = p_estadoTiempo
	WHERE Id = p_idEstadoTiempo;
END;
$BODY$ 
LANGUAGE plpgsql;


-- borrar estados tiempo
CREATE OR REPLACE FUNCTION borrar_estadoTiempo
( 
	p_idEstadoTiempo	INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM DetallesAccidentes.EstadosTiempo AS E where E.Id = p_idEstadoTiempo;	
END;
$BODY$ 
LANGUAGE plpgsql;


--TiposCalzadas

--INSERTAR
CREATE OR REPLACE FUNCTION insertar_TiposCalzadas
(
	p_tipo VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO DetallesAccidentes.TiposCalzadas (Tipo) VALUES (p_tipo);
END
$BODY$ 
LANGUAGE plpgsql;

--MODIFICAR
CREATE OR REPLACE FUNCTION modificar_TiposCalzadas
(
	p_id INTEGER,
	p_tipo VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE DetallesAccidentes.TiposCalzadas SET
	Tipo=p_tipo WHERE Id=p_id;
END
$BODY$ 
LANGUAGE plpgsql;

--ELIMINAR
CREATE OR REPLACE FUNCTION borrar_TiposCalzadas
(
	p_id INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM DetallesAccidentes.TiposCalzadas WHERE id=p_id;
END
$BODY$ 
LANGUAGE plpgsql;

--DescripcionesCalzadas

-- insertar descripcion calzada
CREATE OR REPLACE FUNCTION insertar_descripcionCalzada
(
	p_descripcionCalzada	 	VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO DetallesAccidentes.DescripcionesCalzadas(Descripcion) VALUES (p_descripcionCalzada);
END;
$BODY$ 
LANGUAGE plpgsql;

-- modificar descripcion calzada
CREATE OR REPLACE FUNCTION modificar_descripcionCalzada
(
	p_idDescripCalzada	INTEGER,
	p_descripcion	 	VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE DetallesAccidentes.DescripcionesCalzadas SET 
		Descripcion = p_descripcion
	WHERE Id = p_idDescripCalzada;
END;
$BODY$ 
LANGUAGE plpgsql;

-- borrar descripcion calzada
CREATE OR REPLACE FUNCTION borrar_descripcionCalzada
( 
	p_idDescripCalzada	INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM DetallesAccidentes.DescripcionesCalzadas AS D where D.Id = p_idDescripCalzada;	
END;
$BODY$ 
LANGUAGE plpgsql;

--TiposLesiones

--INSERTAR
CREATE OR REPLACE FUNCTION insertar_TiposLesiones
(
	p_tipo VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO DetallesAccidentes.TiposLesiones(Tipo) VALUES 
	(p_tipo);
END
$BODY$ 
LANGUAGE plpgsql;


--MODIFICAR
CREATE OR REPLACE FUNCTION modificar_TiposLesiones
(
	p_id INTEGER,
	p_tipo VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE DetallesAccidentes.TiposLesiones SET
	Tipo=p_tipo WHERE Id=p_id;
END
$BODY$ 
LANGUAGE plpgsql;

--ELIMINAR
CREATE OR REPLACE FUNCTION borrar_TiposLesiones
(
	p_id INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM DetallesAccidentes.TiposLesiones WHERE Id=p_id;
END
$BODY$ 
LANGUAGE plpgsql;

--KilometrosRutas

--INSERTAR
CREATE OR REPLACE FUNCTION insertar_KilometrosRutas
(
	p_numero VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO DetallesAccidentes.KilometrosRutas(Numero) VALUES 
	(p_numero);
END
$BODY$ 
LANGUAGE plpgsql;

--MODIFICAR
CREATE OR REPLACE FUNCTION modificar_KilometrosRutas
(	p_id INTEGER,
	p_numero VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE DetallesAccidentes.KilometrosRutas SET
	NUMERO=p_numero WHERE Id=p_id;
END
$BODY$ 
LANGUAGE plpgsql;

--ELIMINAR
CREATE OR REPLACE FUNCTION borrar_KilometrosRutas
(	
	p_id INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM DetallesAccidentes.KilometrosRutas 
	WHERE id=p_id;
END
$BODY$ 
LANGUAGE plpgsql;

--TiposAccidentes
-- insertar Tipos Accidentes
CREATE OR REPLACE FUNCTION insertar_tiposAccidente
(
	p_tipo	 	VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO DetallesAccidentes.TiposAccidentes(Tipo) VALUES (p_tipo);
END;
$BODY$ 
LANGUAGE plpgsql;

-- modificar Tipos Accidentes
CREATE OR REPLACE FUNCTION modificar_tiposAccidente
(
	p_idTipoAccidente	INTEGER,
	p_tipo		 	VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE DetallesAccidentes.TiposAccidentes SET 
		Tipo = p_tipo
	WHERE Id = p_idTipoAccidente;
END;
$BODY$ 
LANGUAGE plpgsql;

-- borrar Tipos Accidentes
CREATE OR REPLACE FUNCTION borrar_tiposAccidente
( 
	p_idTipoAccidente	INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM DetallesAccidentes.TiposAccidentes AS T where T.Id = p_idTipoAccidente;	
END;
$BODY$ 
LANGUAGE plpgsql;

--RolesPersonas

--INSERTAR
CREATE OR REPLACE FUNCTION insertar_RolesPersonas
(
	p_rol VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	INSERT INTO DetallesAccidentes.RolesPersonas(Rol) VALUES 
	(p_rol);
END
$BODY$ 
LANGUAGE plpgsql;

--MODIFICAR
CREATE OR REPLACE FUNCTION modificar_RolesPersonas
(	p_id INTEGER,
	p_rol VARCHAR(50)
) RETURNS VOID
AS
$BODY$
BEGIN
	UPDATE DetallesAccidentes.RolesPersonas SET
	Rol=p_rol WHERE Id=p_id;
END
$BODY$ 
LANGUAGE plpgsql;

--ELIMINAR
CREATE OR REPLACE FUNCTION borrar_RolesPersonas
(	
	p_id INTEGER
) RETURNS VOID
AS
$BODY$
BEGIN
	DELETE FROM DetallesAccidentes.RolesPersonas
	WHERE id=p_id;
END
$BODY$ 
LANGUAGE plpgsql;