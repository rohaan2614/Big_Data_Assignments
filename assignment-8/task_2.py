import pymongo
import argparse
from config import (db_name, mongo_host, mongo_port, scored_collection,
                    task_2_collection as centeroids)

# parse arguments
parser = argparse.ArgumentParser(
    description="This program requires two arguments. -k i.e the number of centorids & -g i.e the genre", )
parser.add_argument('-k', type=str, required=True)
parser.add_argument('-g', type=str, required=True)
args = parser.parse_args()
number_of_centeroids = int(args.k)
genre = args.g


# establish connection
db_address = ('mongodb://' + mongo_host + ':' + mongo_port + '/')
db_client = pymongo.MongoClient(db_address)
no_sql_db = db_client.get_database(db_name)
k_means_collection = no_sql_db.get_collection(scored_collection)

# k random documents associated with genre g
pipeline = [
    {
        '$match': {
            'genres': {
                '$elemMatch': {
                    '$eq': genre
                }
            }
        }
    }, {
        '$sample': {
            'size': number_of_centeroids
        }
    }
]

results = k_means_collection.aggregate(pipeline=pipeline)
modified_results = []
i = 0
for movie in results:
    movie['_id'] = i
    modified_results.append(movie)
    i += 1


# delete previous centeroids
no_sql_db[centeroids].drop()

# populate new centeroids
centeroids = no_sql_db.get_collection(centeroids)
centeroids.insert_many(modified_results)

print("All Done")
