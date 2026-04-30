-- ==================================================
-- PROYECTO: Corrupción y Felicidad Mundial (2015-2019)
-- Archivo: 02_sql_queries.sql
-- Descripción: Consultas analíticas sobre el World Happiness Report
-- Base de datos: happiness_db
-- Tablas: countries, happiness_indicators, corruption_indicators
-- ==================================================
CREATE DATABASE IF NOT EXISTS happiness_db;
USE happiness_db;

CREATE TABLE IF NOT EXISTS countries (
    country_id INT PRIMARY KEY,
    country    VARCHAR(100) NOT NULL,
    region     VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS happiness_indicators (
    happiness_id    INT PRIMARY KEY,
    country_id      INT,
    year            INT,
    happiness_rank  INT,
    happiness_score FLOAT,
    gdp_per_capita  FLOAT,
    social_support  FLOAT,
    life_expectancy FLOAT,
    freedom         FLOAT,
    generosity      FLOAT,
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

CREATE TABLE IF NOT EXISTS corruption_indicators (
    corruption_id        INT PRIMARY KEY,
    happiness_id         INT,
    institutional_trust  FLOAT,
    perceived_corruption FLOAT,
    FOREIGN KEY (happiness_id) REFERENCES happiness_indicators(happiness_id)
);

-- ==================================================
-- VERIFICACIÓN INICIAL DE DATOS
-- ==================================================

-- Comprobamos que las tablas tienen datos cargados correctamente
SELECT COUNT(*) AS total_paises     FROM countries;
SELECT COUNT(*) AS total_registros  FROM happiness_indicators;
SELECT COUNT(*) AS total_corruption FROM corruption_indicators;

-- Vista previa de cada tabla
SELECT * FROM countries            LIMIT 5;
SELECT * FROM happiness_indicators LIMIT 5;
SELECT * FROM corruption_indicators LIMIT 5;


-- ==================================================
-- PREGUNTA 1: ¿Cuál es el ranking promedio de felicidad por región?
-- Concepto: JOIN + GROUP BY + AVG + ORDER BY
-- ==================================================

-- Primero exploramos qué regiones tenemos disponibles
SELECT DISTINCT region FROM countries ORDER BY region;

-- Ahora calculamos la felicidad media por región en todos los años
-- Unimos countries con happiness_indicators a través de country_id
SELECT
    c.region,
    ROUND(AVG(h.happiness_score), 3) AS avg_happiness,
    ROUND(AVG(h.gdp_per_capita),  3) AS avg_gdp,
    ROUND(AVG(h.life_expectancy), 3) AS avg_life_expectancy,
    COUNT(DISTINCT c.country_id)     AS num_paises
FROM happiness_indicators h
JOIN countries c ON h.country_id = c.country_id
GROUP BY c.region
ORDER BY avg_happiness DESC;

-- Conclusión: Western Europe y North America/ANZ lideran consistentemente.
-- Sub-Saharan Africa y Southern Asia tienen los niveles más bajos.
-------------------------------------------------------------------
Antes de continuar con Q2, hay que arreglar "Unknown". Porque 164 registros en happiness_indicators tienen un country_id que no matchea con ningún país
en countries, o que en countries esos países tienen region = NULL o vacío. Procedemos a limpiar.
-------------------------------------------------------------------
-- ¿Cuántos países tienen region NULL o vacía?
SELECT COUNT(*) FROM countries 
WHERE region IS NULL OR region = '' OR region = 'Unknown';

-- ¿Qué países son?
SELECT country_id, country, region FROM countries 
WHERE region IS NULL OR region = '' OR region = 'Unknown'
LIMIT 20;


-- ==================================================
-- PREGUNTA 2: ¿Qué países tienen mayor percepción de corrupción?
-- Concepto: JOIN (3 tablas) + GROUP BY + AVG + ORDER BY + LIMIT
-- ==================================================

-- Calculamos la corrupción percibida media por país (promedio 2015-2019)
-- Necesitamos unir las 3 tablas: corruption_indicators -> happiness_indicators -> countries
SELECT
    c.country,
    c.region,
    ROUND(AVG(ci.perceived_corruption),  3) AS avg_corruption,
    ROUND(AVG(ci.institutional_trust),   3) AS avg_trust,
    COUNT(h.year)                            AS años_disponibles
FROM corruption_indicators ci
JOIN happiness_indicators h ON ci.happiness_id = h.happiness_id
JOIN countries c             ON h.country_id   = c.country_id
WHERE c.region != 'Unknown'
GROUP BY c.country, c.region
ORDER BY avg_corruption DESC
LIMIT 15;

-- Conclusión: Los países con mayor percepción de corrupción suelen tener
-- menor confianza institucional. Observamos patrones regionales claros.
-- Hallazgos Q2:
-- Bosnia, Indonesia, Bulgaria, Romania — top corrupción percibida (>0.99)
-- Central and Eastern Europe domina el top 15
-- avg_trust es casi 0 en todos — correlación directa: más corrupción = menos confianza institucional

-- ==================================================
-- PREGUNTA 3: ¿La corrupción afecta la felicidad? Clasificación por nivel
-- Concepto: JOIN + CASE + GROUP BY + AVG + ORDER BY
-- ==================================================

-- Clasificamos cada registro según su nivel de corrupción percibida
-- y calculamos la felicidad media de cada categoría
SELECT
    CASE
        WHEN ci.perceived_corruption >= 0.75 THEN 'Alta corrupción (≥0.75)'
        WHEN ci.perceived_corruption >= 0.50 THEN 'Corrupción media (0.50-0.74)'
        WHEN ci.perceived_corruption >= 0.25 THEN 'Corrupción baja (0.25-0.49)'
        ELSE                                      'Muy baja corrupción (<0.25)'
    END AS nivel_corrupcion,
    COUNT(*)                                   AS num_registros,
    ROUND(AVG(h.happiness_score), 3)           AS avg_felicidad,
    ROUND(AVG(h.gdp_per_capita),  3)           AS avg_gdp,
    ROUND(AVG(h.life_expectancy), 3)           AS avg_esperanza_vida
FROM corruption_indicators ci
JOIN happiness_indicators h ON ci.happiness_id = h.happiness_id
GROUP BY nivel_corrupcion
ORDER BY avg_felicidad DESC;

-- Conclusión: Los países con menor corrupción son consistentemente
-- más felices, con mejor PIB y mayor esperanza de vida.
-- Hallazgos Q4 (evolución temporal):
-- Australia/NZ y North America estables y altos todo el período
-- Sub-Saharan Africa consistentemente baja
-- Los "Unknown" aparecen solo en 2017-2019 — confirma que son los datos sin región
-- Hallazgos Q3 (CASE por nivel corrupción) — ¡Este es el más poderoso!
-- Nivel Registros Felicidad GDPEsperanza vidaCorrupción media1086.6271.2870.797Alta corrupción6715.1820.8570.583Corrupción baja34.530.7470.515


-- ==================================================
-- PREGUNTA 4: Evolución temporal de la felicidad por región (2015-2019)
-- Concepto: JOIN + GROUP BY (múltiples columnas) + AVG + ORDER BY
-- ==================================================

-- Queremos ver si la felicidad ha mejorado o empeorado con los años
SELECT
    c.region,
    h.year,
    ROUND(AVG(h.happiness_score), 3) AS avg_happiness,
    ROUND(AVG(h.gdp_per_capita),  3) AS avg_gdp
FROM happiness_indicators h
JOIN countries c ON h.country_id = c.country_id
GROUP BY c.region, h.year
ORDER BY c.region ASC, h.year ASC;

-- Para visualizarlo : este resultado es perfecto para un line chart en Python
-- con región en el eje Y y años en el eje X.


-- ==================================================
-- PREGUNTA 5: ¿Qué regiones tienen felicidad por encima de la media global?
-- Concepto: HAVING + Subquery escalar (como en clase con bank.loan)
-- ==================================================

-- Primero calculamos la media global (igual que en clase calculábamos AVG del préstamo)
SELECT ROUND(AVG(happiness_score), 3) AS media_global
FROM happiness_indicators;

-- Ahora usamos esa media como subquery en el HAVING,
-- exactamente igual que el patrón visto en clase con bank.loan
SELECT
    c.region,
    ROUND(AVG(h.happiness_score), 3) AS avg_happiness
FROM happiness_indicators h
JOIN countries c ON h.country_id = c.country_id
GROUP BY c.region
HAVING avg_happiness > (SELECT AVG(happiness_score) FROM happiness_indicators)
ORDER BY avg_happiness DESC; 

-- Hallazgos Q5:
-- Solo 6 regiones superan la media global de felicidad (~5.4):
-- Australia & NZ — 7.304
-- North America — 7.263
-- Western Europe — 6.688
-- Latin America — 6.122
-- Eastern Asia — 5.625
-- Middle East & N.Africa — 5.397
-- Las otras 4 regiones (Central/Eastern Europe, Southeastern Asia, Southern Asia, Sub-Saharan Africa) están por debajo de la media global. 
Esto es un insight muy potente para la presentación.

-- Conclusión: Solo ciertas regiones superan la media global.
-- Este patrón de subquery en HAVING es idéntico al de bank.loan en clase.


-- ==================================================
-- PREGUNTA 6: Top 10 países más felices vs. su nivel de corrupción
-- Concepto: JOIN (3 tablas) + GROUP BY + AVG + ORDER BY + LIMIT
-- ==================================================

-- Tomamos los 10 países con mayor felicidad promedio
-- y observamos si tienen baja corrupción percibida
SELECT
    c.country,
    c.region,
    ROUND(AVG(h.happiness_score),       3) AS avg_happiness,
    ROUND(AVG(ci.perceived_corruption), 3) AS avg_corruption,
    ROUND(AVG(h.gdp_per_capita),        3) AS avg_gdp
FROM happiness_indicators h
JOIN countries c             ON h.country_id   = c.country_id
JOIN corruption_indicators ci ON ci.happiness_id = h.happiness_id
GROUP BY c.country, c.region
ORDER BY avg_happiness DESC
LIMIT 10;

-- Conclusión esperada: Los países más felices tienden a tener
-- baja corrupción percibida y alto PIB per cápita.


-- ==================================================
-- PREGUNTA 7: ¿Qué países mejoraron más su felicidad entre 2015 y 2019?
-- Concepto: Subquery como inline view (FROM subquery) + JOIN + ORDER BY
-- Patrón avanzado visto en clase: subquery dentro del FROM
-- ==================================================

-- Paso 1: extraemos el score de 2015 para cada país
SELECT h.country_id, h.happiness_score AS score_2015
FROM happiness_indicators h
WHERE h.year = 2015;

-- Paso 2: extraemos el score de 2019 para cada país
SELECT h.country_id, h.happiness_score AS score_2019
FROM happiness_indicators h
WHERE h.year = 2019;

-- Paso 3: unimos ambos subqueries como inline views (tablas temporales)
-- para calcular la diferencia — igual que el patrón de clase con inline views
SELECT
    c2015.country,
    c2015.region,
    ROUND(t2015.score_2015, 3)                        AS felicidad_2015,
    ROUND(t2019.score_2019, 3)                        AS felicidad_2019,
    ROUND(t2019.score_2019 - t2015.score_2015, 3)     AS variacion
FROM
    (SELECT h.country_id, h.happiness_score AS score_2015
     FROM happiness_indicators h WHERE h.year = 2015) AS t2015
JOIN countries c2015 ON c2015.country_id = t2015.country_id
JOIN countries c2019 ON c2019.country = c2015.country
JOIN
    (SELECT h.country_id, h.happiness_score AS score_2019
     FROM happiness_indicators h WHERE h.year = 2019) AS t2019
    ON t2019.country_id = c2019.country_id
WHERE c2015.region != 'Unknown'
ORDER BY variacion DESC
LIMIT 15;

-- Conclusión: Podemos identificar países con mejora notable y cruzarlos con cambios en corrupción percibida en el mismo período.
-- Hallazgos Q7 — Países que más mejoraron 2015→2019:
-- Insight muy interesante: Los países que más mejoraron parten de niveles muy bajos (3-4 puntos) — hay más margen de mejora.
-- Sub-Saharan Africa domina el top de mejora, lo cual es una historia positiva dentro de la región más desfavorecida.


-- ==================================================
-- PREGUNTA 8: Clasificación de países según múltiples dimensiones
-- Concepto: JOIN + CASE anidado + WHERE + ORDER BY
-- Identifica países "modelo": alta felicidad Y baja corrupción
-- ==================================================

SELECT
    c.country,
    c.region,
    ROUND(AVG(h.happiness_score),       3) AS avg_happiness,
    ROUND(AVG(ci.perceived_corruption), 3) AS avg_corruption,
    CASE
        WHEN AVG(h.happiness_score) >= 6.5
             AND AVG(ci.perceived_corruption) < 0.40
             THEN 'País modelo ✓'
        WHEN AVG(h.happiness_score) >= 6.5
             AND AVG(ci.perceived_corruption) >= 0.40
             THEN 'Feliz pero con corrupción'
        WHEN AVG(h.happiness_score) < 6.5
             AND AVG(ci.perceived_corruption) < 0.40
             THEN 'Menos feliz, baja corrupción'
        ELSE 'Alta corrupción y baja felicidad'
    END AS categoria_pais
FROM happiness_indicators h
JOIN countries c              ON h.country_id    = c.country_id
JOIN corruption_indicators ci ON ci.happiness_id = h.happiness_id
GROUP BY c.country, c.region
ORDER BY avg_happiness DESC;


-- ==================================================
-- RESUMEN DE HALLAZGOS
-- ==================================================
-- 1. Western Europe y North America/ANZ son las regiones más felices.
-- 2. Los 15 países con mayor corrupción percibida se concentran en
--    Sub-Saharan Africa y Southern Asia.
-- 3. Existe una correlación clara: a más corrupción, menos felicidad.
-- 4. La evolución 2015-2019 muestra que la felicidad global se ha
--    mantenido relativamente estable con pequeñas variaciones regionales.
-- 5. Solo X regiones superan la media global de felicidad (ver Q5).
-- 6. Los top 10 países más felices tienen corrupción percibida baja (< 0.40).
-- 7. Los países con mayor mejora 2015-2019 son principalmente de
--    Europa del Este y América Latina.
-- ==================================================
-- muy poderoso para la presentación: Incluso los países más felices del mundo tienen corrupción percibida alta (>0.40). 
-- Esto sugiere que la felicidad no requiere corrupción cero — otros factores como GDP, libertad y apoyo social compensan.

SELECT COUNT(*) AS total_paises     FROM countries;        -- debe dar 328
SELECT COUNT(*) AS total_registros  FROM happiness_indicators;  -- debe dar 782
SELECT COUNT(*) AS total_corruption FROM corruption_indicators; -- debe dar 782