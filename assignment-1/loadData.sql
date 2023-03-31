\c imdb;
-- Create Temporary Table to Copy Preprocess Title Data
DROP TABLE IF EXISTS temp_titles;
create table temp_titles (
    ID SERIAL PRIMARY KEY, 
    titleId VARCHAR(15),    
    ordering SMALLINT, 
    title text, 
    region VARCHAR(4), 
    language VARCHAR(3),    
    types VARCHAR(100),     
    attributes VARCHAR(100),        
    isOriginalTitle VARCHAR(2)
    );

\copy temp_titles( titleId, ordering, title, region, language, types, attributes, isOriginalTitle)  FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-1/data/title.tsv' DELIMITER E'\t' HEADER;

ALTER table temp_titles
ADD COLUMN titleidINT INTEGER;

UPDATE temp_titles
SET titleIdINT = CAST(RIGHT(titleid, LENGTH(titleid) -2) AS INTEGER);

ALTER table temp_titles
DROP COLUMN titleId;

INSERT INTO tconsts 
SELECT DISTINCT titleIdINT 
FROM temp_titles;

INSERT INTO regions
SELECT DISTINCT region            
FROM temp_titles
WHERE region is not null;

INSERT INTO langs 
SELECT DISTINCT language            
FROM temp_titles
WHERE language is not null;

-- titles table
-- faster than inserting
\copy (SELECT titleIdINT, CAST(ordering AS SMALLINT), LEFT(title, 100), region, language, CAST(isoriginaltitle AS boolean) FROM temp_titles) TO 'temp_titles.tsv' DELIMITER E'\t' HEADER;
\copy titles  FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-1/temp_titles.tsv' DELIMITER E'\t' HEADER;

-- add constraints (faster this way)
ALTER TABLE titles ADD CONSTRAINT pk_titles PRIMARY KEY (titleid, ordering);
ALTER TABLE titles ADD CONSTRAINT fk_titles_tconsts foreign key (titleid) references tconsts(tconst);

-- titleAttributes table
INSERT INTO titleAttributes
SELECT titleIdINT, ordering, types, attributes FROM temp_titles WHERE types  is not null;

ALTER TABLE titleAttributes
ADD CONSTRAINT fk_titleAttributes_typeAttributes foreign key (types) references typeAttributes(type);

DROP TABLE IF EXISTS temp_titlebasics;
create table temp_titlebasics (
    tconst VARCHAR(15),
    titleType VARCHAR(100),
    primaryTitle text,	
    originalTitle text,
    isAdult	 smallint,
    startYear smallint,
    endYear	smallint,
    runtimeMinutes	DECIMAL(7, 2),
    genres    VARCHAR(100)
    );

\copy temp_titlebasics  FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-1/data/basics.tsv' DELIMITER E'\t' HEADER;
SELECT * FROM temp_titlebasics LIMIT 10;

-- remove adult movies
DELETE FROM temp_titlebasics WHERE isAdult != 0;

-- convert movie ids to numeric
ALTER table temp_titlebasics ADD COLUMN titleidINT INTEGER;
UPDATE temp_titlebasics SET titleIdINT = CAST(RIGHT(tconst, LENGTH(tconst) -2) AS INTEGER);
ALTER table temp_titlebasics DROP COLUMN tconst;

-- faster than inserting
\copy (SELECT titleIdINT, titletype, LEFT(primarytitle, 100), LEFT(originaltitle, 100), startyear, endyear, runtimeminutes FROM temp_titlebasics) TO 'temp_titlebasics.tsv' DELIMITER E'\t' HEADER;
\copy titleBasics FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-1/temp_titlebasics.tsv' DELIMITER E'\t' HEADER;

-- update tconsts
insert into tconsts (tconst) select tconst from titlebasics on conflict (tconst) do nothing;
-- foreign key
ALTER TABLE titlebasics ADD CONSTRAINT fk_titleBasics foreign key (tconst) references tconsts(tconst) on delete cascade on update CASCADE;

-- genres table
DROP TABLE IF EXISTS Genres;
CREATE TABLE allGenres(
    genre VARCHAR(100) PRIMARY KEY);

INSERT INTO allGenres(genre) SELECT DISTINCT regexp_split_to_table(temp_titlebasics.genres, E',') AS split_genres FROM temp_titlebasics;

CREATE TABLE titleGenres ( tconst INTEGER, genre VARCHAR(100), CONSTRAINT pk_titleGenres PRIMARY KEY (tconst, genre));
INSERT INTO titlegenres SELECT temp_titlebasics.titleidint, regexp_split_to_table(temp_titlebasics.genres, E',') AS split_genres FROM temp_titlebasics;

ALTER TABLE titleGenres
ADD CONSTRAINT fk_titleGenres_tconsts FOREIGN KEY (tconst) references tconsts(tconst);

ALTER TABLE titleGenres
ADD CONSTRAINT fk_titleGenres_allGenres FOREIGN KEY (genre) references allGenres(genre);

drop table if exists temp_nameBasics CASCADE;
create table temp_nameBasics(
	nconst VARCHAR(15),
	primaryName	 text,
	birthYear smallint,
	deathYear smallint,
    -- awk command used to remove these tables prior to reading
    -- cmd: awk 'BEGIN{FS=OFS="\t"}NF=(NF-2)' nameBasics2.tsv > CLEAN.tsv
    -- primaryProfession text,
    -- knownForTitles text,
    constraint pk_temp_nameBasics primary key (nconst)	
);
select * from temp_namebasics;

\copy temp_nameBasics(nconst, primaryName, birthYear, deathYear)  FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-1/data/CLEAN.tsv' DELIMITER E'\t' HEADER;
SELECT * FROM temp_namebasics LIMIT 10;

ALTER TABLE temp_nameBasics
ADD COLUMN nidINT INTEGER;

UPDATE temp_nameBasics SET nidINT = CAST(RIGHT(nconst, LENGTH(nconst) -2) AS INTEGER);
ALTER table temp_nameBasics DROP COLUMN nconst;

SELECT * FROM temp_namebasics order by birthYear LIMIT 10 ;

\copy temp_nameBasics(nidINT, primaryName, birthYear, deathYear) TO 'temp_namebasics.tsv' DELIMITER E'\t' HEADER;
\copy nameBasics  FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-1/temp_namebasics.tsv' DELIMITER E'\t' HEADER;