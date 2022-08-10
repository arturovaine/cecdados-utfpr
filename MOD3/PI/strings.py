PG_HOST='localhost'
PG_DATABASE='pi3'
PG_USER='arturo'
PG_PASSWORD='vaifunfar123'

STRING_CONEXAO = 'host='+ PG_HOST + ' port=5432' + ' dbname=' + \
              PG_DATABASE + ' user=' + PG_USER + ' password=' + PG_PASSWORD

LOCAL_DADOS = 'dados/'
ARQUIVO_BASE_PRINCIPAL = 'music_data.csv'
ARQUIVO_GENERO = 'music_features.csv'
ARQUIVO_BASE_TOP_200 = 'top_200.csv'
ARQUIVO_BASE_TOP_200_BRAZIL = 'top_200_brazil.csv'
ARQUIVO_BASE_TOP_200_BRAZIL_ARGENTINA = 'top_200_brazil_argentina.csv'
# ARQUIVO_BASE_TOP_100_20_ANOS = ['Top2001.csv','Top2002.csv','Top2003.csv','Top2004.csv','Top2005.csv',
#                                 'Top2006.csv','Top2007.csv','Top2008.csv','Top2009.csv','Top2010.csv',
#                                 'Top2011.csv','Top2012.csv','Top2013.csv','Top2014.csv','Top2015.csv',
#                                 'Top2016.csv','Top2017.csv','Top2018.csv','Top2019.csv']

COLUNAS_BASE_PRINCIPAL = ['valence','year','acousticness','artists','danceability','duration_ms',
                            'energy','explicit','id','instrumentalness','key','liveness','loudness',
                            'mode','name','popularity','speechiness','tempo']

COLUNAS_BASE_TOP_200 = ['URL', 'Streams', 'Position', 'Date', 'name']
COLUNAS_BASE_TOP_100_20_ANOS = ['id', 'year']
COLUNAS_GENERO = ['track_id', 'genre']

DDL_OBJETOS = (
    'DROP TABLE IF EXISTS spotify',
    'DROP TABLE IF EXISTS artists',
    'DROP TABLE IF EXISTS genre',
    'DROP TABLE IF EXISTS year',
    'DROP TABLE IF EXISTS country',
    'DROP TABLE IF EXISTS songs',
    
    'DROP INDEX IF EXISTS idx_genre_track_id',    
    
    'CREATE TABLE IF NOT EXISTS artists (' 
        'artists_id int,' 
        'artists varchar,' 
        'CONSTRAINT PK_artists_id PRIMARY KEY(artists_id)' 
    ')',
    
    'CREATE TABLE IF NOT EXISTS genre (' 
        'genre_id int,' 
        'genre varchar,' 
        'track_id varchar,' 
        'CONSTRAINT PK_genre_id PRIMARY KEY(genre_id)' 
    ')',
    
    'CREATE TABLE IF NOT EXISTS year (' 
        'year int,'
        'CONSTRAINT PK_year PRIMARY KEY(year)' 
    ')',
    
    'CREATE TABLE IF NOT EXISTS country ('         
        'country varchar,'        
        'CONSTRAINT PK_country_id PRIMARY KEY(country)' 
    ')',
    
    'CREATE TABLE IF NOT EXISTS songs (' 
        'track_id varchar,' 
        'song varchar,'
        'CONSTRAINT PK_track_id PRIMARY KEY(track_id)'
    ')',
    
    'CREATE TABLE IF NOT EXISTS spotify (' 
        'track_id varchar,'                 
        'popularity int,' 
        'year int,'                     
        'artists_id int,'        
        'valence float,' 
        'acousticness float,' 
        'danceability float,' 
        'duration_ms int,' 
        'energy float,' 
        'explicit int,' 
        'instrumentalness float,' 
        'key int,' 
        'liveness float,' 
        'loudness float,' 
        'mode int,' 
        'speechiness float,' 
        'tempo float,' 
    
        'streams_date date,'
        'streams_year int,'
        'streams int,'
        'position int,'
        'country varchar,'
    
        'features_array float[]'            
    ')',
    
    'CREATE INDEX idx_genre_track_id ON genre(track_id)',     
)