source_dir = '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/characters.tsv'
dest_dir = '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/unnested_characters.tsv'

with open(dest_dir, 'w') as dest_file:
    with open(source_dir, 'r') as src_file:
        i = 0
        for line in src_file.readlines():
            cols = line.split("\t")
            movie = cols[0]
            person = cols[1]
            charac = cols[-1]
            # remove extra characters
            charac = charac.replace("[","")
            charac = charac.replace("]","")
            charac = charac.replace("\n","")
            charac = charac.replace("\\N","")
            charac = charac.replace('"',"")
            charac = charac.strip()

            for char in charac.split(","):
                dest_file.write(movie + '\t' + person + '\t' +  char + "\n")
            # if len(charac) != 0 :
            #     characs = charac.split(",")

            # dest_file.write(movie + '\t' + person + '\t' +  characs[0] + "\n")
            # print(movie, person, characs)
            # if i== 10: break