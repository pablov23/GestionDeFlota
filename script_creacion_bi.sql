USE [GD2C2021]
GO

/************************************/
/*			Funciones				*/
/************************************/
/*Nombre: RangoEdad*/
/*Parametro: fecha (DATE)*/
/*Retorno: VARCHAR*/
/*DESC: En base a una fecha, calcula la edad a fecha actual y devuelve un string en base a la edad*/
CREATE function RangoEdad(@fecha date) returns VARCHAR(20) as 
begin
declare @rango integer
declare @retorno VARCHAR(20)
set @rango= YEAR(GETDATE())-Year(@fecha)
set @retorno= case when @rango between 18 and 30 then '18-30 años'
                   when @rango between 31 and 50 then '31-50 años'
				   else '>50 años'
                   end 
return @retorno
end
GO


/************************************/
/*			SCHEMA  BI				*/
/************************************/
CREATE TABLE ABAN_DER_ADOS.bi_fecha
(
	fecha_id INTEGER IDENTITY(1,1) PRIMARY KEY,
	cuatrimestre integer,
	anio integer
)

CREATE TABLE ABAN_DER_ADOS.BI_Camion
(
	camion_codigo INTEGER IDENTITY(1,1) PRIMARY KEY,
	camion_patente varchar(50),
	camion_fecha_alta date,
	camion_nro_motor varchar(50),
	camion_nro_chasis varchar(50)
)

CREATE TABLE ABAN_DER_ADOS.BI_marca
(
	marca_codigo INTEGER IDENTITY(1,1) PRIMARY KEY,
	marca_descripcion varchar(50)
)

CREATE TABLE ABAN_DER_ADOS.BI_modelo
(
	modelo_codigo INTEGER IDENTITY(1,1) PRIMARY KEY,
	modelo_descripcion varchar(50),
	modelo_capacidad_carga int CHECK (modelo_capacidad_carga>0),
	modelo_capacidad_tanque int CHECK (modelo_capacidad_tanque>0),
	modelo_velocidad_maxima int CHECK (modelo_velocidad_maxima>0)
)

CREATE TABLE ABAN_DER_ADOS.BI_taller
(
	taller_codigo INTEGER IDENTITY(1,1) PRIMARY KEY,
	taller_nombre varchar(50),
	taller_direccion varchar(50),
	taller_ciudad varchar(50),
	taller_telefono int,
	taller_mail varchar(50)
)

CREATE TABLE ABAN_DER_ADOS.BI_tipo_tarea
(
	tipo_tarea_codigo INTEGER IDENTITY(1,1) PRIMARY KEY,
	tipo_tarea_nombre varchar(50)
)

CREATE TABLE ABAN_DER_ADOS.BI_recorrido
(
	recorrido_codigo INTEGER IDENTITY(1,1) PRIMARY KEY,
	recorrido_origen varchar(50) ,
	recorrido_destino varchar(50) ,
	recorrido_km int CHECK(recorrido_km >0),
	recorrido_precio decimal(10,2),
	CONSTRAINT no_idem CHECK(recorrido_origen <>recorrido_destino)
)



CREATE TABLE ABAN_DER_ADOS.BI_chofer
(
	chofer_legajo VARCHAR(50) PRIMARY KEY,
	chofer_nombre varchar(50),
	chofer_apellido varchar(50),
	chofer_dni int,
	chofer_direccion varchar(50),
	chofer_mail varchar(50),
	chofer_telefono varchar(50),
	chofer_fecha_nacimiento date,
	chofer_rango_edad varchar(50),
	chofer_costo_hora decimal(10,2)
)

CREATE TABLE ABAN_DER_ADOS.BI_mecanico
(
	mecanico_legajo VARCHAR(50) PRIMARY KEY,
	mecanico_nombre varchar(50),
	mecanico_apellido varchar(50),
	mecanico_dni int,
	mecanico_direccion varchar(50),
	mecanico_mail varchar(50),
	mecanico_telefono varchar(50),
	mecanico_fecha_nacimiento date,
	mecanico_rango_edad varchar(50),
	mecanico_costo_hora decimal(10,2)
)

CREATE TABLE ABAN_DER_ADOS.BI_material
(
	material_codigo VARCHAR(50) PRIMARY KEY,
	material_descripcion varchar(50),
	material_precio decimal(10,2) CHECK(material_precio >0)
)

