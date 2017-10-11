
/**  Triggers  ***/


/** cantones,Distritos */

--INSERCION

--funcion para validar insercion de un canton o un distrito
CREATE OR REPLACE FUNCTION validar_insertCantonesDistritos
(
) RETURNS TRIGGER
AS
$BODY$

DECLARE texto VARCHAR(50); --almacena nombre del distrito o del canton a insertar

BEGIN 
	
	IF (TG_RELNAME ='cantones') THEN
		texto=NEW.NombreCanton;
		
		IF ((length(NEW.NombreCanton) < 3) OR (NEW.NombreCanton SIMILAR TO '%[0-9]%')=TRUE) THEN
			
			RAISE EXCEPTION 'Formato de nombre de canton no valido';
		
		END IF;
	ELSE
		texto=NEW.NombreDistrito;
		IF ((length(NEW.NombreDistrito) < 3) OR (NEW.NombreDistrito SIMILAR TO '%[0-9]%')=TRUE) THEN
			RAISE EXCEPTION 'Formato de distrito no valido';
		END IF;
	END IF;
	

/**  */

CREATE TRIGGER trigger_insert_provincias 
BEFORE INSERT 
ON Direccion.Provincias
FOR EACH ROW 
EXECUTE PROCEDURE validar_insert_provincias();

CREATE OR REPLACE FUNCTION validar_insert_provincias() 
RETURNS TRIGGER
AS
$BODY$
BEGIN 
	IF ((SELECT LENGTH(NEW.NombreProvincia) < 5) or (SELECT NEW.NombreProvincia SIMILAR TO '%[0-9]%'))THEN -- cantidad minima de caracteres para provincias
		RAISE EXCEPTION 'El nombre de la provincia debe tener mínimo 5 caractéres y no puede incluir números.';
     	END IF;

     	RETURN NEW;
END;
$BODY$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_insertCantones
BEFORE INSERT 
ON Direccion.Cantones
FOR EACH ROW 
execute procedure validar_insertCantonesDistritos();

CREATE TRIGGER trigger_insertDistritos
BEFORE INSERT 
ON Direccion.Distritos
FOR EACH ROW 
execute procedure validar_insertCantonesDistritos();

--Actualizar sobre tablas del schema direccion, trigger de verificacion

--funcion para validar insercion de un canton o un distrito
CREATE OR REPLACE FUNCTION validar_updateDireccion
(
) RETURNS TRIGGER
AS
$BODY$

BEGIN 
	IF (TG_RELNAME ='provincias') THEN
		IF ((NEW.NombreProvincia isnull)OR(length(NEW.NombreProvincia) < 5) OR ((NEW.NombreProvincia SIMILAR TO '%[0-9]%')=TRUE) OR (NEW.NombreProvincia=OLD.NombreProvincia)) THEN
			RAISE EXCEPTION 'Formato de nombre de provincia no valido';
		END IF;
		
	ELSIF (TG_RELNAME ='cantones') THEN
		
		IF ( (NEW.NombreCanton isnull) OR (length(NEW.NombreCanton) < 3) OR ((NEW.NombreCanton SIMILAR TO '%[0-9]%')=TRUE) OR (NEW.NombreCanton=OLD.NombreCanton)) THEN
			
			RAISE EXCEPTION 'Formato de nombre de canton no valido';
		
		END IF;
	ELSE 
		IF ( (NEW.NombreDistrito isnull) OR (length(NEW.NombreDistrito) < 3) OR ((NEW.NombreDistrito SIMILAR TO '%[0-9]%')=TRUE) OR (NEW.NombreDistrito=OLD.NombreDistrito)) THEN
			RAISE EXCEPTION 'Formato de nombre de distrito no valido';
		END IF;
	END IF;
	
     	RETURN NEW;
END;
$BODY$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_updateCantones
AFTER UPDATE 
ON Direccion.Cantones
FOR EACH ROW 
execute procedure validar_updateDireccion();

CREATE TRIGGER trigger_updateDistritos
AFTER UPDATE 
ON Direccion.Distritos
FOR EACH ROW 
execute procedure validar_updateDireccion();

CREATE TRIGGER trigger_updateProvincias
AFTER UPDATE 
ON Direccion.Provincias
FOR EACH ROW 
execute procedure validar_updateDireccion();


