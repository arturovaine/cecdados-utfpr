DROP TABLE IF EXISTS indicators_country;
DROP TABLE IF EXISTS country;
DROP TABLE IF EXISTS indicators;
DROP TABLE IF EXISTS region;
DROP TABLE IF EXISTS topic; -- classificação (categoria) dos indicadores

-- tabela de regiões
CREATE TABLE IF NOT EXISTS region (
	region_code SERIAL,
	region_name CHAR(100) NOT NULL,
	CONSTRAINT PK_region_code PRIMARY KEY(region_code)
);

-- tabela de países
CREATE TABLE IF NOT EXISTS country (
	country_code CHAR(3) NOT NULL,
	short_name CHAR(50) NOT NULL,
	long_name CHAR(150) NOT NULL,
	currency_unit CHAR(50),
	region_code INT,
	CONSTRAINT PK_country_code PRIMARY KEY(country_code),
	CONSTRAINT FK_region_code FOREIGN KEY (region_code) REFERENCES region (region_code)
);

-- tópicos
CREATE TABLE IF NOT EXISTS topic (
	topic_code SERIAL,
	topic_description CHAR(200) NOT NULL,
	CONSTRAINT PK_topic_code PRIMARY KEY(topic_code)
);-- tabela de indicadores

CREATE TABLE IF NOT EXISTS indicators (
	indicator_code CHAR(30) NOT NULL,
	indicator_name CHAR(200) NOT NULL,
	topic_code INT NOT NULL,
	CONSTRAINT PK_indicator_code PRIMARY KEY(indicator_code),
	CONSTRAINT FK_topic_code FOREIGN KEY (topic_code) REFERENCES topic (topic_code)
);

-- tabela de indicadores dos países
CREATE TABLE IF NOT EXISTS indicators_country (
	indicator_code char(30) NOT NULL,
	country_code char(3) NOT NULL,
	year_indicator SMALLINT,
	value_indicator DOUBLE PRECISION,
	CONSTRAINT PK_indicator_country_codes_year PRIMARY KEY(indicator_code,country_code, year_indicator),
	CONSTRAINT FK_indicators FOREIGN KEY (indicator_code) REFERENCES indicators (indicator_code),
	CONSTRAINT FK_country FOREIGN KEY (country_code) REFERENCES country (country_code)
);

SELECT * FROM topic;
SELECT * FROM region;
SELECT * FROM country;
SELECT * FROM indicators;
SELECT * FROM indicators_country;

-- 877

SELECT ic.indicator_code cod_indicador, i.indicator_name indicador,
	ic.country_code cod_pais, c.short_name pais,
	ic.year_indicator ano, ic.value_indicator valor
FROM indicators_country ic
	INNER JOIN indicators i
	  ON i.indicator_code = ic.indicator_code
	INNER JOIN country c
	  ON c.country_code = ic.country_code
WHERE 1 = 1
AND ic.year_indicator = 2000
AND ic.country_code = 'BRA'