CREATE TABLE ABAN_DER_ADOS.BI_tarea
(
		tarea_codigo nvarchar(50) PRIMARY KEY NOT NULL,
		tarea_descripcion nvarchar(50),
		tarea_tiempo int
)

CREATE TABLE ABAN_DER_ADOS.BI_orden
(
		orden_codigo int PRIMARY KEY NOT NULL,
		orden_fecha date,
)

CREATE TABLE ABAN_DER_ADOS.BI_paquete
(
				paquete_codigo int Identity(1,1) PRIMARY KEY NOT NULL ,
				paquete_peso_max int,
				paquete_alto_max int,
				paquete_ancho_max int,
				paquete_largo_max int,
				paquete_descripcion nvarchar(50),
				paquete_precio int
)

/************************************/
/*				CARGA				*/
/************************************/
INSERT INTO ABAN_DER_ADOS.bi_fecha
(anio,cuatrimestre)
SELECT DISTINCT YEAR(viaje_fecha_inicio),DATEPART(QUARTER,viaje_fecha_inicio) FROM ABAN_DER_ADOS.Viaje
UNION
SELECT DISTINCT YEAR(viaje_fecha_fin),DATEPART(QUARTER,viaje_fecha_fin) FROM ABAN_DER_ADOS.Viaje
UNION
SELECT DISTINCT YEAR(orden_fecha),DATEPART(QUARTER,orden_fecha) FROM ABAN_DER_ADOS.OrdenTrabajo

INSERT INTO ABAN_DER_ADOS.BI_Camion
(camion_fecha_alta,camion_nro_chasis,camion_nro_motor,camion_patente)
SELECT camion_fecha_alta,camion_nro_chasis,camion_nro_motor,camion_patente FROM ABAN_DER_ADOS.Camion

INSERT INTO ABAN_DER_ADOS.BI_marca
(marca_descripcion)
SELECT marca_descripcion FROM ABAN_DER_ADOS.Marca

INSERT INTO ABAN_DER_ADOS.BI_modelo
(
	modelo_descripcion,
	modelo_capacidad_carga,
	modelo_capacidad_tanque,
	modelo_velocidad_maxima
)
SELECT modelo_descripcion,modelo_capacidad_carga,modelo_capidad_tanque,modelo_velocidad_maxima FROM ABAN_DER_ADOS.ModeloCamion


INSERT INTO ABAN_DER_ADOS.BI_Taller
(taller_direccion,taller_mail,taller_nombre,taller_telefono,taller_ciudad)
SELECT taller_direccion,taller_mail,taller_nombre,taller_telefono,c.ciudad_nombre FROM ABAN_DER_ADOS.Taller
JOIN ABAN_DER_ADOS.Ciudad c ON c.ciudad_codigo = taller_ciudad

INSERT INTO ABAN_DER_ADOS.BI_tipo_tarea
(tipo_tarea_nombre)
SELECT tipo_tarea_descripcion FROM ABAN_DER_ADOS.TipoTarea


INSERT INTO ABAN_DER_ADOS.BI_recorrido
(recorrido_origen,recorrido_destino,recorrido_km,recorrido_precio)
SELECT c1.ciudad_nombre,c2.ciudad_nombre,recorrido_kilometros,recorrido_precio FROM ABAN_DER_ADOS.Recorrido
JOIN ABAN_DER_ADOS.Ciudad c1 on recorrido_origen = c1.ciudad_codigo
JOIN ABAN_DER_ADOS.Ciudad c2 on recorrido_destino = c2.ciudad_codigo

INSERT INTO ABAN_DER_ADOS.BI_chofer
(
	chofer_legajo,
	chofer_nombre,
	chofer_apellido,
	chofer_dni,
	chofer_direccion,
	chofer_mail,
	chofer_telefono,
	chofer_fecha_nacimiento,
	chofer_rango_edad,
	chofer_costo_hora
)
SELECT 
	chof_legajo,
	chof_nombre,
	chof_apellido,
	chof_dni,
	chof_direccion,
	chof_mail,
	chof_telefono,
	chof_fecha_nacimiento,
	dbo.RangoEdad(chof_fecha_nacimiento),
	chof_costo_hora FROM ABAN_DER_ADOS.Chofer