/*
	TRIGGERS ELIMINAR DIRECCION

*/
CREATE TRIGGER trigger_delete_provincias 
BEFORE DELETE 
ON Direccion.Provincias
FOR EACH ROW 
EXECUTE PROCEDURE validar_delete_direccion();

CREATE TRIGGER trigger_delete_distritos 
BEFORE DELETE 
ON Direccion.Distritos
FOR EACH ROW 
EXECUTE PROCEDURE validar_delete_direccion();

CREATE TRIGGER trigger_delete_cantones 
BEFORE DELETE 
ON Direccion.Cantones
FOR EACH ROW 
EXECUTE PROCEDURE validar_delete_direccion();

CREATE OR REPLACE FUNCTION validar_delete_direccion() 
RETURNS TRIGGER
AS
$BODY$
BEGIN   
	IF (TG_RELNAME = 'provincias') THEN 
		IF (((SELECT COUNT(IdProvincia) FROM Direccion.Provincias AS P WHERE P.IdProvincia = OLD.IdProvincia) > 0) AND
		((SELECT COUNT(*) FROM Direccion.Cantones WHERE IdProvincia=OLD.IdProvincia)>0)) THEN
			RAISE EXCEPTION 'No es posible eliminar la provincia';
		END IF;
	ELSIF (TG_RELNAME = 'cantones') THEN 
		IF (((SELECT COUNT(IdCanton) FROM Direccion.Cantones AS C WHERE C.IdCanton = OLD.IdCanton) > 0) AND
		(((SELECT COUNT(*) FROM Direccion.Distritos WHERE IdCanton=OLD.IdCanton)>0)OR
		((SELECT COUNT(*)FROM AccidentesTran.Fallecidos WHERE IdCanton=OLD.IdCanton)>0)))
		 THEN
			RAISE EXCEPTION 'No es posible eliminar el canton';
		END IF;
	ELSIF (TG_RELNAME = 'distritos') THEN 
		IF (((SELECT COUNT(IdDistrito) FROM Direccion.Distritos AS D WHERE D.IdDistrito = OLD.IdDistrito) > 0) AND
		(((SELECT COUNT(*) FROM AccidentesTran.Heridos WHERE IdDistrito=OLD.IdDistrito)>0)OR
		((SELECT COUNT(*)FROM AccidentesTran.AccidentesGenerales WHERE IdDistrito=OLD.IdDistrito)>0)))THEN
			RAISE EXCEPTION 'No es posible eliminar el distrito';
			
		END IF;
     	END IF;
     	RETURN OLD;
END;
$BODY$ LANGUAGE plpgsql;

select * from Direccion.Cantones
select borrar_provincia(1);
select borrar_cantones(327);

/**
--TRIGERRS PARA TABLAS tipos lesiones,KilometrosRuta,Tipos_Accidentes,RolesPersonas
*/


--TRIGGERS INSERCION

--funcion que valida tanto la insercion como la atualizacion de datos para las tablas mencionadas
CREATE OR REPLACE FUNCTION validar_InsUpd_LesionesTiposAccidentesKRRPersonas
()
RETURNS TRIGGER AS
$BODY$
BEGIN 
	
	IF (TG_RELNAME='tiposlesiones') THEN
		IF ((NEW.Tipo isnull)  OR ((NEW.Tipo SIMILAR TO '%[0-9]%')=TRUE) OR 
		((SELECT COUNT(Id) FROM DetallesAccidentes.TiposLesiones WHERE Tipo LIKE NEW.Tipo )>0) OR
		(length(NEW.Tipo)=0)) THEN
			
			RAISE EXCEPTION 'Tipo de lesión no válido';
		
		END IF;
	ELSIF (TG_RELNAME='kilometrosrutas') THEN
		IF ((NEW.Numero isnull)  OR  
		((SELECT COUNT(Id) FROM DetallesAccidentes.KilometrosRutas WHERE Numero LIKE NEW.Numero ) >0) OR
		(length(NEW.Numero)=0)) THEN
			RAISE EXCEPTION 'Número de ruta no válido';

		END IF;
	ELSIF (TG_RELNAME='tiposaccidentes') THEN
		IF ((NEW.Tipo isnull)  OR ((NEW.Tipo SIMILAR TO '%[0-9]%')=TRUE) OR 
		((SELECT COUNT(Id) FROM DetallesAccidentes.TiposAccidentes WHERE Tipo LIKE NEW.Tipo ) >0 )OR
		(length(NEW.Tipo)=0)) THEN
			RAISE EXCEPTION 'Tipo de accidente no válido';

		END IF;
	ELSE
		IF ((NEW.Rol isnull)  OR ((NEW.Rol SIMILAR TO '%[0-9]%')=TRUE) OR 
		((SELECT COUNT(Id) FROM DetallesAccidentes.RolesPersonas WHERE Rol LIKE NEW.Rol ) >0 )OR
		(length(NEW.Rol)=0)) THEN
			RAISE EXCEPTION 'Tipo de rol no válido';

		END IF;
	END IF;
	RETURN NEW;
	
