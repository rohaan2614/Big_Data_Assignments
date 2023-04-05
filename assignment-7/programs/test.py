from os import listdir
import psycopg2
from itertools import combinations

connection = psycopg2.connect("dbname=csci_620_ass_2")
cursor = connection.cursor()

if 'nC2.txt' in listdir('temp'):
    print('OK!')
else:
    cursor.execute('SELECT DISTINCT actor FROM popular_movie_actors;')
    popular_actors = cursor.fetchall()
    population_actors_restructured = []
    for i in range(0, len(popular_actors)):
        population_actors_restructured.append(popular_actors[i][0])
    print('#Actors: ', len(population_actors_restructured))
    print('Snippet: ', population_actors_restructured[:5])
    actors_set = set(combinations(population_actors_restructured, 1))
    with open ('temp/nC2.txt', 'w') as data_dump:
        data_dump.write(str(actors_set))
cursor.close()
connection.close()