INSERT INTO ABAN_DER_ADOS.BI_mecanico
(
	mecanico_legajo,
	mecanico_nombre,
	mecanico_apellido,
	mecanico_dni,
	mecanico_direccion,
	mecanico_mail,
	mecanico_telefono,
	mecanico_fecha_nacimiento,
	mecanico_rango_edad,
	mecanico_costo_hora
)
SELECT 
	mecanico_legajo,
	mecanico_nombre,
	mecanico_apellido,
	mecanico_dni,
	mecanico_direccion,
	mecanico_mail,
	mecanico_telefono,
	mecanico_fecha_nacimiento,
	dbo.RangoEdad(mecanico_fecha_nacimiento),
	mecanico_costo FROM ABAN_DER_ADOS.Mecanico
	
INSERT INTO ABAN_DER_ADOS.BI_material
(material_codigo,material_descripcion,material_precio)
SELECT material_codigo,material_descripcion,material_precio FROM ABAN_DER_ADOS.Material


INSERT INTO ABAN_DER_ADOS.BI_tarea
(
		tarea_codigo,
		tarea_descripcion,
		tarea_tiempo
)
SELECT tarea_codigo,tarea_descripcion,tarea_tiempo FROM ABAN_DER_ADOS.Tarea

INSERT INTO ABAN_DER_ADOS.BI_orden
(
		orden_codigo,
		orden_fecha
)
SELECT orden_codigo,orden_fecha FROM ABAN_DER_ADOS.OrdenTrabajo

INSERT INTO ABAN_DER_ADOS.BI_paquete(
				paquete_peso_max ,
				paquete_alto_max ,
				paquete_ancho_max ,
				paquete_largo_max ,
				paquete_descripcion ,
				paquete_precio
)
SELECT tipo_paquete_peso_max,tipo_paquete_alto_max,tipo_paquete_ancho_max,tipo_paquete_largo_max,tipo_paquete_descripcion,tipo_paquete_precio FROM ABAN_DER_ADOS.TipoPaquete


/************************************/
/*			Tabla de HECHO			*/
/************************************/

/************************************/
/*			HECHO Orden Tarea		*/
/************************************/
CREATE TABLE ABAN_DER_ADOS.BI_HECHO_OT
(
	hecho_id Integer Identity(1,1) Primary Key,
	ot_codigo Integer FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_orden,
	ot_mecanico VARCHAR(50) FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_mecanico,
	ot_camion int FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_camion,
	ot_fecha int FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_fecha,
	ot_taller int FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_taller,
	ot_tipo_tarea int FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_tipo_tarea,
	ot_tarea nvarchar(50) FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_tarea,
	ot_marca int FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_marca,
	ot_modelo int FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_modelo,
	ot_material VARCHAR(50) FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_material,
	ot_cantidad_material int,
	ot_tarea_duracion int,
	ot_fecha_planificada date,
	ot_fecha_inicio date,
	ot_fecha_fin date
	
)



INSERT INTO ABAN_DER_ADOS.BI_HECHO_OT
(ot_codigo,ot_mecanico,ot_camion,ot_fecha,ot_tipo_tarea,ot_marca,ot_modelo,ot_taller,ot_tarea_duracion,ot_material,ot_cantidad_material,ot_fecha_planificada,
	ot_fecha_inicio,
	ot_fecha_fin,ot_tarea)
SELECT  DISTINCT
	ot.orden_codigo
	,txo.tarea_x_orden_mecanico
	,ot.orden_camion
	,f.fecha_id
	,tar.tarea_tipo
	,c.camion_marca
	,c.camion_modelo
	,mec.mecanico_taller
	,txo.tarea_x_orden_duracion_real
	,mt.material_codigo
	,mxt.cantidad
	,txo.tarea_x_orden_fecha_inicio_planificada
	,txo.tarea_x_orden_fecha_inicio
	,txo.tarea_x_orden_fecha_fin
	,tarea_codigo
FROM ABAN_DER_ADOS.OrdenTrabajo ot
JOIN ABAN_DER_ADOS.TareaxOrden txo
	on txo.tarea_x_orden_ot= ot.orden_codigo
JOIN ABAN_DER_ADOS.Tarea tar
	on tar.tarea_codigo = txo.tarea_x_orden_tarea