END;
$BODY$
LANGUAGE plpgsql;


CREATE TRIGGER trigger_insertTiposLesiones
BEFORE INSERT
ON DetallesAccidentes.TiposLesiones
FOR EACH ROW
EXECUTE PROCEDURE validar_InsUpd_LesionesTiposAccidentesKRRPersonas();

CREATE TRIGGER trigger_insertKilometrosRutas
BEFORE INSERT
ON DetallesAccidentes.KilometrosRutas
FOR EACH ROW
EXECUTE PROCEDURE validar_InsUpd_LesionesTiposAccidentesKRRPersonas();

CREATE TRIGGER trigger_insertTiposAccidentes
BEFORE INSERT
ON DetallesAccidentes.TiposAccidentes
FOR EACH ROW
EXECUTE PROCEDURE validar_InsUpd_LesionesTiposAccidentesKRRPersonas();

CREATE TRIGGER trigger_insertRolesPersonas
BEFORE INSERT
ON DetallesAccidentes.RolesPersonas
FOR EACH ROW
EXECUTE PROCEDURE validar_InsUpd_LesionesTiposAccidentesKRRPersonas();

--TRIGGERS Actualizar


CREATE TRIGGER trigger_updateTiposLesiones
AFTER UPDATE 
ON DetallesAccidentes.TiposLesiones
FOR EACH ROW
EXECUTE PROCEDURE validar_InsUpd_LesionesTiposAccidentesKRRPersonas();

CREATE TRIGGER trigger_updatetKilometrosRutas
AFTER UPDATE
ON DetallesAccidentes.KilometrosRutas
FOR EACH ROW
EXECUTE PROCEDURE validar_InsUpd_LesionesTiposAccidentesKRRPersonas();

CREATE TRIGGER trigger_updateTiposAccidentes
AFTER UPDATE
ON DetallesAccidentes.TiposAccidentes
FOR EACH ROW
EXECUTE PROCEDURE validar_InsUpd_LesionesTiposAccidentesKRRPersonas();

CREATE TRIGGER trigger_updateRolesPersonas
AFTER UPDATE
ON DetallesAccidentes.RolesPersonas
FOR EACH ROW
EXECUTE PROCEDURE validar_InsUpd_LesionesTiposAccidentesKRRPersonas();

/*
	TRIGGER DE ELIMINACIÓN

*/
--Funcion para validar la eliminacion de las tablas mencionadas
CREATE OR REPLACE FUNCTION validar_deleteLesionesTiposAccidentesKRRPersonas
()
RETURNS TRIGGER AS
$BODY$
BEGIN 

	IF (TG_RELNAME='tiposlesiones') THEN
		raise notice 'id esta %',(SELECT COUNT(Id) FROM DetallesAccidentes.TiposLesiones WHERE OLD.Id=Id);
		IF (((SELECT COUNT(Id) FROM DetallesAccidentes.TiposLesiones WHERE OLD.Id=Id) > 0) AND 
		((SELECT COUNT(Id) FROM AccidentesTran.Accidentes WHERE IdTipoLesion=OLD.Id)>0)) THEN
			
			RAISE EXCEPTION 'Tipo de lesión no puede eliminarse';
		
		END IF;
	ELSIF (TG_RELNAME='kilometrosrutas') THEN
		IF (((SELECT COUNT(Id) FROM DetallesAccidentes.KilometroRutas WHERE OLD.Id=Id) > 0) AND 
		(((SELECT COUNT(*) FROM AccidentesTran.AccidentesGenerales WHERE IdKilometro=OLD.Id OR IdRuta=OLD.Id)>0)OR
		((SELECT COUNT(*) FROM AccidentesTran.Fallecidos WHERE IdRuta=OLD.Id)>0))
		) THEN
			RAISE EXCEPTION 'Kilometro/Ruta no puede eliminarse';

		END IF;
	ELSIF (TG_RELNAME='tiposaccidentes') THEN
		IF (((SELECT COUNT(Id) FROM DetallesAccidentes.TiposAccidentes WHERE OLD.Id=Id)>0)
		AND (((SELECT COUNT(*) FROM AccidentesTran.AccidentesGenerales WHERE IdTipoAccidente=OLD.Id)>0) OR
		((SELECT COUNT(*) FROM AccidentesTran.Fallecidos WHERE IdTipoAccidente=OLD.Id)>0)))
		 THEN
			RAISE EXCEPTION 'Tipo de accidente no se puede eliminar';

		END IF;
	ELSE
		IF (((SELECT COUNT(Id) FROM DetallesAccidentes.RolesPersonas WHERE OLD.Id=Id)>0) AND
		    ((SELECT COUNT(*) FROM AccidentesTran.AccidentesPersonas
		     WHERE IdRolPersona=OLD.Id)>0))
			THEN
			RAISE EXCEPTION 'Tipo de rol no se encuentra registrado';

		END IF;
	END IF;
	RETURN OLD;
	
