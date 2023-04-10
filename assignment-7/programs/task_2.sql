CREATE table IF NOT EXISTS L1 AS (SELECT actor AS actor1, COUNT(actor)
                                  from popular_movie_actors PMA
                                  GROUP BY actor
                                  HAVING COUNT(actor) >= 5);