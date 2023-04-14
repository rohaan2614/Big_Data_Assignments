'''Identifies the nearst cluster to a document with the given genre'''

import pymongo
import argparse
from config import (db_name, mongo_host, mongo_port, scored_collection,
                    task_2_collection)
from utils import get_distances, get_nearest_clusters, get_new_centeroids


'''''''''''''''''''''''''''''''''PART 1 : ADD CLUSTER FIELD'''''''''''''''''''''''''''''''''

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
centeroids = list(centeroids_collection.find({}))

# get movies of that genre
points = list(scored_movies.find({'genres': {'$elemMatch': {'$eq': genre}}}, {'kMeansNorm': 1}))
# print(points,"\n\n\n")
# assign nearest clusters
distances = get_distances(points, centeroids)
# print(distances,"\n\n\n")
cluster_assignments = get_nearest_clusters(distances)
print("Clusters:\t",cluster_assignments,"\n\n\n")
for i in range(len(distances)):
    data_point_id = cluster_assignments[i][0]
    query = {"_id": data_point_id}
    new_value = {"$set": {"cluster": cluster_assignments[i][1]}}
    scored_movies.update_one(query, new_value)

# print results

# filter = {'genres': {'$elemMatch': {'$eq': genre}}}

# project = {
#     'cluster': 1,
#     'startyear': 1,
#     'avgrating': 1,
#     'title': 1
# }

# sort = list({'cluster': 1}.items())
# documents = scored_movies.find(filter=filter, projection=project, sort=sort)

# print("ID\tCluster\t\tstart Year\tAvg Rating\tTitle")
# for doc in documents:
#     print(f"{doc['_id']}\t   {doc['cluster']}  \t\t  {doc['startyear']}\t\t{doc['avgrating']}\t\t{doc['title']}")

'''''''''''''''''''''''''''''''''PART 2 : UPDATE CENTEROIDS'''''''''''''''''''''''''''''''''
k = list(centeroids_collection.aggregate(pipeline=[{'$count': 'k'}]))[0]['k']
new_centeroids = {}
for i in range(1, k+1):
    filter = {'genres': {'$elemMatch': {'$eq': genre}},'cluster': i}
    project={'kMeansNorm': 1}
    new_centeroids[i] = get_new_centeroids(list(scored_movies.find(filter=filter, projection=project)))
print(new_centeroids)
for i in range(1, k+1):
    data_point_id = i
    query = {"_id": data_point_id}
    new_value = {"$set": {"cluster": new_centeroids[i]}}
    centeroids_collection.update_one(query, new_value)


