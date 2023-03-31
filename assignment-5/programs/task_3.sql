-- Used materialzed views to speed up processing.


-- 3.1
SELECT A.id, A.name, A.birthyear, A.deathyear --, COUNT(M.id), MIN(M.year), MAX(M.year)
FROM all_actor_mat A
JOIN all_movie_actor_mat MA
ON A.id = MA.actor
JOIN all_movie_mat M
ON M.id=MA.movie
WHERE (M.year BETWEEN 2000 AND 2005) AND
      A.deathyear IS NULL
GROUP BY A.id,A.name, A.deathyear, A.birthyear
HAVING COUNT(M.id) > 10
ORDER BY COUNT(M.id);

-- 3.2
SELECT A.id, A.name
FROM all_actor_mat A
JOIN all_movie_actor_mat MA
ON A.id = MA.actor
JOIN all_movie_mat M
ON M.id=MA.movie
WHERE (M.genre != 'Comedy') AND
      (A.name LIKE ('Ja%'))
GROUP BY  A.id, A.name;
