-- S1
DROP VIEW IF EXISTS ComedyMovie;
CREATE VIEW ComedyMovie AS (
    SELECT DISTINCT t.id, t.title, t.startyear as "year"
    FROM title t
        INNER JOIN movie_genres mg
            ON t.id=mg.movie
    WHERE (mg.genre='Comedy') AND
           (t.runtime > 75));

DROP MATERIALIZED VIEW  IF EXISTS  ComedyMovie_MAT CASCADE;
CREATE MATERIALIZED VIEW ComedyMovie_MAT AS (
    SELECT DISTINCT t.id, t.title, t.startyear as "year"
    FROM title t
        INNER JOIN movie_genres mg
            ON t.id=mg.movie
    WHERE (mg.genre='Comedy') AND
           (t.runtime > 75));

SELECT * FROM ComedyMovie LIMIT 5;
SELECT * FROM ComedyMovie_MAT LIMIT 10;

-- S2
DROP VIEW IF EXISTS NonComedyMovie;
CREATE  VIEW NonComedyMovie AS (
    SELECT t.id, t.title, t.startyear AS "year"
    FROM title t
        LEFT JOIN ComedyMovie_MAT
            ON t.id=ComedyMovie_MAT.id
    WHERE (ComedyMovie_MAT.id IS NULL) AND
           (t.runtime > 75));

DROP MATERIALIZED VIEW IF EXISTS NonComedyMovie_MAT;
CREATE MATERIALIZED VIEW NonComedyMovie_MAT AS (
    SELECT * FROM NonComedyMovie);

SELECT * FROM NonComedyMovie LIMIT 5;
SELECT * FROM NonComedyMovie_MAT LIMIT 10;

-- S3
DROP VIEW IF EXISTS ComedyActor CASCADE;
CREATE VIEW ComedyActor AS (
    SELECT DISTINCT ON (M.id) M.id, M.name, M.birthyear, M.deathyear
    FROM member M
        INNER JOIN title_actor ta
            on M.id = ta.actor
        INNER JOIN ComedyMovie_MAT s1mv
            on ta.title = s1mv.id
        INNER JOIN movie_genres mg
            on mg.movie=s1mv.id);

DROP MATERIALIZED VIEW IF EXISTS ComedyActor_MAT;
CREATE MATERIALIZED VIEW  ComedyActor_MAT AS (
    SELECT * FROM ComedyActor);

SELECT * FROM ComedyActor LIMIT 5;
SELECT * FROM ComedyActor_MAT LIMIT 10;

-- S4
DROP VIEW IF EXISTS NonComedyActor;
CREATE VIEW NonComedyActor AS (
    SELECT M.id, M.name, M.birthyear, M.deathyear
    FROM member M
        LEFT JOIN ComedyActor_MAT
            ON ComedyActor_MAT.id = M.id
        WHERE ComedyActor_MAT.id IS NULL);

DROP MATERIALIZED VIEW IF EXISTS NonComedyActor_MAT;
CREATE MATERIALIZED VIEW NonComedyActor_MAT AS (
    SELECT *
    FROM NonComedyActor
);

SELECT * FROM NonComedyActor LIMIT 10;
SELECT * FROM NonComedyActor_MAT LIMIT 10;

-- S5
DROP VIEW IF EXISTS ActedIn;
CREATE VIEW ActedIn AS (
    SELECT TA.actor, TA.title AS "movie"
    FROM title_actor TA
    INNER JOIN (SELECT * FROM ComedyMovie UNION SELECT * FROM NonComedyMovie) AS M
    ON M.id = TA.title
    GROUP BY TA.actor, TA.title);

DROP MATERIALIZED VIEW IF EXISTS ActedIn_MAT;
CREATE MATERIALIZED VIEW  ActedIn_MAT AS (
    SELECT *
    FROM ActedIn);
SELECT * FROM ActedIn LIMIT 15;
SELECT * FROM ActedIn_MAT LIMIT 15;