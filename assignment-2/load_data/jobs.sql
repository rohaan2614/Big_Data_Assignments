-- this script exports Title_Genre table for preprocessing
\c csci_620_ass_2;

DROP TABLE IF EXISTS interim_jobs CASCADE;
CREATE TABLE interim_jobs(
    movie_id INTEGER,
    person_id INTEGER,
    role VARCHAR(100)
);

COPY interim_jobs FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/principals.tsv' DELIMITER E'\t' HEADER;

    -- remove erroneous rows
DELETE FROM interim_jobs J WHERE J.movie_id IN (SELECT movie_id FROM interim_jobs J LEFT JOIN title on title.id = J.movie_id WHERE id IS NULL);

    -- title_actor to disk 
COPY (SELECT DISTINCT J.person_id, J.movie_id FROM Member M JOIN interim_jobs J ON M.id=J.person_id WHERE J.role = 'actor' OR J.role = 'actress' ) TO '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/Title_Actor.tsv' DELIMITER E'\t';
    -- populate title_actor
COPY title_actor FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/Title_Actor.tsv'  DELIMITER E'\t' ;

    -- title_writer to disk 
COPY (SELECT DISTINCT J.person_id, J.movie_id FROM Member M JOIN interim_jobs J ON M.id=J.person_id WHERE J.role = 'writer') TO '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/Title_Writer.tsv' DELIMITER E'\t';
    -- populate title_writer
COPY title_writer FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/Title_Writer.tsv'  DELIMITER E'\t' ;

    -- title_director to disk 
COPY (SELECT DISTINCT J.person_id, J.movie_id FROM Member M JOIN interim_jobs J ON M.id=J.person_id WHERE J.role = 'director') TO '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/Title_director.tsv' DELIMITER E'\t';
    -- populate title_director
COPY title_director FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/Title_director.tsv'  DELIMITER E'\t' ;

    -- title_producer to disk 
COPY (SELECT DISTINCT J.person_id, J.movie_id FROM Member M JOIN interim_jobs J ON M.id=J.person_id WHERE J.role = 'producer') TO '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/title_producer.tsv' DELIMITER E'\t';
    -- populate title_producer
COPY title_producer FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/title_producer.tsv'  DELIMITER E'\t' ;
