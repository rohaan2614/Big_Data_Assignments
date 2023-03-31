-- DO NOT RUN THIS SCRIPT IF YOU DO NOT WANT TO LOSE PREVIOUS DATA.

-- this script defines all the enum types and the tables used by the db.
-- script assumes tables either do not exists already or will be dropped. 
-- -- drop database if exists imdb;
-- create database imdb;
\c imdb;

-- enum data type
DO $$ BEGIN
    CREATE TYPE typeAttributes AS ENUM (
	    'alternative', 
	    'dvd', 
	    'festival', 
	    'tv', 
	    'video', 
	    'working', 
	    'original', 
	    'imdbDisplay',
		'imdbDisplaytv'
		null
	    ); 

EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

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
	isOriginalTitle boolean,
	check (titleID > 0),
	constraint pk_titles primary key (titleID, ordering),
	constraint fk_titles_tconst foreign key (titleID) references tconsts(tconst),
	constraint fk_titles_regions foreign key (region) references regions(region),
	constraint fk_titles_langs foreign key (lang) references langs(lang)
);
select * from titles;

drop table if exists titleAttributes ;
create table if not exists titleAttributes (
	titleID INTEGER,
	ordering SMALLINT,
	types typeAttributes DEFAULT 'N/A',
	attributes text DEFAULT 'N/A',
	check (titleID > 0),
	constraint pk_titleAttributes primary key (titleID, ordering, types, attributes),
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
	runtimeMinutes DECIMAL(5, 2),
	check (startYear between 1900 and 2025),
	check (endYear between 1900 and 2025),
	check (endYear >= startYear),
	constraint  pk_titleBasics primary key (tconst),
	check (tconst > 0),
	constraint fk_titleBasics foreign key (tconst) references tconsts(tconst) on delete cascade on update CASCADE
);
select * from titleBasics;


-- enum data type
DO $$ BEGIN
    CREATE TYPE genres AS ENUM (
	     'Action',
		 'Adult',
		 'Adventure',
		 'Animation',
		 'Biography',
		 'Comedy',
		 'Crime',
		 'Documentary',
		 'Drama',
		 'Experimental',
		 'Family',
		 'Fantasy',
		 'Film-Noir',
		 'Game-Show',
		 'History',
		 'Horror',
		 'Music',
		 'Musical',
		 'Mystery',
		 'News',
		 'Reality-TV',
		 'Romance',
		 'Sci-Fi',
		 'Short',
		 'Sport',
		 'Talk-Show',
		 'Thriller',
		 'War',
		 'Western'
	    ); 
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

drop table if exists titleGenres;
create table titleGenres (
	tconst INTEGER,
	genre genres,
	constraint pk_titleGenres primary key (tconst, genre),
	check (tconst > 0),
	constraint fk_titleGenres foreign key (tconst) references tconsts(tconst)
);
select * from titleGenres;

drop table if exists nameBasics CASCADE;
create table nameBasics(
	nconst INTEGER,
	primaryName	 VARCHAR(50),
	birthYear smallint,
	deathYear smallint,
	check (birthyear > 1900),
	check (deathYear > birthYear or deathYear is null),
	check (nconst > 0),
	constraint pk_nameBasics primary key (nconst)	
);
select * from namebasics;

drop table if exists directors;
create table directors (
	tconst INTEGER,
	director INTEGER,
	constraint pk_directors primary key (tconst, director),
	constraint fk_directors_titles foreign key (tconst) references tconsts(tconst),
	constraint fk_directors_nameBasics foreign key (director) references nameBasics (nconst)
	);
select * from directors;

drop table if exists writers;
create table writers (
	tconst INTEGER,
	writer INTEGER,
	constraint pk_writers primary key (tconst, writer),
	constraint fk_writers_titles foreign key (tconst) references tconsts(tconst),
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
