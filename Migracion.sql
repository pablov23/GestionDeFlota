--MARCA!
INSERT INTO ABAN_DER_ADOS.Marca
(descripcion)
SELECT DISTINCT MARCA_CAMION_MARCA FROM gd_esquema.Maestra

--MODELO CAMION!

INSERT INTO ABAN_DER_ADOS.Modelo_Camion
	(descripcion,capacidad_carga,capacidad_tanque,velocidad_max)
	SELECT distinct 
			MODELO_CAMION,MODELO_CAPACIDAD_CARGA,MODELO_CAPACIDAD_TANQUE,MODELO_VELOCIDAD_MAX 
		FROM gd_esquema.Maestra 



--CAMION!

INSERT INTO ABAN_DER_ADOS.Camion
	(fecha_alta,nro_motor,nro_chasis,patente_camion,cod_modelo,cod_marca)

SELECT DISTINCT 
	m.CAMION_FECHA_ALTA,m.CAMION_NRO_MOTOR,m.CAMION_NRO_CHASIS,m.CAMION_PATENTE,mc.cod_modelo,ma.cod_marca
		FROM gd_esquema.Maestra m 
			JOIN ABAN_DER_ADOS.Modelo_Camion mc 
				on (mc.descripcion = m.MODELO_CAMION and 
					mc.capacidad_carga = m.MODELO_CAPACIDAD_CARGA and 
					mc.velocidad_max= m.MODELO_VELOCIDAD_MAX and 
					mc.capacidad_tanque = m.MODELO_CAPACIDAD_TANQUE
					)
			JOIN ABAN_DER_ADOS.Marca ma
				on(ma.descripcion = m.MARCA_CAMION_MARCA)


				

