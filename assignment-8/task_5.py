from config import db_name, mongo_host, mongo_port
import pymongo
from utils import *

elbow_points = {'Action' : 20, 
          'Horror' : 20,
          'Romance': 20, 
          'Sci-Fi' : 25,
          'Thriller' : 20}

# establish connection
db_address = ('mongodb://' + mongo_host + ':' + mongo_port + '/')
db_client = pymongo.MongoClient(db_address)
no_sql_db = db_client.get_database(db_name)

for genre in elbow_points:
    k = elbow_points[genre]
    SSE = run_k_means(genre=genre, num_of_clusters=k,db=no_sql_db, max_iterations=100)
    
