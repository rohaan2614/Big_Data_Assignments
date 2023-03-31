-- script loads data in Title table

DROP TABLE IF EXISTS interim_title;
CREATE TABLE interim_title(
    id INTEGER PRIMARY KEY,
    title text
);

\copy interim_title FROM 'clean_data/title.tsv' DELIMITER E'\t' HEADER;

DROP TABLE IF EXISTS interim_basics;
CREATE TABLE interim_basics(
    id INTEGER PRIMARY KEY,
    type VARCHAR(50),
    originalTitle text,
    startYear SMALLINT,
    endYear SMALLINT,
    runtimeMinutes INTEGER,
    genres VARCHAR(100)
);

\copy interim_basics FROM 'clean_data/basics.tsv' DELIMITER E'\t' HEADER;

DROP TABLE IF EXISTS interim_ratings;
CREATE TABLE interim_ratings (
    id INTEGER PRIMARY KEY,
    averageRating NUMERIC(3,1),
    numVotes INTEGER
);

\copy interim_ratings FROM 'clean_data/ratings.tsv' DELIMITER E'\t' HEADER;

COPY (SELECT T.id, type, title, originalTitle, startYear, endYear, runtimeminutes AS runtime, averageRating, numVotes  FROM interim_title T JOIN interim_basics B ON T.id=B.id JOIN interim_ratings R on T.id=R.id) TO '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/title_data.tsv' CSV  HEADER DELIMITER E'\t';

\COPY title FROM 'clean_data/title_data.tsv' DELIMITER E'\t' HEADER;

UPDATE title SET startYear = NULL where (startYear = '') or (startYear = ' ');
UPDATE title SET endYear = NULL where (endYear = '') or (endYear = ' ');
UPDATE title SET runtime = NULL where (runtime = '') or (runtime = ' ');
UPDATE title SET numVotes = NULL where (numVotes = '') or (numVotes = ' ');
UPDATE title SET avgRating = NULL where (avgRating = '') or (avgRating = ' ');

ALTER TABLE title ALTER COLUMN startYear TYPE SMALLINT USING startYear::SMALLINT;
ALTER TABLE title ALTER COLUMN endYear TYPE SMALLINT USING endYear::SMALLINT;
ALTER TABLE title ALTER COLUMN runtime TYPE INTEGER USING runtime::INTEGER;
ALTER TABLE title ALTER COLUMN numVotes TYPE INTEGER USING numVotes::INTEGER;
ALTER TABLE title ALTER COLUMN avgRating TYPE DECIMAL(3,1) USING avgrating::DECIMAL(3,1);
