# preprocess Title.tsv, drop extra columns, int-ify ID.


source ./config.cfg
table=nameBasics
data_file_path="$data_dir/$table.tsv"

# remove columns that are not needed
awk 'BEGIN {FS="\t"; OFS="\t"} { print $1, $2, $3, $4}' $data_file_path > clean_data/"$table"1.tsv
# remove alphabets from titleid
awk 'BEGIN {FS="\t"; OFS="\t"} {$1 = substr($1,3)} 1' clean_data/"$table"1.tsv > clean_data/"$table".tsv