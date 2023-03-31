'''
Creates/Establishes connection to Mongo DB
'''

# libraries
import configparser as cp
import pymongo

# load configurationtype
config = cp.ConfigParser()
config.read('config.cfg')
db_name = config['MONGO_DB']['dbName']

# checks whether db exists already, create it it non-existent
my_client = pymongo.MongoClient('mongodb://localhost:27017/')
if (db_name not in my_client.list_database_names()):
    my_db = my_client[f'{db_name}']
    movies = my_db['Movies']
    members = my_db['Members']
    print(my_client.list_database_names())
    print(my_client.my_db.list_collection_names())