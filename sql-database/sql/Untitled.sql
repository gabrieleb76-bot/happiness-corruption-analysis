USE happiness_corruption_db;

DROP TABLE IF EXISTS corruption_indicators;
DROP TABLE IF EXISTS happiness_indicators;
DROP TABLE IF EXISTS countries;

CREATE TABLE countries (
    country_id INT PRIMARY KEY,
    country VARCHAR(100),
    region VARCHAR(100)
);

CREATE TABLE happiness_indicators (
    happiness_id INT PRIMARY KEY,
    country_id INT,
    year INT,
    happiness_rank INT,
    happiness_score FLOAT,
    gdp_per_capita FLOAT,
    social_support FLOAT,
    life_expectancy FLOAT,
    freedom FLOAT,
    generosity FLOAT,
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

CREATE TABLE corruption_indicators (
    corruption_id INT PRIMARY KEY,
    happiness_id INT,
    institutional_trust FLOAT,
    perceived_corruption FLOAT,
    FOREIGN KEY (happiness_id) REFERENCES happiness_indicators(happiness_id)
);

SHOW TABLES;