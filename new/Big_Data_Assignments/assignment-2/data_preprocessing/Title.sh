# preprocess Title.tsv, drop extra columns, remove duplicate rows, int-ify titleID.
# Fields of interest from title.tsv:
# 1. titleID
# 2. Title

source ./config.cfg
table=title
data_file_path="$data_dir/$table.tsv"

# remove columns that are not needed
awk 'BEGIN {FS="\t"; OFS="\t"} { print $1, $3}' $data_file_path > clean_data/"$table"1.tsv
# remove alphabets from titleid
awk 'BEGIN {FS="\t"; OFS="\t"} {$1 = substr($1,3)} 1' clean_data/"$table"1.tsv > clean_data/"$table"2.tsv
# remove duplicates based on titleid
awk 'BEGIN {FS="\t"; OFS="\t"} !seen[$1]++' clean_data/"$table"2.tsv > clean_data/"$table".tsv