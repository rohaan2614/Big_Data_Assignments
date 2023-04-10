import pymongo
# from utils import
from config import db_name, mongo_host, mongo_port, collection_name, scored_collection

# establish connection
db_address = ('mongodb://' + mongo_host + ':' + mongo_port + '/')
db_client = pymongo.MongoClient(db_address)
no_sql_db = db_client.get_database(db_name)
filtered_movies = no_sql_db.get_collection(collection_name)

# print(filtered_movies.find_one({'startyear' : not None}))
min_year = min(filtered_movies.distinct('startyear'))
max_year = max(filtered_movies.distinct('startyear'))
min_avg_rating = min(filtered_movies.distinct('avgrating'))
max_avg_rating = max(filtered_movies.distinct('avgrating'))

pipeline = [
    {
        '$addFields': {
            'kMeansNorm': [
                {
                    '$divide': [
                        {
                            '$subtract': [
                                '$startyear', min_year
                            ]
                        }, max_year - min_year
                    ]
                }, {
                    '$divide': [
                        {
                            '$subtract': [
                                '$avgrating', min_avg_rating
                            ]
                        }, max_avg_rating - min_avg_rating
                    ]
                }
            ]
        }
    }, {
        '$out': scored_collection
    }
]

filtered_movies.aggregate(pipeline=pipeline)
