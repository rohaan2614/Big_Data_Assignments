# drop extra columns, int-ify ID.


source ./config.cfg
table=principals
data_file_path="$data_dir/$table.tsv"

# remove columns that are not needed
awk 'BEGIN {FS="\t"; OFS="\t"} { print $1, $3, $4}' $data_file_path > clean_data/"$table"1.tsv
echo "removed extra columns"
# remove alphabets from titleid
awk 'BEGIN {FS="\t"; OFS="\t"} {$1 = substr($1,3)} 1' clean_data/"$table"1.tsv > clean_data/"$table"2.tsv
echo "intifyied movie id"
# remove alphabets from nameId
awk 'BEGIN {FS="\t"; OFS="\t"} {$2 = substr($2,3)} 1' clean_data/"$table"2.tsv > clean_data/"$table".tsv
echo "intifyied principal name id"