'''Identifies the nearst cluster to a document with the given genre'''

import pymongo
import argparse
from config import (db_name, mongo_host, mongo_port, scored_collection, 
                    task_2_collection as centeroids)
from utils import get_distances, get_nearest_clusters
# import copy

id_field = '_id'


# parse arguments
parser = argparse.ArgumentParser(
    description="This program requires two arguments. -k i.e the number of centorids & -g i.e the genre", )
# parser.add_argument('-k', type=str, required=True)
parser.add_argument('-g', type=str, required=True)
args = parser.parse_args()
# number_of_centeroids = int(args.k)
genre = args.g


# establish connection
db_address = ('mongodb://' + mongo_host + ':' + mongo_port + '/')
db_client = pymongo.MongoClient(db_address)
no_sql_db = db_client.get_database(db_name)
centeroids = no_sql_db.get_collection(centeroids)

points = list(centeroids.find({}, {'kMeansNorm':1,}))
distances = get_distances(points)
clusters = get_nearest_clusters(distances)

documents = centeroids.find({})
i = 0
print("ID\tCluster\tGenre\tAvg Rating\tstart Year\tTitle")
for doc in documents:
    print(f"{doc['_id']}\t   {clusters[i]}\t{genre}\t   {doc['avgrating']}\t       \t{doc['startyear']}\t{doc['title']}")
    # print(f"ID:\t{doc['_id']}\tCluster:\t{clusters[i]}\tTitle:\t{doc['title']}")
    query = {"_id" : doc['_id']}
    new_value = { "$set": {"cluster" : clusters[i]} }
    centeroids.update_one(query, new_value)
    i += 1

# print("All Done")