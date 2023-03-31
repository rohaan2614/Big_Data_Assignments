
DROP VIEW IF EXISTS long_movies;
CREATE VIEW long_movies AS 
    SELECT * 
    FROM title 
    WHERE runtime >= 90;

CREATE VIEW movie_genres AS SELECT TG.genre AS "genreid", G.genre, TG.title AS movie  FROM title_genre TG INNER JOIN genre G ON G.id=TG.genre;


CREATE TABLE task_1 (
    movieId INTEGER, 
    type character varying(50), 
    startYear SMALLINT, 
    runtime INTEGER, 
    avgRating numeric(3,1), 
    genreId integer, 
    genre character varying(15) , 
    memberId integer, 
    birthYear SMALLINT, 
    character INTEGER,
    CONSTRAINT pk_task_1 PRIMARY KEY (movieId, memberId, genreId, character),
    CONSTRAINT pk_task_1_title FOREIGN KEY (movieId) REFERENCES title(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT pk_task_1_member FOREIGN KEY (memberId) REFERENCES member(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT pk_task_1_genre FOREIGN KEY (genreId) REFERENCES genre(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT pk_task_1_character FOREIGN KEY (character) REFERENCES character(id) ON DELETE CASCADE ON UPDATE CASCADE


);

CREATE VIEW single_character_actor_movies AS SELECT title FROM actor_title_character GROUP BY title HAVING COUNT(actor) = COUNT(character);

CREATE VIEW actor_character_info_task_1 AS SELECT SCAMs.title, ATC.actor AS memberId, M.birthyear, ATC.character FROM actor_title_character ATC INNER JOIN single_character_actor_movies SCAMs ON ATC.title = SCAMs.title INNER JOIN member M ON ATC.character=M.id;

CREATE VIEW ACIT_MG AS SELECT MG.genreid, MG.genre, ACIT.title, ACIT.memberid, ACIT.birthyear, ACIT.character FROM actor_character_info_task_1 ACIT INNER JOIN movie_genres MG ON ACIT.title=MG.movie;          

\COPY (SELECT movieid, type, startyear, runtime, avgrating, genreid, genre, memberid, birthyear, character FROM long_movies LM INNER JOIN ACIT_MG ON LM.movieid=ACIT_MG.title) TO '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-3/task_1.tsv' DELIMITER E'\t' HEADER;

\COPY task_1 FROM '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-3/task_1.tsv' DELIMITER E'\t' HEADER;