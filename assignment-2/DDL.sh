# runs all table scripts to create tables.

source ./config.cfg
# echo $superuser_username
# echo $postgres_name
# echo $db_name

# CREATE NEW DB
# open postgres to create assignment db
psql -U $superuser_username -d $postgres_name -c "DROP DATABASE IF EXISTS $db_name; "
psql -U $superuser_username -d $postgres_name -c "CREATE DATABASE $db_name; "

# CREATE TABLES
psql -U $superuser_username -d $db_name -a -f ddl/Title.sql
psql -U $superuser_username -d $db_name -a -f ddl/Genre.sql
psql -U $superuser_username -d $db_name -a -f ddl/Title_Genre.sql
psql -U $superuser_username -d $db_name -a -f ddl/Member.sql
psql -U $superuser_username -d $db_name -a -f ddl/Title_Actor.sql
psql -U $superuser_username -d $db_name -a -f ddl/Title_Writer.sql
psql -U $superuser_username -d $db_name -a -f ddl/Title_Producer.sql
psql -U $superuser_username -d $db_name -a -f ddl/Title_Director.sql
psql -U $superuser_username -d $db_name -a -f ddl/Character.sql
psql -U $superuser_username -d $db_name -a -f ddl/Actor_Title_Character.sql