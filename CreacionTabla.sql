USE GD2C2021

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'ABAN_DER_ADOS')
	EXEC('CREATE SCHEMA ABAN_DER_ADOS')


--------------------- Creacion de Tablas ---------------------------------

CREATE TABLE [ABAN_DER_ADOS].Chofer(
				chof_leg nvarchar(50) NOT NULL,
				chof_nombre nvarchar(255),
				chof_apellido nvarchar(255),
				chof_dni decimal(18,0),
				chof_dire nvarchar(255),
				chof_mail nvarchar(255),
				chof_telef nvarchar(255),
				chof_fecha_nacimiento datetime2(3),
				chof_costo_hora decimal(18,0),
				CONSTRAINT PK_CHOFER PRIMARY KEY(chof_leg)

)

CREATE TABLE [ABAN_DER_ADOS].Ciudad(
				ciudad_cod nvarchar(50) NOT NULL,
				ciudad_nombre nvarchar(255),
				CONSTRAINT PK_CHOFER PRIMARY KEY(ciudad_cod)

)


CREATE TABLE [ABAN_DER_ADOS].TipoTarea(
				idTipoTarea nvarchar(50) NOT NULL,
				descripcion nvarchar(50),
				CONSTRAIN PK_TIPOTAREA PRIMARY KEY(idTipoTarea)
)

CREATE TABLE [ABAN_DER_ADOS].Tarea(
				codTarea nvarchar(50) NOT NULL,
				tipoTarea nvarchar(50) NOT NULL,
				nombre nvarchar(50),
				descripcion nvarchar(50),
				tiempoTarea int,
				CONSTRAIN PK_TAREA PRIMARY KEY(codTarea),
				CONSTRAIN FK_TAREA FOREING KEY(tipoTarea) REFERENCES TipoTarea(idTipoTarea)
	
)

CREATE TABLE [ABAN_DER_ADOS].Material(
				idMaterial nvarchar(50) NOT NULL,
				nombre nvarchar(50),
				precio int
				CONSTRAIN PK_MATERIAL PRIMARY KEY(idMaterial)
)

CREATE TABLE [ABAN_DER_ADOS].MaterialxTarea(
				idMaterial nvarchar(50) NOT NULL,
				codTarea nvarchar(50) NOT NULL,
				cantidad int,
				CONSTRAIN FK_MATERIALXTAREA FOREING KEY(idMaterial) REFERENCES Material(idMaterial),
				CONSTRAIN FK_MATERIALXTAREA FOREING KEY(codTarea) REFERENCES Tarea(codTarea)
				
)

CREATE TABLE [ABAN_DER_ADOS].TareaxOrden(
				idOrdenTrabajo int Identity(1,1) NOT NULL,
				codTarea nvarchar(50) NOT NULL,
				legajoMecanico int,
				duracionEstimada int,
				fechaInicio DATE,
				fechaFin DATE,
				duracionReal int,
				CONSTRAIN FK_TAREAXORDEN FOREING KEY(idOrdenTrabajo) REFERENCES OrdenTrabajo(orden_cod),
				CONSTRAIN FK_TAREAXORDEN FOREING KEY(codTarea) REFERENCES Tarea(codTarea),
				CONSTRAIN FK_TAREAXORDEN FOREING KEY(legajoMecanico) REFERENCES Mecanico(legajoMecanico),
)

CREATE TABLE [ABAN_DER_ADOS].EstadoOT(
				codEstado nvarchar(50) NOT NULL,
				descripcion nvarchar(50),
				CONSTRAIN PK_ESTADO PRIMARY KEY(codEstado)
				
)

CREATE TABLE [ABAN_DER_ADOS].OrdenTrabajo(
				orden_cod int Identity(1,1) NOT NULL,
				orden_fecha datetime2(3),
				orden_id_camion int FOREIGN KEY REFERENCES [ABAN_DER_ADOS].Camion(cam_patente),
				CONSTRAINT PK_OT PRIMARY KEY(orden_cod)


)

CREATE TABLE [ABAN_DER_ADOS].Mecanico(
				legajoMecanico int NOT NULL,
				idTaller nvarchar(50) NOT NULL,
				nombre nvarchar(50), 
				apellido nvarchar(50), 
				DNI int NOT NULL,
				direccion nvarchar(50),
				mail nvarchar(255),
				fechaNac DATE,
				telefono int,
				costoHora int
				CONSTRAINT PK_MECANICO PRIMARY KEY(legajoMecanico),
				CONSTRAINT FK_MECANICO FOREING KEY(idTaller) REFERENCES Taller(idTaller)
)

