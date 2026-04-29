SELECT COUNT(*) FROM countries;

SELECT COUNT(*) FROM happiness_indicators;

SELECT COUNT(*) FROM corruption_indicators;

SELECT * FROM countries LIMIT 10;
SELECT * FROM happiness_indicators LIMIT 10;
SELECT * FROM corruption_indicators LIMIT 10;

SELECT
c.country,
h.year,
h.happiness_score,
ci.perceived_corruption
FROM happiness_indicators h
JOIN countries c
ON h.country_id = c.country_id
JOIN corruption_indicators ci
ON h.happiness_id = ci.happiness_id
LIMIT 20;