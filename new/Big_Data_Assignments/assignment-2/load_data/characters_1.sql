-- this script exports Title_Genre table for preprocessing
\c csci_620_ass_2;

DROP TABLE IF EXISTS interim_characters CASCADE;
CREATE TABLE interim_characters(
    movie_id INTEGER,
    person_id INTEGER,
    character text
);

\COPY interim_characters FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/characters.tsv' DELIMITER E'\t' HEADER;

    -- remove errorsome rows
COPY (SELECT IJ.movie_id AS title, IJ.person_id AS actor, character FROM interim_characters IC JOIN interim_jobs IJ on IJ.movie_id = IC.movie_id AND IJ.person_id = IC.person_id WHERE character IS NOT NULL) TO '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/characters.tsv' DELIMITER E'\t' HEADER;