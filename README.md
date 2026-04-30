🌍 Happiness & Corruption Analysis (2015–2019)

📊 Executive Summary

Este proyecto analiza la relación entre la percepción de corrupción y los niveles de felicidad a nivel global utilizando datos del World Happiness Report (2015–2019).

A través de un pipeline completo de análisis de datos —que incluye limpieza de datos, modelado en SQL, consultas analíticas y análisis exploratorio (EDA) en Python— se identificaron patrones globales y regionales en los niveles de bienestar.

Los resultados muestran que los países con menor corrupción percibida tienden a presentar mayores niveles de felicidad, aunque variables como PIB per cápita, apoyo social y esperanza de vida presentan una relación aún más fuerte con el bienestar.

Esto sugiere que la felicidad es un fenómeno multidimensional influido por factores económicos, sociales e institucionales.

📑 Table of Contents
Visualización principal
Objetivo del proyecto
Dataset
Proceso de análisis
Resultados / Insights
Próximos pasos
Cómo replicar el análisis
Tecnologías utilizadas
Estructura del proyecto
Resumen simple


📈 Visualización principal del proyecto

Relación entre corrupción percibida y felicidad

Este gráfico muestra una tendencia negativa entre ambas variables: a mayor corrupción percibida, menores niveles de felicidad promedio.

(Inserta aquí el scatter plot generado en el notebook)

🎯 Objetivo del proyecto

El objetivo de este proyecto es analizar si existe una relación entre la percepción de corrupción y los niveles de felicidad de los países.

Las preguntas principales del análisis son:

¿Los países con mayor corrupción percibida presentan menores niveles de felicidad?
¿Qué otros factores explican las diferencias en bienestar entre países?
¿Cómo varían estos patrones entre distintas regiones del mundo?

Este análisis busca comprender mejor los factores estructurales asociados al bienestar social.

🗂 Dataset

El análisis utiliza datos del:

World Happiness Report

Este dataset contiene indicadores socioeconómicos utilizados para explicar los niveles de felicidad reportados por los países.

Variables principales
happiness_score → nivel de felicidad reportado
gdp_per_capita → desarrollo económico
social_support → apoyo social
life_expectancy → esperanza de vida
freedom → libertad para tomar decisiones
institutional_trust → confianza institucional
perceived_corruption → percepción de corrupción
region → región geográfica del país

Periodo analizado:

2015 – 2019

⚙️ Proceso de análisis

El proyecto sigue un pipeline completo de análisis de datos:

1️⃣ Exploración inicial
inspección del dataset
análisis de estructura
identificación de inconsistencias
2️⃣ Limpieza de datos
tratamiento de valores nulos
eliminación de duplicados
normalización de columnas
3️⃣ Transformación de variables
creación de perceived_corruption
estructuración en tablas relacionales
4️⃣ Modelado de base de datos

Se diseñó una base de datos con tres tablas:

countries
happiness_indicators
corruption_indicators
5️⃣ Análisis SQL

Se utilizaron consultas analíticas con:

JOIN
GROUP BY
AVG
CASE
HAVING
subqueries
6️⃣ Análisis exploratorio (EDA)

Visualizaciones utilizadas:

scatter plots
matriz de correlación
boxplots por región
rankings de países
🔎 Resultados / Insights

El análisis permitió identificar varios patrones relevantes:

1️⃣ Relación corrupción–felicidad

Existe una relación negativa entre corrupción percibida y felicidad.

2️⃣ Factores más asociados a la felicidad

Las variables con mayor correlación con la felicidad son:

PIB per cápita
apoyo social
esperanza de vida
3️⃣ Diferencias regionales

Las regiones con mayor felicidad promedio son:

Western Europe
North America
Australia & New Zealand

Las regiones con menor felicidad incluyen:

Sub-Saharan Africa
Southern Asia
4️⃣ La felicidad es multidimensional

Aunque la corrupción influye en el bienestar, no es el único factor explicativo. Variables económicas y sociales desempeñan un papel clave.

🚀 Próximos pasos

Posibles extensiones del proyecto:

incluir más años del World Happiness Report
aplicar modelos estadísticos para análisis causal
incorporar variables institucionales adicionales
analizar desigualdad y distribución del bienestar
crear dashboards interactivos
🔁 Cómo replicar el análisis

Este proyecto es completamente reproducible.

Pasos para replicar

1️⃣ Obtener el dataset del World Happiness Report
2️⃣ Ejecutar el pipeline de limpieza en Python
3️⃣ Crear la base de datos en MySQL
4️⃣ Ejecutar las consultas SQL
5️⃣ Ejecutar el notebook de análisis para generar visualizaciones

Una replicación completa implicaría aplicar la misma metodología a nuevos datos para verificar si los patrones identificados se mantienen.

🛠 Tecnologías utilizadas
Python
Pandas
NumPy
Matplotlib
Seaborn
SQL
MySQL
Jupyter Notebook
📁 Estructura del proyecto
happiness-corruption-analysis
│
├── data
│   ├── raw
│   └── clean
│
├── notebooks
│   ├── 01_data_cleaning.ipynb
│   └── 03_analysis_report.ipynb
│
├── sql
│   ├── schema.sql
│   └── queries.sql
│
├── src
│
└── README.md
📌 Resumen simple

Este README responde a cinco preguntas clave:

Qué hiciste
Analicé la relación entre corrupción percibida y felicidad a nivel global.

Con qué datos
Datos del World Happiness Report (2015–2019).

Qué proceso seguiste
Limpieza de datos → modelado SQL → consultas analíticas → visualización en Python.

Qué descubriste
La corrupción influye en la felicidad, pero factores como el desarrollo económico y el apoyo social tienen un impacto aún mayor.

Cómo reproducirlo
Ejecutando el pipeline completo de Python y SQL incluido en este repositorio.