JOIN ABAN_DER_ADOS.bi_fecha f
	on f.anio = YEAR(ot.orden_fecha) and f.cuatrimestre = DATEPART(QUARTER,ot.orden_fecha)
JOIN ABAN_DER_ADOS.Camion c
	on c.camion_codigo = ot.orden_camion
JOIN ABAN_DER_ADOS.Mecanico mec
	on mec.mecanico_legajo = txo.tarea_x_orden_mecanico
JOIN ABAN_DER_ADOS.MaterialxTarea mxt
	on mxt.tarea_x_orden = txo.tarea_x_orden_codigo
JOIN ABAN_DER_ADOS.Material mt
	on mxt.material_codigo = mt.material_codigo

/************************************/
/*			HECHO VIAJE				*/
/************************************/
CREATE TABLE ABAN_DER_ADOS.BI_HECHO_VIAJE
(
	hecho_id Integer Identity(1,1) Primary Key,
	viaje_recorrido Integer FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_recorrido,
	viaje_chofer VARCHAR(50) FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_chofer,
	viaje_camion int FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_camion,
	viaje_fecha int FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_fecha,
	viaje_marca int FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_marca,
	viaje_modelo int FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_modelo,
	viaje_paquete int FOREIGN KEY REFERENCES ABAN_DER_ADOS.BI_paquete,
	viaje_cantidad_paquete int,
	viaje_combustible int,
	viaje_duracion int,
	viaje_subtotal_paquete DECIMAL(10,2),
	viaje_subtotal_recorrido DECIMAL(10,2)
	
)
INSERT INTO ABAN_DER_ADOS.BI_HECHO_VIAJE
(	viaje_recorrido ,
	viaje_chofer ,
	viaje_camion ,
	viaje_fecha ,
	viaje_marca ,
	viaje_modelo,
	viaje_paquete ,
	viaje_cantidad_paquete ,
	viaje_duracion,
	viaje_combustible,
	viaje_subtotal_paquete,
	viaje_subtotal_recorrido
	)
SELECT v.viaje_recorrido,v.viaje_chofer,v.viaje_camion,f.fecha_id,c.camion_marca,c.camion_modelo,pv.paquete_codigo,pv.paquete_cantidad,DATEDIFF(DAY,v.viaje_fecha_inicio,v.viaje_fecha_fin),v.viaje_litros_combustible,p.tipo_paquete_precio*pv.paquete_cantidad,r.recorrido_precio*pv.paquete_cantidad
  FROM ABAN_DER_ADOS.Viaje v
JOIN ABAN_DER_ADOS.Recorrido r
	ON v.viaje_recorrido = r.recorrido_codigo
JOIN ABAN_DER_ADOS.bi_fecha f
	on f.anio = YEAR(v.viaje_fecha_inicio) and f.cuatrimestre = DATEPART(QUARTER,v.viaje_fecha_inicio) --AMBIGUO ACLARARLO EN ESTRATEGIA ¿Fecha inicio o fin?
JOIN ABAN_DER_ADOS.Camion c
	ON v.viaje_camion = c.camion_codigo
JOIN ABAN_DER_ADOS.PaquetexViaje pv
	ON pv.paquete_viaje = v.viaje_codigo
JOIN ABAN_DER_ADOS.TipoPaquete p
	ON p.tipo_paquete_codigo = pv.paquete_codigo

GO
/************************************/
/*				VIEW				*/
/************************************/

/*
Máximo tiempo fuera de servicio de cada camión por cuatrimestre 
Se entiende por fuera de servicio cuando el camión está en el taller (tiene 
una OT) y no se encuentra disponible para un viaje. 
*/
CREATE VIEW V_maximo_tiempo_fuera_de_servicio
AS
SELECT 
	f.anio 'Anio'
	,f.cuatrimestre 'Cuatrimestre'
	,c.camion_patente 'Camion'
	,max(ot.ot_tarea_duracion) 'Maxima cantidad de dias fuera de servicio' 
FROM ABAN_DER_ADOS.BI_HECHO_OT ot
JOIN ABAN_DER_ADOS.bi_fecha f
	ON f.fecha_id = ot.ot_fecha
JOIN ABAN_DER_ADOS.BI_Camion c
	ON c.camion_codigo = ot.ot_camion
