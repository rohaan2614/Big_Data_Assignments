CREATE table IF NOT EXISTS Popular_Movie_Actors AS (SELECT MA.actor, MA.title, avgrating, title_type
                                                    FROM title_actor MA
                                                             JOIN title t on MA.title = t.id
                                                    WHERE (avgrating > 5)
                                                      AND (title_type = 'movie'));