# libraries

# %%
# libraries
import json

# constants
additional_data_file = '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-6/additional_data/extra-data.json'

with open (additional_data_file, 'r') as src_file:
    successes = 0
    id_errors = 0
    revenue_errors = 0
    cost_errors = 0
    distributor_errors = 0
    rating_errors = 0
    for line in src_file.readlines():
        try:
            # load json
            data = json.loads(line)
            # identify key json fields
            restructured_data = {}
            try:
                restructured_data['_id'] = int(data['IMDb_ID']['value'][2:])
            except KeyError:
                    id_errors += 1
            try:
                restructured_data['revenue'] = float(data['box_office']['value'])
            except KeyError:
                    revenue_errors += 1
            try:
                restructured_data['cost'] = float(data['cost']['value'])
            except KeyError:
                    cost_errors += 1
            try:
                restructured_data['distributor'] = data['distributorLabel']['value']
            except KeyError:
                 distributor_errors += 1
            try:
                restructured_data['rating'] = data['MPAA_film_ratingLabel']['value']
            except KeyError:
                    rating_errors += 1 
            if len(restructured_data.keys()) == 5 :
                successes += 1
        except Exception as E:
            print('Unhandled Exception: ', E)
    total_errors = id_errors + revenue_errors + cost_errors +distributor_errors +rating_errors
    print(f'Successes : {successes}, \nid_errors: {id_errors}\trevenue_errors: {revenue_errors}\tcost_errors: {cost_errors}\ndistributor_errors: {distributor_errors}\t\trating_errors: {rating_errors}\n Error %: {round(total_errors*100/(total_errors+successes),3)}')

# %%
