CREATE table IF NOT EXISTS L2 AS (
    SELECT actor1, actor2, COUNT(actor1_movie) AS "movies"
    FROM ( SELECT actor AS "actor1", title AS "actor1_movie"
    FROM popular_movie_actors) AS actor_1_alias
    CROSS JOIN (
                SELECT actor AS "actor2", title AS "actor2_movie"
                FROM popular_movie_actors) AS actor_2_alias
    WHERE (actor1 < actor2) AND (actor1_movie = actor2_movie)
    GROUP BY actor1, actor2
                               );