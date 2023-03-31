# preprocess Ratings.tsv, titleID.
# Fields of interest from title.tsv:
# 1. titleID
# 2. Title

source ./config.cfg
table=ratings
data_file_path="$data_dir/$table.tsv"

# remove alphabets from titleid
awk 'BEGIN {FS="\t"; OFS="\t"} {$1 = substr($1,3)} 1' $data_file_path > clean_data/"$table".tsv