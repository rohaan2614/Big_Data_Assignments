-- this script exports Title_Genre table for preprocessing
\c csci_620_ass_2;

DROP TABLE IF EXISTS interim_title_genre CASCADE;
CREATE TABLE interim_title_genre(
    movie_id INTEGER,
    genre_description VARCHAR(100)
);

COPY interim_title_genre(movie_id, genre_description) FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/unnested_title_genres.txt'  ( FORMAT CSV, DELIMITER(' ') );

COPY (SELECT G.id, movie_id FROM interim_title_genre JOIN genre G on G.genre = genre_description JOIN (SELECT DISTINCT id FROM title LEFT JOIN title_genre on title_genre.title=title.id) as x ON movie_id = x.id) TO '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/title_genres.txt' (DELIMITER(','));

COPY title_genre FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/title_genres.txt' (DELIMITER(','));

-- foreign key constraints
ALTER TABLE title_genre ADD CONSTRAINT fk_title_genre_genre FOREIGN KEY (genre) references genre(id);

    -- remove errorsome rows
DELETE FROM title_genre TG WHERE TG.title IN (SELECT DISTINCT TG.title FROM title_genre TG LEFT JOIN title on title.id = TG.title WHERE id IS NULL);
 
ALTER TABLE title_genre ADD CONSTRAINT fk_title_genre_title FOREIGN KEY (title) references title(id);
