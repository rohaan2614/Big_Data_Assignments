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