GROUP BY f.anio,f.cuatrimestre,c.camion_patente
GO

/*
Costo total de mantenimiento por camión, por taller, por cuatrimestre. 
Se entiende por costo de mantenimiento el costo de materiales + el costo 
de mano de obra insumido en cada tarea (correctivas y preventivas) 

COSTO MATERIALES = costoMaterial*Cantidad
COSTO Mano OBRA = costoHora*Jornada*Dias

*/
CREATE VIEW V_costo_mantenimiento
AS
SELECT  
	c.camion_patente 'CAMION'
	,t.taller_nombre 'TALLER'
	,f.anio 'ANIO'
	,f.cuatrimestre 'CUATRIMESTRE'
	,tt.tipo_tarea_nombre 'TIPO TAREA'
	,sum(mec.mecanico_costo_hora*8*hot.ot_tarea_duracion)+sum(material_precio*hot.ot_cantidad_material) 'COSTO' FROM ABAN_DER_ADOS.BI_HECHO_OT hot
JOIN ABAN_DER_ADOS.BI_Camion c
	ON c.camion_codigo = hot.ot_camion
JOIN ABAN_DER_ADOS.BI_taller t
	ON t.taller_codigo= hot.ot_taller
JOIN ABAN_DER_ADOS.bi_fecha f
	ON hot.ot_fecha = f.fecha_id
JOIN ABAN_DER_ADOS.BI_tipo_tarea tt
	ON hot.ot_tipo_tarea = tt.tipo_tarea_codigo
JOIN ABAN_DER_ADOS.BI_mecanico mec
	ON mec.mecanico_legajo = hot.ot_mecanico
JOIN ABAN_DER_ADOS.BI_material mt
	ON mt.material_codigo= hot.ot_material
GROUP BY c.camion_patente,t.taller_nombre,f.anio,f.cuatrimestre,tt.tipo_tarea_nombre
GO


/*
Desvío promedio de cada tarea x taller. 
*/
CREATE VIEW V_desvio_promedio
AS
SELECT 
	SUM(DATEDIFF(DAY,ot.ot_fecha_planificada,ot.ot_fecha_inicio))/COUNT(ot_codigo)'desvio'
	,t.taller_nombre 'TALLER'
FROM ABAN_DER_ADOS.BI_HECHO_OT ot
JOIN ABAN_DER_ADOS.BI_taller t
	ON t.taller_codigo = ot.ot_taller
GROUP BY ot.ot_codigo,t.taller_nombre
GO

/*
Las 5 tareas que más se realizan por modelo de camión.
*/
CREATE VIEW V_cinco_tareas_mas_realizadas_x_modelo
AS
SELECT DISTINCT m.modelo_codigo,m.modelo_descripcion,t.tarea_descripcion fROM ABAN_DER_ADOS.BI_HECHO_OT ot
JOIN ABAN_DER_ADOS.Tarea t
	ON t.tarea_codigo = ot.ot_tarea
JOIN ABAN_DER_ADOS.ModeloCamion m
	ON m.modelo_codigo = ot.ot_modelo
WHERE t.tarea_codigo  IN (
		SELECT TOP 5 t2.tarea_codigo fROM ABAN_DER_ADOS.BI_HECHO_OT ot2
	JOIN ABAN_DER_ADOS.BI_tarea t2
		ON t2.tarea_codigo = ot2.ot_tarea
	JOIN ABAN_DER_ADOS.BI_modelo m2
		ON m2.modelo_codigo = ot2.ot_modelo
	WHERE m2.modelo_codigo = m.modelo_codigo
	GROUP BY t2.tarea_codigo,m2.modelo_descripcion
	ORDER BY COUNT(t2.tarea_descripcion) DESC
)
GO		
		



/*
Los 10 materiales más utilizados por taller
*/
CREATE VIEW V_diez_materiales_mas_utilizados_x_taller
AS
SELECT DISTINCT t.taller_nombre,m.material_descripcion FROM ABAN_DER_ADOS.BI_HECHO_OT ot
JOIN ABAN_DER_ADOS.BI_taller t
	ON ot.ot_taller = t.taller_codigo
JOIN ABAN_DER_ADOS.BI_material m
	ON m.material_codigo = ot.ot_material
