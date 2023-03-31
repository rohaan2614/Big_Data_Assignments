source ./config.cfg
program_file_path="$program_dir/title_genre.py"

# export data
psql -d $postgres_name -a -f load_data/Title_Genre_1.sql
# # process data
python $program_file_path
# import data to db
psql -d $postgres_name -a -f load_data/Title_Genre_2.sql