# unnests genre field

# constants
data_source = r'/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/title_genres.txt'
dest_file = r'/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/unnested_title_genres.txt'

# utility function
def unnest_string(line, last_serial):
    tokens = line.split(',')
    original_serial = tokens[0]
    output = []
    i = 2
    for token in tokens[1:]:
        processed_token = token.replace('\\','')
        if (i < len(tokens)) : 
            output.append(original_serial + ' ' + processed_token + '\n')
        else :
            output.append(original_serial + ' ' + processed_token)
        last_serial += 1
        i += 1

    return last_serial, output

# processing
with open(dest_file, 'w') as unnested_txt:
    with open(data_source, 'r') as src_file:
        serial = 1
        for line in src_file.readlines():
            serial, content = unnest_string(line, serial)
            for result in content:
                # result = result[:-1]
                unnested_txt.write(result)