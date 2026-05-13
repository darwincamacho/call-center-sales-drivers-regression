/*
Project: Call Center Sales Drivers Regression Analysis
Script: 01_supervisor_day_campaign_base.sql

Purpose:
Build an analytical dataset aggregated at supervisor-day-campaign level.

This query transforms raw operational call center records into a modeling-ready table,
including sales, call volume, contact metrics, operational time variables and productivity ratios.

Final grain:
FECHA + SUPERVISOR + Campania

Main output:
A supervisor-day-campaign dataset used for regression analysis in Python.
*/

SELECT
	CAST(FECHA AS DATE) AS FECHA,
	SUPERVISOR,
	Campaña,
	COUNT(DISTINCT DNI) AS Q_ASESORES_ACTIVOS,
	SUM(Q_LLA) AS Q_LLA,
	SUM(Q_CET) AS Q_CET,
	SUM(Q_NOC) AS Q_NOC,
	SUM(Q_CTR) AS Q_CTR, 
	SUM(Q_CTNR) AS Q_CTNR,
	SUM(Q_OFERTA) AS Q_OFERTA,
	SUM(Q_ACEPTA) AS Q_ACEPTA,
	SUM(Q_VENTAS) AS Q_VENTAS,
	SUM(T_LOGIN) AS T_LOGIN,
	SUM(T_HABLADO) AS T_HABLADO,
	SUM(T_PAUSA) AS T_PAUSA,
	SUM(T_ESPERA) AS T_ESPERA,
	SUM(T_DISPONIBLE) AS T_DISPONIBLE,
	SUM(T_ACW) AS T_ACW,
	DATENAME(WEEKDAY, FECHA) AS DIA_SEMANA,
	DATEPART(WEEKDAY, FECHA) AS NRO_DIA_SEMANA,
	CASE WHEN DAY(FECHA) <=15 THEN 1 ELSE 0 END AS NRO_QUINCENA,
	CAST(SUM(T_HABLADO) AS FLOAT) / NULLIF(CAST(SUM(T_LOGIN) AS FLOAT), 0) AS Pct_Hablado,
	CAST(SUM(T_PAUSA) AS FLOAT) / NULLIF(CAST(SUM(T_LOGIN) AS FLOAT), 0) AS Pct_Pausa,
	CAST(SUM(T_ACW) AS FLOAT) / NULLIF(CAST(SUM(T_LOGIN) AS FLOAT), 0) AS Pct_ACW,
	CAST(SUM(Q_CET) AS FLOAT) / NULLIF(CAST(SUM(Q_LLA) AS FLOAT), 0) AS Contactabilidad,
	CAST(SUM(Q_NOC) AS FLOAT) / NULLIF(CAST(SUM(Q_LLA) AS FLOAT), 0) AS No_Contacto_Rate,
	CAST(SUM(Q_LLA) AS FLOAT) / NULLIF(CAST(SUM(T_LOGIN) AS FLOAT), 0) AS Llamadas_por_Hora,
	CAST(SUM(Q_CET) AS FLOAT) / NULLIF(CAST(SUM(T_LOGIN) AS FLOAT), 0) AS contactos_por_Hora
FROM ZRP_PRODUCCION_GESTOR_OH_APLAZALOH
WHERE SUPERVISOR <> 'NOMBRE_SUPERVISOR'
GROUP BY CAST(FECHA AS DATE), SUPERVISOR, Campaña, DATENAME(WEEKDAY, FECHA),
	DATEPART(WEEKDAY, FECHA), CASE WHEN DAY(FECHA) <=15 THEN 1 ELSE 0 END



