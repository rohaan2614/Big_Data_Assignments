# %%
# libraries
import pymongo
from tqdm import tqdm

# constants
additional_data_file = '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-6/additional_data/extra-data.json'
db_name = 'csci_620_ass_4'
collection_name = 'additional_info'
movies_collection = 'Movies'

# code
my_client = pymongo.MongoClient('mongodb://localhost:27017/')
my_db = my_client[f'{db_name}']
add_info_collection = my_db[collection_name]
movies_collection = my_db[movies_collection]

pipeline = [
    {
        '$lookup': {
            'from': 'Movies', 
            'localField': 'title', 
            'foreignField': 'title', 
            'as': 'title_as_connection'
        }
    }
]

results = list(add_info_collection.aggregate(pipeline))
with open ("results_task_3.json", "w") as results_txt:
    results_txt.writelines(str(results))

for result in results:
    print(result)

print("All Done")
