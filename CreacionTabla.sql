USE GD2C2021

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'ABAN_DER_ADOS')
	EXEC('CREATE SCHEMA ABAN_DER_ADOS')


--------------------- Creacion de Tablas ---------------------------------

CREATE TABLE [ABAN_DER_ADOS].Chofer(
				leg_chofer int NOT NULL,
				nombre nvarchar(255),
				apellido nvarchar(255),
				dni decimal(18,0),
				dire nvarchar(255),
				mail nvarchar(255),
				telef nvarchar(255),
				fecha_nacimiento datetime2(3),
				costo_hora decimal(18,0),
				CONSTRAINT PK_CHOFER PRIMARY KEY(leg_chofer)
)
CREATE TABLE [ABAN_DER_ADOS].Ciudad(
				cod_ciudad int identity(1,1) NOT NULL,
				nombre nvarchar(255),
				CONSTRAINT PK_ciudad PRIMARY KEY(cod_ciudad)

)
CREATE TABLE [ABAN_DER_ADOS].Tipo_Tarea(	
				cod_tipo_tarea nvarchar(50) NOT NULL,
				descripcion nvarchar(50),
				CONSTRAINT PK_Tipo_Tarea PRIMARY KEY(cod_tipo_tarea)
)
CREATE TABLE [ABAN_DER_ADOS].Tarea(
				cod_tarea  int identity(1,1) NOT NULL,
				tipo_tarea nvarchar(50) NOT NULL,
				nombre nvarchar(50),
				descripcion nvarchar(50),
				tiempo_tarea int,
				CONSTRAINT PK_tarea PRIMARY KEY(cod_tarea),
				CONSTRAINT FK_cod_tipo_tarea FOREIGN KEY(Tipo_Tarea) REFERENCES [ABAN_DER_ADOS].[Tipo_Tarea](cod_tipo_tarea)
	
)
CREATE TABLE [ABAN_DER_ADOS].Material(
				cod_material nvarchar(50) NOT NULL,
				nombre nvarchar(50),
				precio int
				CONSTRAINT PK_MATERIAL PRIMARY KEY(cod_material)
)
CREATE TABLE [ABAN_DER_ADOS].Material_x_Tarea(
				cod_material nvarchar(50) NOT NULL,
				cod_tarea  int NOT NULL,
				cantidad int,
				CONSTRAINT FK_cod_material FOREIGN KEY(cod_material) REFERENCES [ABAN_DER_ADOS].[Material](cod_material),
				CONSTRAINT FK_cod_tarea  FOREIGN KEY(cod_tarea ) REFERENCES [ABAN_DER_ADOS].[Tarea](cod_tarea )
				
)
CREATE TABLE [ABAN_DER_ADOS].Estado_OT(
				cod_estado_ot nvarchar(50) NOT NULL,
				descripcion nvarchar(50),
				CONSTRAINT PK_ESTADO PRIMARY KEY(cod_estado_ot)
				
)
CREATE TABLE [ABAN_DER_ADOS].Taller(
				cod_taller int identity(1,1) NOT NULL,
				nombre nvarchar(50),
				cod_ciudad int NOT NULL,
				direccion nvarchar(50),
				telefono int,
				mail nvarchar(255),
				CONSTRAINT PK_TALLER PRIMARY KEY(cod_taller),
				CONSTRAINT FK_cod_ciudad FOREIGN KEY(cod_ciudad) REFERENCES [ABAN_DER_ADOS].[Ciudad](cod_ciudad)
				
)
CREATE TABLE [ABAN_DER_ADOS].Mecanico(
				leg_mecanico int NOT NULL,
				taller int NOT NULL,
				nombre nvarchar(50), 
				apellido nvarchar(50), 
				dni int NOT NULL,
				direccion nvarchar(50),
				mail nvarchar(255),
				fecha_nac DATE,
				telefono int,
				costo_hora int
				CONSTRAINT PK_MECANICO PRIMARY KEY(leg_mecanico),
				CONSTRAINT FK_cod_taller FOREIGN KEY(taller) REFERENCES [ABAN_DER_ADOS].[Taller](cod_taller)
)
CREATE TABLE [ABAN_DER_ADOS].Marca(
				cod_marca int identity(1,1) NOT NULL,
				descripcion nvarchar(50),
				CONSTRAINT PK_MARCA PRIMARY KEY(cod_marca),
				
)
CREATE TABLE [ABAN_DER_ADOS].Modelo_Camion(
				cod_modelo int identity(1,1) NOT NULL,
				descripcion nvarchar(50),
				capacidad_carga int,
				capacidad_tanque int,
				velocidad_max int,
				CONSTRAINT PK_MODELOCAMION PRIMARY KEY(cod_modelo),
)
CREATE TABLE [ABAN_DER_ADOS].Camion(
				patente_camion nvarchar(255) NOT NULL,
				cod_modelo int NOT NULL,
				fecha_alta DATE,
				nro_motor nvarchar(255),
				nro_chasis nvarchar(255),
				cod_marca int,
				CONSTRAINT PK_CAMION PRIMARY KEY(patente_camion),
				CONSTRAINT FK_cod_modelo FOREIGN KEY(cod_modelo) REFERENCES [ABAN_DER_ADOS].[Modelo_Camion](cod_modelo),
				CONSTRAINT FK_cod_marcaCamin FOREIGN KEY(cod_marca) REFERENCES [ABAN_DER_ADOS].[Marca](cod_marca)				
)
CREATE TABLE [ABAN_DER_ADOS].Orden_Trabajo(
				cod_orden_trabajo  int Identity(1,1) NOT NULL,
				fecha datetime2(3),
				camion nvarchar(255) FOREIGN KEY REFERENCES [ABAN_DER_ADOS].[Camion](patente_camion),
				CONSTRAINT PK_OT PRIMARY KEY(cod_orden_trabajo)
)
CREATE TABLE [ABAN_DER_ADOS].Tarea_x_Orden(
				cod_orden_trabajo int Identity(1,1) NOT NULL,
				tarea  int NOT NULL,
				mecanico int,
				duracion_estimada int,
				fecha_inicio DATE,
				fecha_fin DATE,
				duracion_real int,
				CONSTRAINT FK_cod_orden_trabajo FOREIGN KEY(cod_orden_trabajo) REFERENCES [ABAN_DER_ADOS].[Orden_Trabajo](cod_orden_trabajo),
				CONSTRAINT FK_cod_tarea_orden FOREIGN KEY(tarea ) REFERENCES [ABAN_DER_ADOS].[Tarea](cod_tarea),
				CONSTRAINT FK_leg_mecanicoOrden FOREIGN KEY(mecanico) REFERENCES [ABAN_DER_ADOS].[Mecanico](leg_mecanico),
)
CREATE TABLE [ABAN_DER_ADOS].Tipo_Paquete(
				cod_tipo_paquete int identity(1,1)NOT NULL,
				peso_max int,
				alto_max int,
				ancho_max int,
				largo_max int,
				descripcion nvarchar(50),
				precio int,
				CONSTRAINT PK_TIPO_PAQUETE PRIMARY KEY(cod_tipo_paquete)
)
CREATE TABLE [ABAN_DER_ADOS].Paquete(
				cod_paquete int identity(1,1) NOT NULL,
				tipo_Paquete int NOT NULL,
				descripcion nvarchar(50),
				CONSTRAINT PK_PAQUETE PRIMARY KEY(cod_paquete),
				CONSTRAINT FK_Tipo_Paquete FOREIGN KEY(Tipo_Paquete) REFERENCES [ABAN_DER_ADOS].[Tipo_Paquete](cod_tipo_paquete)
)
CREATE TABLE [ABAN_DER_ADOS].Recorrido(
				cod_recorrido int identity(1,1) NOT NULL,
				origen int not null,
				destino int not null,
				cantKm int,
				precio int
				CONSTRAINT PK_cod_recorrido PRIMARY KEY(cod_recorrido),
				CONSTRAINT FK_origen FOREIGN KEY(origen) REFERENCES [ABAN_DER_ADOS].[Ciudad](cod_ciudad), 
				CONSTRAINT FK_destino FOREIGN KEY(destino) REFERENCES [ABAN_DER_ADOS].[Ciudad](cod_ciudad) 
)
CREATE TABLE [ABAN_DER_ADOS].Viaje(
				cod_viaje int identity(1,1) NOT NULL,
				legajo_chofer int,
				patente_camion nvarchar(255),
				cod_recorrido int ,
				fecha_inicio DATE,
				fecha_fin DATE,
				litros_combustible int,
				CONSTRAINT PK_cod_viaje PRIMARY KEY(cod_viaje),
				CONSTRAINT FK_legajoChofer FOREIGN KEY(legajo_chofer) REFERENCES [ABAN_DER_ADOS].[Chofer](leg_chofer), 
				CONSTRAINT FK_patente_camion FOREIGN KEY(patente_camion) REFERENCES [ABAN_DER_ADOS].[Camion](patente_camion), 
				CONSTRAINT FK_cod_recorrido  FOREIGN KEY(cod_recorrido ) REFERENCES [ABAN_DER_ADOS].[Recorrido](cod_recorrido ) 
	
)
CREATE TABLE [ABAN_DER_ADOS].Paquete_X_Viaje(
				cod_paquete int NOT NULL,  --(- ojo preguntar con esto -)
				cod_viaje int NOT NULL, 
				cantidad int,
				CONSTRAINT FK_cod_paquete FOREIGN KEY(cod_paquete) REFERENCES [ABAN_DER_ADOS].[Paquete](cod_paquete) ,
				CONSTRAINT FK_cod_viaje FOREIGN KEY(cod_viaje) REFERENCES [ABAN_DER_ADOS].[Viaje](cod_viaje)
)





