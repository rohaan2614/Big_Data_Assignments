from config import db_name, mongo_host, mongo_port
import pymongo
from utils import *

# establish connection
db_address = ('mongodb://' + mongo_host + ':' + mongo_port + '/')
db_client = pymongo.MongoClient(db_address)
no_sql_db = db_client.get_database(db_name)

genres = ['Action', 'Horror', 'Romance', 'Sci-Fi', 'Thriller']

for genre in genres:
    Ks = []
    SSEs = []
    for k in range(10,51,5):
        SSE = run_k_means(genre=genre, num_of_clusters=k, db=no_sql_db, max_iterations=100)
        Ks.append(k)
        SSEs.append(SSE)

    with open(f"visualizations/{genre}.txt", "w") as outfile:
        outfile.writelines('k, SSE\n')
        for i in range (len(SSEs)):
             outfile.writelines(f'{Ks[i]}, {SSEs[i]}\n')