END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER trigger_deleteTiposLesiones
BEFORE DELETE 
ON DetallesAccidentes.TiposLesiones
FOR EACH ROW
EXECUTE PROCEDURE validar_deleteLesionesTiposAccidentesKRRPersonas();

CREATE TRIGGER trigger_deletetKilometrosRutas
BEFORE DELETE
ON DetallesAccidentes.KilometrosRutas
FOR EACH ROW
EXECUTE PROCEDURE validar_deleteLesionesTiposAccidentesKRRPersonas();

CREATE TRIGGER trigger_deleteTiposAccidentes
BEFORE DELETE
ON DetallesAccidentes.TiposAccidentes
FOR EACH ROW
EXECUTE PROCEDURE validar_deleteLesionesTiposAccidentesKRRPersonas();

CREATE TRIGGER trigger_deleteRolesPersonas
BEFORE DELETE
ON DetallesAccidentes.RolesPersonas
FOR EACH ROW
EXECUTE PROCEDURE validar_deleteLesionesTiposAccidentesKRRPersonas();



---------------------------------------------------
	-- 	TRIGGER DE INSERT	--
---------------------------------------------------
--1. trigger que valida la insercion de datos en la tabla tiposCirculacion
CREATE TRIGGER trigger_insert_tipoCirculacion
BEFORE INSERT 
ON DetallesAccidentes.TiposCirculacion
FOR EACH ROW 
EXECUTE PROCEDURE validar_InsUpd_TETD();

--2. trigger que valida la insercion de datos en la tabla estadosTiempo
CREATE TRIGGER trigger_insert_estadosTiempo
BEFORE INSERT 
ON DetallesAccidentes.EstadosTiempo
FOR EACH ROW 
EXECUTE PROCEDURE validar_InsUpd_TETD();

--3. trigger que valida la insercion de datos en la tabla tiposCalzadas
CREATE TRIGGER trigger_insert_tiposCalzadas
BEFORE INSERT 
ON DetallesAccidentes.TiposCalzadas
FOR EACH ROW 
EXECUTE PROCEDURE validar_InsUpd_TETD();

--4. trigger que valida la insercion de datos en la tabla descripcionesCalzadas
CREATE TRIGGER trigger_insert_descripcionesCalzadas
BEFORE INSERT 
ON DetallesAccidentes.DescripcionesCalzadas
FOR EACH ROW 
EXECUTE PROCEDURE validar_InsUpd_TETD();

---------------------------------------------------
	-- 	TRIGGER DE UPDATE	--
---------------------------------------------------
--1. trigger que valida la actualizacion de datos en la tabla tiposCirculacion
CREATE TRIGGER trigger_update_tipoCirculacion
AFTER UPDATE 
ON DetallesAccidentes.TiposCirculacion
FOR EACH ROW 
EXECUTE PROCEDURE validar_InsUpd_TETD();

--2. trigger que valida la actualizacion de datos en la tabla estadosTiempo
CREATE TRIGGER trigger_update_estadosTiempo
AFTER UPDATE
ON DetallesAccidentes.EstadosTiempo
FOR EACH ROW 
EXECUTE PROCEDURE validar_InsUpd_TETD();