CREATE TABLE [ABAN_DER_ADOS].Taller(
				idTaller nvarchar(50) NOT NULL,
				nombre nvarchar(50),
				cod_cuidad nvarchar(50) NOT NULL,
				direccion nvarhar(50),
				telefono int,
				mail nvarchar(255)
				CONSTRAINT PK_TALLER PRIMARY KEY(idTaller),
				CONSTRAINT FK_TALLER FOREING KEY(codCuidad) REFERENCES Cuidad(codCuidad)
				
)

CREATE TABLE [ABAN_DER_ADOS].Marca(
				idMarca nvarchar(50) NOT NULL,
				descripcion nvarchar(50),
				CONSTRAINT PK_MARCA PRIMARY KEY(idMarca),
				
)

CREATE TABLE [ABAN_DER_ADOS].ModeloCamion(
				idModelo nvarchar(50) NOT NULL,
				descripcion nvarchar(50),
				idMarca nvarchar(50) NOT NULL,
				capacidadCarga int,
				capidadTanque int,
				velocidadMax int,
				CONSTRAINT PK_MODELOCAMION PRIMARY KEY(idModelo),
				CONSTRAINT FK_MODELOCAMION FOREING KEY(idMarca) REFERENCES Marca(idMarca)
)

CREATE TABLE [ABAN_DER_ADOS].Camion(
				patenteCamion nvarchar(7) NOT NULL,
				idModelo nvarchar(50) NOT NULL,
				marca nvarchar(50) NOT NULL,
				fechaAlta DATE,
				nroMotor int,
				nroChasis int,
				patente int,   (- ojo con esto -)
				CONSTRAINT PK_CAMION PRIMARY KEY(patenteCamion),
				CONSTRAINT FK_CAMION FOREING KEY(idModelo) REFERENCES Modelo(idModelo)
				CONSTRAINT FK_CAMION FOREING KEY(marca) REFERENCES Marca(idMarca)				
)

CREATE TABLE [ABAN_DER_ADOS].TipoPaquete(
				idTipo nvarchar(50) NOT NULL,
				pesoMax int,
				altoMax int,
				anchoMax int,
				largoMax int,
				descripcion nvarchar(50),
				precio int,
				CONSTRAINT PK_TIPOPAQUERE PRIMARY KEY(idTipo)
)

CREATE TABLE [ABAN_DER_ADOS].Paquete(
				idPaquete nvarchar(50) NOT NULL,
				tipoPaquete nvarchar(50) NOT NULL,
				descripcion nvarchar(50),
				CONSTRAINT PK_PAQUETE PRIMARY KEY(idPaquete),
				CONSTRAINT FK_PAQUETE FOREING KEY(tipoPaquete) REFERENCES TipoPaquete(idTipo)
)

CREATE TABLE [ABAN_DER_ADOS].PaquetexViaje(
				idPaquete nvarchar(50) NOT NULL,  (- ojo preguntar con esto -)
				idViaje nvarchar(50) NOT NULL, 
				cantidad int,
				CONSTRAINT FK_PAQUETEXVIAJE FOREING KEY(idPaquete) REFERENCES Paquete(idPaquete) ,
				CONSTRAINT FK_PAQUETEXVIAJE FOREING KEY(idViaje) REFERENCES Viaje(idViaje)
)

CREATE TABLE [ABAN_DER_ADOS].Viaje(
				idViaje nvarchar(50) NOT NULL,
				legajoChofer int 
				patenteCamion nvarchar(7),
				idRecorrido nvarchar(50),
				fechaInicio DATE,
				fechaFin DATE,
				litrosCombustible int,
				CONSTRAINT FK_VIAJE FOREING KEY(legajoChofer) REFERENCES Chofer(legajoChofer) 
				CONSTRAINT FK_VIAJE FOREING KEY(patenteCamion) REFERENCES Camion(patenteCamion) 
				CONSTRAINT FK_VIAJE FOREING KEY(idRecorrido) REFERENCES Recorrido(idRecorrido) 
	
)

CREATE TABLE [ABAN_DER_ADOS].Recorrido(
				idRecorrido nvarchar(50) NOT NULL,
				origen nvarchar(50),
				destino nvarcvhar(50),
				cantKm int
				precio int
				CONSTRAINT FK_RECORRIDO FOREING KEY(origen) REFERENCES Ciudad(ciudad_cod), 
				CONSTRAINT FK_RECORRIDO FOREING KEY(destino) REFERENCES Ciudad(ciudad_cod) 
)



