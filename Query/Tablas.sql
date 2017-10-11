CREATE SCHEMA Direccion; -- esquema que contiene las tablas relacionadas con la direccion del accidente
CREATE SCHEMA DetallesAccidentes; --todas las tablas que detallen el accidente
CREATE SCHEMA AccidentesTran;		-- todas las tablas relacionadas con accidentes en general

CREATE TABLE Direccion.Provincias
(
	IdProvincia		SMALLSERIAL	NOT NULL,
	NombreProvincia		VARCHAR(50)	NOT NULL	UNIQUE,
	CONSTRAINT PK_IdProvincia_Provincias	PRIMARY KEY (IdProvincia)
);

CREATE TABLE Direccion.Cantones
(
	IdCanton 	SMALLSERIAL 	NOT NULL,
	IdProvincia 	SMALLINT 	NOT NULL,
	NombreCanton 	VARCHAR(50) 	NOT NULL,
	CONSTRAINT  PK_IdCanton_Cantones PRIMARY KEY (IdCanton),
	CONSTRAINT  FK_IdProvincia_Cantones FOREIGN KEY (IdProvincia) REFERENCES Direccion.Provincias ON DELETE CASCADE ON UPDATE CASCADE  
);

CREATE TABLE Direccion.Distritos 
(
	IdDistrito	SMALLSERIAL NOT NULL,
	IdCanton	SMALLINT NOT NULL,
	NombreDistrito	VARCHAR(50) NOT NULL,
	CONSTRAINT	PK_IdDistrito_Distritos	PRIMARY KEY (IdDistrito),
	CONSTRAINT	FK_IdCanton_Distritos	FOREIGN KEY(IdCanton) REFERENCES Direccion.Cantones ON DELETE CASCADE ON UPDATE CASCADE
);

--1. TABLA TiposCirculacion
CREATE TABLE DetallesAccidentes.TiposCirculacion
(
	Id	SMALLSERIAL	NOT NULL,
	Tipo	VARCHAR(50)	NOT NULL,

	CONSTRAINT PK_Id_TiposCirculacion PRIMARY KEY(Id),
	CONSTRAINT UNQ_Tipo_TiposCirculacion UNIQUE(Tipo)

);

--2. TABLA EstadosTiempo
CREATE TABLE DetallesAccidentes.EstadosTiempo
(
	Id	SMALLSERIAL	NOT NULL,
	Estado	VARCHAR(50)	NOT NULL,	-- describe el estado del tiempo al momento del accidente
	CONSTRAINT PK_Id_EstadosTiempo PRIMARY KEY(Id),
	CONSTRAINT UNQ_Estado_EstadosTiempo UNIQUE(Estado)
);

--3. TABLA TiposCalzadas
CREATE TABLE DetallesAccidentes.TiposCalzadas
(
	Id	SMALLSERIAL	NOT NULL,
	Tipo	VARCHAR(50)	NOT NULL,
	CONSTRAINT PK_Id_TiposCalzadas PRIMARY KEY(Id),
	CONSTRAINT UNQ_Tipo_TiposCalzadas UNIQUE(Tipo)
);

--4. TABLA DescripcionesCalzadas
CREATE TABLE DetallesAccidentes.DescripcionesCalzadas
(
	Id		SMALLSERIAL	NOT NULL,
	Descripcion	VARCHAR(50)	NOT NULL,
	CONSTRAINT PK_Id_DescripcionesCalzadas PRIMARY KEY(Id),
	CONSTRAINT UNQ_Descripcion_DesripcionesCalzadas UNIQUE(Descripcion)
);

--5. TABLA TiposLesiones
CREATE TABLE DetallesAccidentes.TiposLesiones
(
	Id	SMALLSERIAL	NOT NULL,
	Tipo	VARCHAR(50)	NOT NULL,
	CONSTRAINT PK_Id_TiposLesiones PRIMARY KEY(Id),
	CONSTRAINT UNQ_Tipo_TiposLesiones UNIQUE(Tipo)
);

--6. TABLA KilometrosRutas
CREATE TABLE DetallesAccidentes.KilometrosRutas
(
	Id	SMALLSERIAL	NOT NULL,
	Numero	VARCHAR(50)	NOT NULL,
	CONSTRAINT PK_Id_KilometrosRutas PRIMARY KEY(Id),
	CONSTRAINT UNQ_Numero_KilometrosRutas UNIQUE(Numero)
);

--7. TABLA TiposAccidentes
CREATE TABLE DetallesAccidentes.TiposAccidentes
(
	Id	SMALLSERIAL	NOT NULL,
	Tipo	VARCHAR(50)	NOT NULL,
	CONSTRAINT PK_Id_TiposAccidentes PRIMARY KEY(Id),
	CONSTRAINT UNQ_Tipo_TiposAccidentes UNIQUE(Tipo)
);

--8. TABLA RolesPersonas
CREATE TABLE DetallesAccidentes.RolesPersonas
(
	Id	SMALLSERIAL	NOT NULL,
	Rol	VARCHAR(50)	NOT NULL,
	CONSTRAINT PK_Id_RolesPersonas PRIMARY KEY(Id),
	CONSTRAINT UNQ_Rol_RolesPersonas UNIQUE(Rol)
	
);

