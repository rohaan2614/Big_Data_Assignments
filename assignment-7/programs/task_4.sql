CREATE table IF NOT EXISTS L3 AS (SELECT actor1, actor2, actor3, COUNT(actor1_movie) AS "movies"
                                  FROM (SELECT actor AS "actor1", title AS "actor1_movie"
                                        FROM popular_movie_actors) AS actor_1_alias
                                           CROSS JOIN (SELECT actor AS "actor2", title AS "actor2_movie"
                                                       FROM popular_movie_actors) AS actor_2_alias
                                           CROSS JOIN (SELECT actor AS "actor3", title AS "actor3_movie"
                                                       FROM popular_movie_actors) AS actor_3_alias
                                  WHERE (actor1 < actor2)
                                    AND (actor2 < actor3)
                                    AND (actor1_movie = actor2_movie)
                                    AND (actor2_movie = actor3_movie)
                                  GROUP BY actor1, actor2, actor3
                                  HAVING COUNT(actor1_movie) >= 5);

SELECT COUNT(*)
FROM L3;