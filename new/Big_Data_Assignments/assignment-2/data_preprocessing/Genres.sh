# get & store unique genres

source ./config.cfg
table=genres
data_file_path="$data_dir/basics.tsv"
program_file_path="$program_dir/genres.py"

# get genres - do not print duplicate rows
awk 'BEGIN {FS="\t"; OFS="\t"}  !seen[$9]++ {print $9}' $data_file_path > clean_data/"$table".tsv
# un-nest array, remove duplicates 
python $program_file_path