-- this script exports Title_Genre table for preprocessing
\c csci_620_ass_2;


\COPY interim_characters FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/unnested_characters.tsv' DELIMITER E'\t' HEADER;

DELETE FROM interim_characters WHERE character IS NULL;

UPDATE interim_characters SET character = LTRIM(character, '["');

UPDATE interim_characters SET character = RTRIM(character, '"]');

UPDATE interim_characters SET character = REPLACE(character, '"','');

\COPY (SELECT DISTINCT character FROM interim_characters) TO '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/characters.tsv' DELIMITER E'\t' HEADER;

\COPY Character(character) FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/characters.tsv' DELIMITER E'\t' HEADER;

\COPY (SELECT DISTINCT IC.person_id AS actor, IC.movie_id AS title, C.id AS "Character" FROM interim_characters IC INNER JOIN Character C ON IC.character=C.character INNER JOIN title_actor TA ON IC.person_id=TA.actor AND IC.movie_id=TA.title) TO '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/actor_title_character.tsv' DELIMITER E'\t' HEADER;

\COPY actor_title_character FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/actor_title_character.tsv' DELIMITER E'\t' HEADER;