WHERE m.material_codigo IN(
	SELECT TOP 10 m2.material_codigo FROM ABAN_DER_ADOS.BI_HECHO_OT ot2
	JOIN ABAN_DER_ADOS.BI_taller t2
		ON t2.taller_codigo = ot2.ot_codigo
	JOIN ABAN_DER_ADOS.BI_material m2
		ON m2.material_codigo = ot2.ot_material
	WHERE t2.taller_codigo=t.taller_codigo
	GROUP BY t2.taller_nombre,m2.material_codigo
	ORDER BY SUM(ot2.ot_cantidad_material) DESC
)
GO
/*
Facturación total por recorrido por cuatrimestre. (En función de la cantidad 
y tipo de paquetes que transporta el camión y el recorrido)

Precio del recorrido. El precio del recorrido es utilizado como base 
para calcular cuánto se cobra el transporte de un paquete. 
*/

CREATE VIEW V_facturacion_total
AS
SELECT 
	r.recorrido_origen 'origen'
	,r.recorrido_destino 'destino'
	,f.anio 'anio'
	,f.cuatrimestre 'cuatrimestre'
	,SUM(hv.viaje_subtotal_recorrido+hv.viaje_subtotal_paquete) 'precio facturacion'
FROM ABAN_DER_ADOS.BI_HECHO_VIAJE hv
JOIN ABAN_DER_ADOS.BI_recorrido r
	ON r.recorrido_codigo = hv.viaje_recorrido
JOIN ABAN_DER_ADOS.bi_fecha f
	ON f.fecha_id = hv.viaje_fecha
JOIN ABAN_DER_ADOS.BI_paquete p
	ON p.paquete_codigo = hv.viaje_paquete
GROUP BY  r.recorrido_origen,r.recorrido_destino,f.anio,f.cuatrimestre
GO




/*
Costo promedio x rango etario de choferes. 
*/
CREATE VIEW V_costo_promedio_choferes
AS
SELECT DISTINCT 
	ch.chofer_rango_edad 'Rango etario'
	,AVG(ch.chofer_costo_hora*8*hv.viaje_duracion)  'costo promedio'
FROM ABAN_DER_ADOS.BI_HECHO_VIAJE hv
JOIN ABAN_DER_ADOS.BI_chofer ch
	ON ch.chofer_legajo = hv.viaje_chofer
GROUP BY ch.chofer_rango_edad
GO
/*
 Ganancia por camión (Ingresos – Costo de viaje – Costo de mantenimiento) 
o Ingresos: en función de la cantidad y tipo de paquetes que 
transporta el camión y el recorrido. 
o Costo de viaje: costo del chofer + el costo de combustible. 
Tomar precio por lt de combustible $100.- 
o Costo de mantenimiento: costo de materiales + costo de mano de 
obra.
*/
CREATE VIEW V_ganancia_x_camion
AS
SELECT DISTINCT
c.camion_patente 'Camion ' 
,
(
--FACTURACION
SELECT 
	SUM(hv.viaje_subtotal_paquete)+SUM(hv.viaje_subtotal_recorrido) 
	-
	SUM(c.chofer_costo_hora*8*hv.viaje_duracion)+sum(hv.viaje_combustible*100)
FROM ABAN_DER_ADOS.BI_HECHO_VIAJE hv
JOIN ABAN_DER_ADOS.BI_chofer c
	ON c.chofer_legajo = hv.viaje_chofer
WHERE hv.viaje_camion = hv2.viaje_camion
)
-
(
--COSTO de mantenimiento
SELECT 
	SUM(m.material_precio*ot.ot_cantidad_material)+SUM(mec.mecanico_costo_hora*8*ot.ot_tarea_duracion) 
FROM ABAN_DER_ADOS.BI_HECHO_OT ot
JOIN ABAN_DER_ADOS.BI_material m
	ON m.material_codigo = ot.ot_material
JOIN ABAN_DER_ADOS.BI_mecanico mec
	ON mec.mecanico_legajo= ot.ot_mecanico
WHERE ot.ot_camion = hv2.viaje_camion
)'ganancia'

FROM ABAN_DER_ADOS.BI_HECHO_VIAJE hv2
JOIN ABAN_DER_ADOS.BI_Camion c
	ON c.camion_codigo = hv2.viaje_camion













