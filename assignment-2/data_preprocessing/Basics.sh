# preprocess Title.tsv, drop extra columns & Adult films, remove int-ify titleID.
# Fields of interest from title.tsv:
# 1. tconst
# 2. titleType	
# 3. originalTitle	
# 4. isAdult	
# 5. startYear	
# 6. endYear	
# 7. runtimeMinutes	
# 8. genres

source ./config.cfg
table=basics
data_file_path="$data_dir/$table.tsv"

# remove extra columns, adult films and alphabets from titleID
awk 'BEGIN {FS="\t"; OFS="\t"} $5 == "1" { next } { print substr($1,3), $2, $4, $6, $7, $8, $9}' $data_file_path > clean_data/"$table".tsv
