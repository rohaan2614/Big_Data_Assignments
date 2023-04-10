import psycopg2

def generate_query(min_support, break_point):
    num_actors = 1
    select_clause = 'SELECT '
    cross_join_clause = ''
    where_clause = ''
    group_clause = ' GROUP BY '
    while (True) :
        select_clause += f'actor{num_actors}, '
        group_clause += f'actor{num_actors}, '
        if num_actors > 1:
            cross_join_clause += f' CROSS JOIN (SELECT actor AS "actor{num_actors}", title AS "actor{num_actors}_movie" FROM popular_movie_actors) AS actor_{num_actors}_alias'
        
        if num_actors == 2:
            where_clause = f' WHERE (actor{num_actors - 1} < actor{num_actors}) AND (actor{num_actors - 1}_movie = actor{num_actors}_movie)'
        
        elif num_actors > 1:
            where_clause += f' AND (actor{num_actors - 1} < actor{num_actors}) AND (actor{num_actors - 1}_movie = actor{num_actors}_movie)'
        
        num_actors += 1

        # break condition
        if (num_actors > break_point):
            break

    select_clause += 'COUNT(actor1_movie) AS "movies" FROM ( SELECT actor AS "actor1", title AS "actor1_movie" FROM popular_movie_actors) AS actor_1_alias'

    
    query = f'CREATE TABLE IF NOT EXISTS L{num_actors - 1} AS (' + select_clause + cross_join_clause + where_clause + group_clause[:-2] + f' HAVING COUNT(actor1_movie) >= {min_support}); SELECT COUNT(*) FROM L{num_actors - 1};'
    return query, num_actors - 1


def query_recursively(min_support = 5, trim_query_print=False, print_characs=140):

    connection = psycopg2.connect("dbname=csci_620_ass_2")
    cursor = connection.cursor()
    break_point = 1
    results = []
    
    query, lattice_levels = generate_query(min_support=min_support, break_point = break_point)
    if trim_query_print :
        print('Executing query:\n' + '\t' + query[:print_characs], '...')
    else:
        print('Executing query:\n' + '\t' + query)
    cursor.execute(query)
    results = cursor.fetchall()
    print('\tResults returned: ', results[0][0])

    while (results[0][0]) > 0:
        break_point += 1
        query, lattice_levels = generate_query(min_support=min_support, break_point = break_point)
        if trim_query_print :
            print('Executing query:\n' + '\t' + query[:print_characs], '...')
        else:
            print('Executing query:\n' + '\t' + query)
        cursor.execute(query)
        results = cursor.fetchall()
        print('\tResults returned: ', results[0][0])

    connection.commit()
    cursor.close()
    connection.close()

    return lattice_levels - 1

def query_psql(query, dbname='csci_620_ass_2'):
    connection = psycopg2.connect(f"dbname={dbname}")
    cursor = connection.cursor()
    cursor.execute(query)
    executed = False
    try:
        results = cursor.fetchall()
        executed = True
    except:
        pass
    connection.commit()
    cursor.close()
    connection.close()
    if (executed):
        return results