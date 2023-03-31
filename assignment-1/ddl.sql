-- DO NOT RUN THIS SCRIPT IF YOU DO NOT WANT TO LOSE PREVIOUS DATA.

-- this script defines all the enum types and the tables used by the db.
-- script assumes tables either do not exists already or will be dropped. 
-- -- drop database if exists imdb;
-- create database imdb;
\c imdb;

-- enum data type
drop table if exists tconsts CASCADE;
create table tconsts (
	tconst INT PRIMARY KEY
);
SELECT * FROM tconsts;

drop table if exists regions;
create table regions (
	region VARCHAR(4) PRIMARY KEY
);

drop table if exists langs;
create table langs (
	lang VARCHAR(3) PRIMARY KEY
);

drop table if exists titles cascade;
create table titles (
	titleID INTEGER,
	ordering SMALLINT,  
	title VARCHAR(100), -- trim whle populating this
	region VARCHAR(4),
	lang VARCHAR(3), 
	isOriginalTitle boolean
);
select * from titles;

DROP TABLE IF EXISTS typeAttributes;
CREATE TABLE typeAttributes (
    type VARCHAR(15) PRIMARY KEY
);


INSERT INTO typeAttributes
VALUES  ('alternative'), 
 		('dvd'), 
        ('festival'), 
	     ('tv'), 
	     ('video'), 
	     ('working'), 
	     ('original'), 
	     ('imdbDisplay');

SELECT * FROM typeAttributes;

DROP TABLE IF EXISTS titleAttributes;
create table if not exists titleAttributes (
	titleID INTEGER,
	ordering SMALLINT,
	types VARCHAR(50),
	attributes text,
	constraint pk_titleAttributes primary key (titleID, ordering, types),
	constraint fk_titleAttributes foreign key (titleID, ordering) references titles(titleID, ordering)	
);
select * from titleAttributes;

-- enum data type
DO $$ BEGIN
    CREATE TYPE titleTypes AS ENUM (
	 'movie',
	 'short',
	 'titleType',
	 'tvEpisode',
	 'tvMiniSeries',
	 'tvMovie',
	 'tvPilot',
	 'tvSeries',
	 'tvShort',
	 'tvSpecial',
	 'video',
	 'videoGame'
    ); 

EXCEPTION
    WHEN duplicate_object THEN null;
END $$;
 
drop table if exists titleBasics CASCADE;
create table titleBasics (
	tconst INTEGER,
	titleType titleTypes,
	primaryTitle VARCHAR(100),
	originalTitle VARCHAR(100),
	startYear smallint default 0,
	endYear smallint default 0,
	runtimeMinutes DECIMAL(7, 2),
	constraint  pk_titleBasics primary key (tconst)
	);
select * from titleBasics;


drop table if exists nameBasics CASCADE;
create table nameBasics(
	nconst INTEGER,
	primaryName	 text,
	birthYear smallint,
	deathYear smallint,
	constraint pk_nameBasics primary key (nconst)	
);
select * from namebasics;

drop table if exists directors;
create table directors (
	tconst INTEGER,
	director INTEGER,
	constraint pk_directors primary key (tconst, director),
	-- constraint fk_directors_titles foreign key (tconst) references tconsts(tconst),
	constraint fk_directors_nameBasics foreign key (director) references nameBasics (nconst)
	);
select * from directors;

drop table if exists writers;
create table writers (
	tconst INTEGER,
	writer INTEGER,
	constraint pk_writers primary key (tconst, writer),
	-- constraint fk_writers_titles foreign key (tconst) references tconsts(tconst),
	constraint fk_writers_nameBasics foreign key (writer) references nameBasics (nconst)
	);
select * from writers;

drop table if exists episodes;
create table episodes (
	tconst INTEGER,
	parentTconst INTEGER,
	seasonNumber SMALLINT,
	episodeNumber smallint,
	check (tconst > 0),
	check (seasonNumber > 0),
	check (episodeNumber > 0),
	constraint pk_episodes primary key (tconst),
	constraint fk_episodes foreign key (parentTconst) references tconsts(tconst)
);
select * from EPISODES;

drop table if exists ratings;
create table ratings(
	tconst INTEGER,
	averageRatings NUMERIC(2,1),
	numVotes smallint,
	check (tconst > 0),
	check (averageRatings > 0),
	check (numVotes > 0),
	constraint pk_ratings primary key (tconst),
	constraint fk_ratings foreign key (tconst) references tconsts(tconst)
);
select * from ratings;

-- enum data type
DO $$ BEGIN
    CREATE TYPE principalCategory AS ENUM (
	    'actor',
	    'actress',
	    'archive_footage',
	    'archive_sound',
	    'category',
	    'cinematographer',
	    'composer',
	    'director',
	    'editor',
	    'producer',
	    'production_designer',
	    'self',
	    'writer'
	    ); 
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;


drop table if exists principals;
create table principals (
	tconst	INTEGER,
	ordering smallint,
	nconst	INTEGER,
	category principalCategory,
	constraint pk_principals primary key (tconst),
	constraint fk_principals_titles foreign key (tconst) references tconsts(tconst),
	constraint fk_principals_nameBasics foreign key (nconst) references nameBasics(nconst)
);
select * from principals;
