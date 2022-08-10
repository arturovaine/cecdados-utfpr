#Manipulação
library(tidyverse)

#Conexão com o PostGres
library(RPostgres)

#deve-se criar um banco chamado wdevelopment ou o nome que preferirem.
conexao <- dbConnect(
  Postgres(),
  user="postgres",
  password="postgres",
  host="localhost",
  port=5432,
  dbname="wdevelopment"
)

conexao

dbListTables(conexao)

#--------------------------------------
#INSERTS

#regions(CONTINENTES)

#a opção na coloca um string vazio no lugar de NA.
#não funcionou com a opção na direto. usei UPDATE
countries <- read_csv("d:/Downloads/UTFPR/PI/Country.csv", na="N/A") [c("CountryCode","ShortName","LongName","CurrencyUnit","Region")]
countries

#Teste
#filteredCountries <- filter(countries, Region == "North America")
#filteredCountries

regions <- distinct(countries, Region) %>% arrange(Region) %>% mutate(RegionCode=1:8)
regions
dbExecute(conexao, "INSERT INTO region(region_name) VALUES ($1)", params=unname(as.list(regions)))
dbExecute(conexao, "UPDATE region SET region_name = 'N/A' WHERE region_name = ''")

#--------------------------------------

#join entre regions e country
#Esse passo é necessário pois os csv não são normalizados, logo para associarmos a região pelo
#código da região e não pelo nome para efeito de inserção no PGSQL.
innerJoinRegionCountry <- merge(x=countries, y=regions, by="Region") %>% select("CountryCode","ShortName","LongName","CurrencyUnit","RegionCode")
innerJoinRegionCountry

#Teste
#filteredCountries <- filter(innerJoinRegionCountry, CountryCode == "BRA")
#No resutlado abaixo a gente vê que o que vai para o PGSQL é o código da região 
#e não a descrição, que fica na tabela Region
#filteredCountries

#insert em country
dbExecute(conexao, "INSERT INTO country(country_code, short_name, long_name, currency_unit, region_code) VALUES ($1,$2,$3,$4,$5)", params=unname(as.list(innerJoinRegionCountry)))

#--------------------------------------

#A tabela indicators foi criada para mapear os códigos dos indicadores e suas descrições
#Cada indicador possui uma categoria, que é chamada de Topic na base (sabe Deus por quê)

#Tabela indicators
indicators <- read_csv("d:/Downloads/UTFPR/PI/Series.csv")[,c("SeriesCode","IndicatorName","Topic")] %>% arrange(IndicatorName)
indicators
#filteredIndicators <- filter(indicators, IndicatorCode == "BN.KLT.DINV.CD")
#filteredIndicators

#Tabela series(?!): relaciona os indicadores às suas categorias (topics).

#Para inserção: essa etapa é necessária, pois a tabela pede um SERIAL (alterar depois no banco para remover o SERIAL)
topics <- read_csv("d:/Downloads/UTFPR/PI/Series.csv") %>% distinct(Topic) %>% arrange(Topic)
dbExecute(conexao, "INSERT INTO topic(topic_description) VALUES ($1)", params=unname(as.list(topics)))

#para join
topics <- read_csv("d:/Downloads/UTFPR/PI/Series.csv")[c("Topic")] %>% distinct %>% arrange(Topic) %>% mutate(TopicCode=1:91)
topics

#join entre indicators e topics pelo mesmo motivo do join Country e Region
innerJoinIndicatorTopic <- merge(x=indicators, y=topics, by="Topic") %>% select("SeriesCode","IndicatorName","TopicCode")
innerJoinIndicatorTopic

#Teste
#filteredIndicators <- filter(innerJoinIndicatorTopic, SeriesCode == "DT.COM.DPPG.CD")
#filteredIndicators

#insert em indicators
dbExecute(conexao, "INSERT INTO indicators(indicator_code, indicator_name, topic_code) VALUES ($1,$2,$3)", params=unname(as.list(innerJoinIndicatorTopic)))

#--------------------------------------
#inserts nos indicadores dos países

#Aqui é a inserção na tabela principal, que vai guardar as chaves para indicadores e países,
#bem como os dados de ano e valores.

#observação: não foi necessário fazer join, pois o arquivo já vem com 
#os códigos de indicadores e países, bastando apenas inserir.

indicatorsCountries <- read_csv("d:/Downloads/UTFPR/PI/indicators.csv")[,c('CountryCode','IndicatorCode','Year','Value')]
indicatorsCountries

#teste
#indicadoresBrasil <- filter(indicatorsCountries, CountryCode == "BRA" & Year == 2000)
#indicadores

#teste
#filteredIndicatorsCountries <- filter(indicatorsCountries, IndicatorCode == "SP.ADO.TFRT" & CountryCode == "ARB")
#filteredIndicatorsCountries

dbExecute(conexao, "INSERT INTO indicators_country(country_code, indicator_code, year_indicator, value_indicator) VALUES ($1,$2,$3,$4)", params=unname(as.list(indicatorsCountries)))