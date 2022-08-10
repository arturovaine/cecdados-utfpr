import psycopg2
import strings as strlib

def criar_objetos_banco(ddl):

    cursor = None
    conexao = None

    try:
        conexao = psycopg2.connect(strlib.STRING_CONEXAO)
        cursor = conexao.cursor()

        for instrucao in ddl:
            cursor.execute(instrucao)

        cursor.close()
        conexao.commit()

        print('OBJETOS CRIADOS COM SUCESSO.')

    except (Exception, psycopg2.DatabaseError) as error:
#        conexao.rollback()
        print(error)
    finally:
        if conexao is not None:
            conexao.close()

#--------------------------------------------------

def inserir_dados(dataframe, tabela, campos):
    
    conexao = None
    cursor = None
    tupla = None
    
    try:

        conexao = psycopg2.connect(strlib.STRING_CONEXAO)
        cursor = conexao.cursor()   

        print('[' + tabela.upper() + '] INSERINDO DADOS NA TABELA...')

        #Povoa a tabela de aferições
        
        if (len(dataframe) == 1):
            for i, linha in dataframe.iterrows():
                sql = 'INSERT INTO ' + tabela + '(' + campos + ') ' \
                    'VALUES (' + '%s)'
                tupla = tuple(linha)
                cursor.execute(sql, tuple(linha))
        else:
            for i, linha in dataframe.iterrows():
                sql = 'INSERT INTO ' + tabela + '(' + campos + ') ' \
                    'VALUES (' + '%s,' *(len(linha)-1) + '%s)'
                tupla = tuple(linha)
                cursor.execute(sql, tuple(linha))

        conexao.commit()

        print('[' + tabela.upper() + '] REGISTROS INSERIDOS COM SUCESSO.')

    except (Exception, psycopg2.DatabaseError) as error:
#        conexao.rollback()
        print(error)
        print(tupla)
    finally:
        if conexao is not None:
            conexao.close()