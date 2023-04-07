from util import query_recursively, query_psql

# create tables & get max lattice level
min_support = 5
lattice_levels = query_recursively(min_support = min_support, trim_query_print=True)
print('Maximum Number of Frequent itemsets: ', lattice_levels)

# get all records from highest lattice level
actors = set()
for row in query_psql(f'SELECT * FROM l{lattice_levels};'):
    # print('row:\t', row)
    for actor in row[:-1]:
        actors.add(actor)
        # print('actors:\t', actors)
print(actors)

query_psql(f'CREATE TABLE l{lattice_levels}_actors (ID INT PRIMARY KEY);')
for actor in list(actors):
    query_psql(f'INSERT INTO l{lattice_levels}_actors VALUES ({actor});')

print(query_psql(f'SELECT M.id, name FROM l{lattice_levels}_actors A JOIN member M ON M.id = A.id;'))
