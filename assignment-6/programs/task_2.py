# libraries
import json
import pymongo

# constants
additional_data_file = '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-6/additional_data/extra-data.json'
db_name = 'csci_620_ass_4'
collection_name = 'additional_info'

# code
my_client = pymongo.MongoClient('mongodb://localhost:27017/')
my_db = my_client[f'{db_name}']
add_info_collection = my_db[collection_name]
with open(additional_data_file, 'r') as src_file:
    successes = 0
    id_absences = 0
    revenue_absences = 0
    cost_absences = 0
    distributor_absences = 0
    rating_absences = 0
    insertion_errors = 0
    duplicates_ignored = 0
    useless_objects = 0 # objects that contain nothing expect the id
    for line in src_file.readlines():
        try:
            # load json
            data = json.loads(line)
            # identify key json fields
            restructured_data = {}
            try:
                restructured_data['_id'] = int(data['IMDb_ID']['value'][2:])
            except KeyError:
                id_absences += 1
            try:
                restructured_data['revenue'] = float(
                    data['box_office']['value'])
            except KeyError:
                revenue_absences += 1
            try:
                restructured_data['cost'] = float(data['cost']['value'])
            except KeyError:
                cost_absences += 1
            try:
                restructured_data['distributor'] = data['distributorLabel']['value']
            except KeyError:
                distributor_absences += 1
            try:
                restructured_data['rating'] = data['MPAA_film_ratingLabel']['value']
            except KeyError:
                rating_absences += 1
            
            # insert data if there's more info than just the id
            if len(restructured_data) > 1:
                try:
                    add_info_collection.insert_one(restructured_data)
                    successes += 1
                except pymongo.errors.DuplicateKeyError:
                    duplicates_ignored += 1
                    continue
                except Exception as E:
                        print("Unhandled Insertion Error: ", E)
                        insertion_errors += 1
            else:
                useless_objects += 1
        except Exception as E:
            print('Unhandled Exception: ', E)
    total_errors = id_absences + insertion_errors
    print(f'Successes : {successes}, \nid_absences: {id_absences}\trevenue_absences: {revenue_absences}\tcost_absences: {cost_absences}\ndistributor_absences: {distributor_absences}\trating_absences: {rating_absences}\ninsertion_errors : {insertion_errors}\tduplicates_ignored : {duplicates_ignored}\t only_id_rows: {useless_objects}\nError %: {round(total_errors*100/(total_errors+successes+duplicates_ignored),3)}\tSuccess %: {round(successes*100/(total_errors+successes+duplicates_ignored),3)}')