--3. trigger que valida la actualizacion de datos en la tabla tiposCalzadas
CREATE TRIGGER trigger_update_tiposCalzadas
AFTER UPDATE 
ON DetallesAccidentes.TiposCalzadas
FOR EACH ROW 
EXECUTE PROCEDURE validar_InsUpd_TETD();

--4. trigger que valida la actualizacion de datos en la tabla descripcionesCalzadas
CREATE TRIGGER trigger_update_descripcionesCalzadas
AFTER UPDATE
ON DetallesAccidentes.DescripcionesCalzadas
FOR EACH ROW 
EXECUTE PROCEDURE validar_InsUpd_TETD();

-------------------------------------------------
		-- FUNCION TETD --
		
		-- TipoCirculacion
		-- EstadoTiempO
		-- TipoCalzada
		-- DescipcionCalzada 
-------------------------------------------------
CREATE OR REPLACE FUNCTION validar_InsUpd_TETD() 
RETURNS TRIGGER
AS
$BODY$
BEGIN   
	IF (TG_RELNAME = 'tiposcirculacion') THEN 
		IF (	/*validacion #1: si ya existe el tipo ingresado */
			((SELECT COUNT(Tipo) FROM DetallesAccidentes.TiposCirculacion AS TC WHERE TC.Tipo = NEW.Tipo) > 0) OR 
			/*validacion #2: si tiene numeros el tipo ingresado */
			(SELECT NEW.Tipo SIMILAR TO '%[0-9]%') OR
			/*validacion #3: si el valor ingresado es null */
			(NEW.Tipo ISNULL) OR
			/*validacion #4: si el valor ingresado es '' es decir no escribe nada */
			(length(NEW.Tipo) = 0)) THEN
				RAISE EXCEPTION 'Error con el dato ingresado de la tabla estados tipos circulacion.';
		END IF;
	ELSIF (TG_RELNAME = 'estadostiempo') THEN 
		IF (	/*validacion #1: si ya existe el tipo ingresado */
			((SELECT COUNT(Estado) FROM DetallesAccidentes.EstadosTiempo AS ET WHERE ET.Estado = NEW.Estado) > 0) OR 
			/*validacion #2: si tiene numeros el tipo ingresado */
			(SELECT NEW.Estado SIMILAR TO '%[0-9]%') OR
			/*validacion #3: si el valor ingresado es null */
			(NEW.Estado ISNULL) OR
			/*validacion #4: si el valor ingresado es '' es decir no escribe nada */
			(length(NEW.Estado) = 0)) THEN
				RAISE EXCEPTION 'Error con el dato ingresado de la tabla estados tiempo.';
		END IF;
	ELSIF (TG_RELNAME = 'tiposcalzadas') THEN 
		IF (	/*validacion #1: si ya existe el tipo ingresado */
			((SELECT COUNT(Tipo) FROM DetallesAccidentes.TiposCalzadas AS TC WHERE TC.Tipo = NEW.Tipo) > 0) OR 
			/*validacion #2: si tiene numeros el tipo ingresado */
			(SELECT NEW.Tipo SIMILAR TO '%[0-9]%') OR
			/*validacion #3: si el valor ingresado es null */
			(NEW.Tipo ISNULL) OR
			/*validacion #4: si el valor ingresado es '' es decir no escribe nada */
			(length(NEW.Tipo) = 0)) THEN
				RAISE EXCEPTION 'Error con el dato ingresado de la tabla tipos calzadas.';
		END IF;
	ELSIF (TG_RELNAME = 'descripcionescalzadas') THEN 
		IF (	/*validacion #1: si ya existe el tipo ingresado */
			((SELECT COUNT(Descripcion) FROM DetallesAccidentes.DescripcionesCalzadas AS DC WHERE DC.Descripcion = NEW.Descripcion) > 0) OR 
			/*validacion #2: si tiene numeros el tipo ingresado */
			(NEW.Descripcion SIMILAR TO '%[0-9]%') OR
			/*validacion #3: si el valor ingresado es null */
			(NEW.Descripcion ISNULL) OR
			/*validacion #4: si el valor ingresado es '' es decir no escribe nada */
			(LENGTH(NEW.Descripcion) = 0)) THEN
				RAISE EXCEPTION 'Error con el dato ingresado de la tabla descripciones calzadas.';
		END IF;
     	END IF;
     	RETURN NEW;
END;
$BODY$ LANGUAGE plpgsql;

