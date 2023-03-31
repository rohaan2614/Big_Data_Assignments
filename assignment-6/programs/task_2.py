# libraries

# %%
# libraries
import json

# constants
additional_data_file = '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-6/additional_data/extra-data.json'

with open (additional_data_file, 'r') as src_file:
    errors = 0
    successes = 0
    for line in src_file.readlines():
        try:
            data = json.loads(line)
            imdb_id = int(data['IMDb_ID']['value'][2:])
            successes += 1
        except KeyError:
            errors += 1
            print(imdb_id)
        except Exception as E:
            print('Unhandled Exception: ', E)
    print(f'Success : {successes}, Errors: {errors}, Error %: {round(errors*100/(errors+successes),3)}')

# %%
