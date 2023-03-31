-- loads unique genres

\copy Genre(genre) FROM 'clean_data/genres.txt' DELIMITER E',';
