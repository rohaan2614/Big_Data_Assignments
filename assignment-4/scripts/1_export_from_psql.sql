DROP VIEW IF EXISTS aggregated_genres CASCADE;
DROP VIEW IF EXISTS aggregated_ATC CASCADE;
DROP VIEW IF EXISTS aggregated_actor_roles CASCADE;
DROP VIEW IF EXISTS aggregated_directors CASCADE;
DROP VIEW IF EXISTS aggregated_writers CASCADE;
DROP VIEW IF EXISTS aggregated_producers CASCADE;
DROP VIEW IF EXISTS movies_collection CASCADE;
CREATE VIEW aggregated_genres AS (SELECT movie, ARRAY_agg(genre) AS genres FROM movie_genres GROUP BY movie);
CREATE VIEW aggregated_ATC AS (SELECT title, actor, ARRAY_agg(C.character) AS roles  FROM actor_title_character ATC INNER JOIN character C ON C.id=ATC.character GROUP BY title, actor);
CREATE VIEW aggregated_actor_roles AS (SELECT title, json_agg(json_build_object('actor' , actor, 'roles', roles)) AS actors  FROM aggregated_atc GROUP BY title);
CREATE VIEW aggregated_directors AS (SELECT title, ARRAY_agg(director) AS directors  FROM title_director GROUP BY title);
CREATE VIEW aggregated_writers AS (SELECT title, ARRAY_agg(writer) AS writers FROM title_writer GROUP BY title);
CREATE VIEW aggregated_producers AS (SELECT title, ARRAY_agg(producer) AS producers FROM title_producer GROUP BY title);
CREATE VIEW movies_collection AS (SELECT m.id AS "_id", m.title_type AS "type", m.title, m.originaltitle, m.startyear, m.endyear, m.runtime, m.avgrating, m.numvotes, mg.genres, mg.movie, AAR.actors, AD.directors, AW.writers, AP.producers FROM title m INNER JOIN aggregated_genres mg ON mg.movie=m.id INNER JOIN aggregated_actor_roles AAR ON AAR.title=mg.movie INNER JOIN aggregated_directors AD ON AD.title=mg.movie INNER JOIN aggregated_writers AW ON AW.title=mg.movie INNER JOIN aggregated_producers AP ON AP.title=mg.movie);
\COPY (SELECT json_agg(ROW_TO_JSON(t)) FROM (SELECT * FROM movies_collection) t) TO '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-4/movies.json';
\COPY (SELECT json_agg(ROW_TO_JSON(t)) FROM (SELECT id AS "_id", name, birthYear, deathYear FROM member) t) TO '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-4/members.json';
