# %%
# libraries
import pymongo
from tqdm import tqdm
import json

# constants
results_json = '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-6/results.json'
db_name = 'csci_620_ass_4'
collection_name = 'additional_info'
movies_collection = 'Movies'
matches = []

# code
my_client = pymongo.MongoClient('mongodb://localhost:27017/')
my_db = my_client[f'{db_name}']
add_info_collection = my_db[collection_name]
movies_collection = my_db[movies_collection]


with open (results_json, "r") as src_file:
    for line in src_file.readlines():
        if len(json.loads(line)['result']) > 0 :
            matches.append(json.loads(line))
print("All Done. ", len(matches), " matches read.")