CREATE TABLE AccidentesTran.Accidentes(
	Id SERIAL,
	IdTipoLesion SMALLINT NOT NULL,
	Fecha DATE NOT NULL DEFAULT(CURRENT_DATE),
	CONSTRAINT PK_Id_Accidentes PRIMARY KEY(Id),
	CONSTRAINT FK_IdTipoLesion_Accidentes FOREIGN KEY(IdTipoLesion) 
	REFERENCES DetallesAccidentes.TiposLesiones ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AccidentesTran.AccidentesPersonas(
	IdAccidente INT NOT NULL,
	Edad SMALLINT NOT NULL DEFAULT (0),
	Sexo  BOOLEAN NOT NULL DEFAULT(TRUE),
	IdRolPersona SMALLINT NOT NULL,
	CONSTRAINT PK_IdAccidente_AccidentesPersonas PRIMARY KEY(IdAccidente),
	CONSTRAINT FK_IdAccidente_AccidentesPersonas FOREIGN KEY(IdAccidente) REFERENCES AccidentesTran.Accidentes ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_IdRolPersona_AccidentesPersonas FOREIGN KEY (IdRolPersona) REFERENCES DetallesAccidentes.RolesPersonas ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AccidentesTran.Heridos(
	IdAccidente INT NOT NULL,
	IdDistrito SMALLINT NOT NULL,
	CONSTRAINT PK_IdAccidente_Heridos PRIMARY KEY (IdAccidente),
	CONSTRAINT FK_IdAccidente_Heridos FOREIGN KEY(IdAccidente) REFERENCES AccidentesTran.AccidentesPersonas ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_IdDistrito_Heridos FOREIGN KEY (IdDistrito)REFERENCES Direccion.Distritos ON DELETE CASCADE ON UPDATE CASCADE	
);

CREATE TABLE AccidentesTran.Fallecidos(
	IdAccidente INT NOT NULL,
	IdCanton SMALLINT NOT NULL,
	HoraInicio TIME NOT NULL DEFAULT(CURRENT_TIME),
	HoraFinal TIME  NOT NULL DEFAULT (CURRENT_TIME),
	IdTipoAccidente SMALLINT NOT NULL,
	IdRuta SMALLINT NOT NULL,
	CONSTRAINT PK_IdAccidente_Fallecidos PRIMARY KEY (IdAccidente),
	CONSTRAINT FK_IdAccidente_Fallecidos FOREIGN KEY (IdAccidente) REFERENCES AccidentesTran.AccidentesPersonas ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_IdCanton_Fallecidos FOREIGN KEY(IdCanton) REFERENCES Direccion.Cantones ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_IdTipoAccidente_Fallecidos FOREIGN KEY (IdTipoAccidente) REFERENCES DetallesAccidentes.TiposAccidentes ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_IdRuta_Fallecidos FOREIGN KEY (IdRuta) REFERENCES DetallesAccidentes.KilometrosRutas ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AccidentesTran.AccidentesGenerales(
	IdAccidente INT NOT NULL,
	HoraInicio TIME NOT NULL DEFAULT(CURRENT_TIME),
	HoraFinal TIME  NOT NULL DEFAULT (CURRENT_TIME),
	AreaGeografica CHAR(1) NOT NULL,
	IdDistrito SMALLINT NOT NULL,
	TipoRuta CHAR(1) NOT NULL,
	IdTipoCirculacion SMALLINT NOT NULL,
	IdEstadoTiempo SMALLINT NOT NULL,
	IdTipoCalzada SMALLINT NOT NULL,
	IdDescripcionCalzadaVertical SMALLINT NOT NULL,
	IdDescripcionCalzadaHorizontal SMALLINT NOT NULL,
	IdTipoAccidente SMALLINT NOT NULL,
	IdKilometro SMALLINT NOT NULL,
	IdRuta SMALLINT NOT NULL,
	CONSTRAINT  PK_IdAccidente_AccidentesGenerales  PRIMARY KEY(IdAccidente),
	CONSTRAINT  CHK_AreaGeografica_AccidentesGenerales  CHECK(AreaGeografica IN ('R','U','O')),
	CONSTRAINT  CHK_TipoRuta_AccidentesGenerales CHECK(AreaGeografica IN ('N','C','D')),
	CONSTRAINT  FK_IdDistrito_AccidentesGenerales FOREIGN KEY (IdDistrito) REFERENCES Direccion.Distritos ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT  FK_IdAccidente_AccidentesGenerales FOREIGN KEY (IdAccidente) REFERENCES AccidentesTran.Accidentes ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT  FK_IdTipoCirculacion_AccidentesGenerales FOREIGN KEY (IdTipoCirculacion) REFERENCES DetallesAccidentes.TiposCirculacion ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT  FK_IdEstadoTiempo_AccidentesGenerales FOREIGN KEY (IdEstadoTiempo) REFERENCES DetallesAccidentes.EstadosTiempo ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT  FK_IdTipoCalzada_AccidentesGenerales FOREIGN KEY (IdTipoCalzada) REFERENCES DetallesAccidentes.TiposCalzadas ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT  FK_IdDescripcionCalzadaVertical_AccidentesGenerales FOREIGN KEY (IdDescripcionCalzadaVertical) REFERENCES DetallesAccidentes.DescripcionesCalzadas ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT  FK_IdDescripcionCalzadaHorizontal_AccidentesGenerales FOREIGN KEY (IdDescripcionCalzadaHorizontal) REFERENCES DetallesAccidentes.DescripcionesCalzadas ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT  FK_IdTipoAccidente_AccidentesGenerales FOREIGN KEY (IdTipoAccidente) REFERENCES DetallesAccidentes.TiposAccidentes ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT  FK_IdKilometro_AccidentesGenerales FOREIGN KEY (IdKilometro) REFERENCES DetallesAccidentes.KilometrosRutas ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT  FK_IdRuta_AccidentesGenerales FOREIGN KEY (IdRuta) REFERENCES DetallesAccidentes.KilometrosRutas ON DELETE CASCADE ON UPDATE CASCADE
);