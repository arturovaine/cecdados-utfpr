#Manipula??o
library(tidyverse)

#Conex?o com o PostGres
library(RPostgres)

#deve-se criar um banco chamado wdevelopment ou o nome que preferirem.
conexao <- dbConnect(
  Postgres(),
  user="postgres",
  password="xqlyns22",
  host="localhost",
  port=5432,
  dbname="wdevelopment"
)

conexao

dbListTables(conexao)

#--------------------------------------
#INSERTS

#regions(CONTINENTES)

#a op??o na coloca um string vazio no lugar de NA.
#n?o funcionou com a op??o na direto. usei UPDATE
countries <- read_csv("C:\\Users\\artur\\Documents\\Ciencia de Dados - UTFPR\\Projeto Integrador\\Country.csv", na="N/A") [c("CountryCode","ShortName","LongName","CurrencyUnit","Region")]
countries

#Teste
#filteredCountries <- filter(countries, Region == "North America")
#filteredCountries

regions <- distinct(countries, Region) %>% arrange(Region) %>% mutate(RegionCode=1:8)
regions
dbExecute(conexao, "INSERT INTO region(region_name) VALUES ($1)", params=unname(as.list(regions)))
dbExecute(conexao, "UPDATE region SET region_name = 'N/A' WHERE region_name = ''")

#--------------------------------------

# join entre regions e country
# Esse passo é necessario pois os csv nao sao normalizados, logo para associarmos a regiao pelo
# codigo da regiao e nao pelo nome para efeito de insercao no PGSQL.
innerJoinRegionCountry <- merge(x=countries, y=regions, by="Region") %>% select("CountryCode","ShortName","LongName","CurrencyUnit","RegionCode")
innerJoinRegionCountry

# Teste
# filteredCountries <- filter(innerJoinRegionCountry, CountryCode == "BRA")
# No resutlado abaixo a gente ve que o que vai para o PGSQL é o codigo da regiao 
# e nao a descricao, que fica na tabela Region
# filteredCountries

#insert em country
dbExecute(conexao, "INSERT INTO country(country_code, short_name, long_name, currency_unit, region_code) VALUES ($1,$2,$3,$4,$5)", params=unname(as.list(innerJoinRegionCountry)))

#--------------------------------------

# A tabela indicators foi criada para mapear os codigos dos indicadores e suas descricoes
# Cada indicador possui uma categoria, que é chamada de Topic na base (sabe Deus por que)

#Tabela indicators
indicators <- read_csv("C:\\Users\\artur\\Documents\\Ciencia de Dados - UTFPR\\Projeto Integrador\\Series.csv")[,c("SeriesCode","IndicatorName","Topic")] %>% arrange(IndicatorName)
indicators
#filteredIndicators <- filter(indicators, IndicatorCode == "BN.KLT.DINV.CD")
#filteredIndicators

#Tabela series(?!): relaciona os indicadores ?s suas categorias (topics).

#Para inser??o: essa etapa ? necess?ria, pois a tabela pede um SERIAL (alterar depois no banco para remover o SERIAL)
topics <- read_csv("C:\\Users\\artur\\Documents\\Ciencia de Dados - UTFPR\\Projeto Integrador\\Series.csv") %>% distinct(Topic) %>% arrange(Topic)
dbExecute(conexao, "INSERT INTO topic(topic_description) VALUES ($1)", params=unname(as.list(topics)))

#para join
topics <- read_csv("C:\\Users\\artur\\Documents\\Ciencia de Dados - UTFPR\\Projeto Integrador\\Series.csv")[c("Topic")] %>% distinct %>% arrange(Topic) %>% mutate(TopicCode=1:91)
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
#inserts nos indicadores dos pa?ses

#Aqui ? a inser??o na tabela principal, que vai guardar as chaves para indicadores e pa?ses,
#bem como os dados de ano e valores.

#observa??o: n?o foi necess?rio fazer join, pois o arquivo j? vem com 
#os c?digos de indicadores e pa?ses, bastando apenas inserir.

indicatorsCountries <- read_csv("C:\\Users\\artur\\Documents\\Ciencia de Dados - UTFPR\\Projeto Integrador\\indicators.csv")[,c('CountryCode','IndicatorCode','Year','Value')]
indicatorsCountries

#teste
#indicadoresBrasil <- filter(indicatorsCountries, CountryCode == "BRA" & Year == 2000)
#indicadores

#teste
#filteredIndicatorsCountries <- filter(indicatorsCountries, IndicatorCode == "SP.ADO.TFRT" & CountryCode == "ARB")
#filteredIndicatorsCountries

dbExecute(conexao, "INSERT INTO indicators_country(country_code, indicator_code, year_indicator, value_indicator) VALUES ($1,$2,$3,$4)", params=unname(as.list(indicatorsCountries)))