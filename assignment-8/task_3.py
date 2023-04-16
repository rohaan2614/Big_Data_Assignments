'''Identifies the nearst cluster to a document with the given genre'''

import pymongo
import argparse
from config import *
from utils import *


'''''''''''''''''''''''''''''''''PART 1 : ADD & ASSIGN CLUSTERS'''''''''''''''''''''''''''''''''

# parse arguments
parser = argparse.ArgumentParser(
    description="This program requires the argument -g i.e the genre", )
parser.add_argument('-g', type=str, required=True)
args = parser.parse_args()
genre = args.g


# establish connection
db_address = ('mongodb://' + mongo_host + ':' + mongo_port + '/')
db_client = pymongo.MongoClient(db_address)
no_sql_db = db_client.get_database(db_name)
scored_movies = no_sql_db.get_collection(scored_collection)
centeroids_collection = no_sql_db.get_collection(task_2_collection)
centeroids = get_centeroids(db=no_sql_db)

qty_centeroids = list(centeroids_collection.aggregate(pipeline=[{'$count': 'k'}]))[0]['k']

data_points = list(scored_movies.find({'genres': {'$elemMatch': {'$eq': genre}}}, {'kMeansNorm': 1, 'genres' : 1, 'cluster' : 1}))
# print("Data Points:")
for data_point in data_points:
    # find nearest cluster
    print("\nDatapoint:\t",data_point)
    distances = get_distances([data_point], centeroids)
    cluster_assignments = get_nearest_clusters(distances)
    print("\tCluster Assignment:\t", cluster_assignments)
    assigned_cluster = cluster_assignments[0][1]
    sqaured_distance = cluster_assignments[0][2]
    # calculate new centeroid coordinates
    old_coordinates = list(centeroids_collection.find({'_id' : cluster_assignments[0][1]}))[0]['kMeansNorm']
    new_coordinates = get_new_centeroid([{'kMeansNorm' : old_coordinates}, data_point])
    print("\tCenteroid Update:\t",old_coordinates,"\t->\t", new_coordinates)
    # commit updates
        # centeroid
    query = {"_id": assigned_cluster}
    new_value = {"$set": {"kMeansNorm": new_coordinates}}
    centeroids_collection.update_one(query, new_value)
        # movie
    query = {"_id": data_point['_id']}
    new_value = {"$set": {"cluster": assigned_cluster}}
    new_value = {"$set": {"cluster": assigned_cluster, "squared_distance": sqaured_distance}}
    scored_movies.update_one(query, new_value)
