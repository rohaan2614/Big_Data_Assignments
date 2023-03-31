# runs all modules in sequence

source ./config.cfg

# EXECUTE DDL
# bash DDL.sh

# PREPROCESS DATA
# bash data_preprocessing/Title.sh
# bash data_preprocessing/Basics.sh
# bash data_preprocessing/Genres.sh
# bash data_preprocessing/Ratings.sh
# bash data_preprocessing/Member.sh
# bash data_preprocessing/jobs.sh
# bash data_preprocessing/Characters.sh

# # LOAD DATA
# psql -d csci_620_ass_2 -a -f load_data/Genre.sql
# psql -d csci_620_ass_2 -a -f load_data/Title.sql
# bash data_preprocessing/title_genre.sh
# psql -d csci_620_ass_2 -a -f load_data/Member.sql
# psql -d csci_620_ass_2 -a -f load_data/jobs.sql
psql -d csci_620_ass_2 -a -f load_data/characters_1.sql
psql -d csci_620_ass_2 -a -f load_data/characters_2.sql