---------------------------------------------------
	-- 	TRIGGER DE DELETE	--
---------------------------------------------------
--1. trigger que valida la eliminacion de datos en la tabla tiposCirculacion
CREATE TRIGGER trigger_delete_tipoCirculacion
BEFORE DELETE 
ON DetallesAccidentes.TiposCirculacion
FOR EACH ROW 
EXECUTE PROCEDURE validar_delete_TETD();

--2. trigger que valida la eliminacion de datos en la tabla estadosTiempo
CREATE TRIGGER trigger_delete_estadosTiempo
BEFORE DELETE
ON DetallesAccidentes.EstadosTiempo
FOR EACH ROW 
EXECUTE PROCEDURE validar_delete_TETD();

--3. trigger que valida la eliminacion de datos en la tabla tiposCalzadas
CREATE TRIGGER trigger_delete_tiposCalzadas
BEFORE DELETE 
ON DetallesAccidentes.TiposCalzadas
FOR EACH ROW 
EXECUTE PROCEDURE validar_delete_TETD();

--4. trigger que valida la eliminacion de datos en la tabla descripcionesCalzadas
CREATE TRIGGER trigger_delete_descripcionesCalzadas
BEFORE DELETE
ON DetallesAccidentes.DescripcionesCalzadas
FOR EACH ROW 
EXECUTE PROCEDURE validar_delete_TETD();

-------------------------------------------------
		-- FUNCION TETD --
		
		-- TipoCirculacion
		-- EstadoTiempo
		-- TipoCalzada
		-- DescipcionCalzada 
-------------------------------------------------
CREATE OR REPLACE FUNCTION validar_delete_TETD() 
RETURNS TRIGGER
AS
$BODY$
BEGIN   
	IF (TG_RELNAME = 'tiposcirculacion') THEN 
		/*validacion #1: si ya existe el id ingresado */
		IF (((SELECT COUNT(*) FROM DetallesAccidentes.TiposCirculacion AS TC WHERE TC.Id = OLD.Id) > 0) AND
		   ((SELECT COUNT(*) FROM AccidentesTran.AccidentesGenerales AS AG WHERE AG.IdTipoCirculacion = OLD.Id) > 0)) THEN
			RAISE EXCEPTION 'Error al intentar eliminar en la tabla estados tipos circulacion.';
		END IF;
	ELSIF (TG_RELNAME = 'estadostiempo') THEN 
		/*validacion #1: si ya existe el id ingresado */
		IF (((SELECT COUNT(*) FROM DetallesAccidentes.EstadosTiempo AS ET WHERE ET.Id = NEW.Id) > 0) AND
		   ((SELECT COUNT(*) FROM AccidentesTran.AccidentesGenerales AS AG WHERE AG.IdEstadoTiempo = OLD.Id) > 0)) THEN
			RAISE EXCEPTION 'Error al intentar eliminar en la tabla estados tiempo.';
		END IF;
	ELSIF (TG_RELNAME = 'tiposcalzadas') THEN 
		/*validacion #1: si ya existe el id ingresado */
		IF (((SELECT COUNT(*) FROM DetallesAccidentes.TiposCalzadas AS TC WHERE TC.Id = NEW.Id) > 0)AND
		   ((SELECT COUNT(*) FROM AccidentesTran.AccidentesGenerales AS AG WHERE AG.IdTipoCalzada = OLD.Id) > 0))THEN
			RAISE EXCEPTION 'Error al intentar eliminar en la tabla tipos calzadas.';
		END IF;
	ELSIF (TG_RELNAME = 'descripcionescalzadas') THEN 
		/*validacion #1: si ya existe el id ingresado */
		IF (((SELECT COUNT(*) FROM DetallesAccidentes.DescripcionesCalzadas AS DC WHERE DC.Id = NEW.Id) > 0) AND
		   (((SELECT COUNT(*) FROM AccidentesTran.AccidentesGenerales AS AG WHERE AG.IdDescripcionCalzadaVertical = OLD.Id) > 0) OR
		   ((SELECT COUNT(*) FROM AccidentesTran.AccidentesGenerales AS AG WHERE AG.IdDescripcionCalzadaHorizontal = OLD.Id) > 0))) THEN 
			RAISE EXCEPTION 'Error al intentar eliminar en la tabla descripciones calzadas.';
		END IF;
     	END IF;
     	RETURN OLD;
END;
$BODY$ LANGUAGE plpgsql;

