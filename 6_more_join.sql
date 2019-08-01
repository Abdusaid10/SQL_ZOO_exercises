-- 1 List the films where the yr is 1962 [Show id, title]
SELECT id, title
 FROM movie
 WHERE yr=1962
-- 2 Give year of 'Citizen Kane'.
SELECT yr
FROM movie
where title='Citizen Kane'
-- 3 List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
-- 4 What id number does the actor 'Glenn Close' have?
SELECT id
FROM actor
WHERE name='Glenn Close'
-- 5 What is the id of the film 'Casablanca'
SELECT id
FROM movie
WHERE title='Casablanca'
-- 6 Obtain the cast list for 'Casablanca'.
-- what is a cast list?
-- The cast list is the names of the actors who were in the movie.
-- Use movieid=11768, (or whatever value you got from the previous question)
SELECT name
FROM actor JOIN casting ON(id=actorid)
WHERE movieid=11768
-- 7 Obtain the cast list for the film 'Alien'
SELECT name
FROM actor JOIN casting ON(actor.id=casting.actorid) JOIN movie ON(movie.id=casting.movieid)
WHERE title='Alien'
-- 8 List the films in which 'Harrison Ford' has appeared
SELECT title
FROM movie JOIN casting ON(movie.id=casting.movieid) JOIN actor ON(actor.id=casting.actorid)
WHERE name='Harrison Ford'
-- 9 List the films where 'Harrison Ford' has appeared - but not in the starring role.
--  [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor
--  is in the starring role]
SELECT title
FROM movie JOIN casting ON(movie.id=casting.movieid) JOIN actor ON(actor.id=casting.actorid) 
WHERE name='Harrison Ford' AND casting.ord<>1
-- 10 List the films together with the leading star for all 1962 films.
SELECT title, name
FROM movie JOIN casting ON(movie.id=casting.movieid) JOIN actor ON(actor.id=casting.actorid) 
WHERE yr=1962 AND ord=1
-- 11 Which were the busiest years for 'John Travolta', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
where name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
(SELECT yr,COUNT(title) AS c FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
 where name='John Travolta'
 GROUP BY yr) AS t
)
-- 12 List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT DISTINCT t.title, n.name 
FROM(
  SELECT movie.title, actor.name, casting.movieid
  FROM movie JOIN casting 
      ON(movie.id=casting.movieid) JOIN actor 
      ON(casting.actorid=actor.id)
      WHERE casting.ord=1
) AS n
JOIN(
     SELECT movie.title, casting.movieid
     FROM movie
          JOIN casting ON(movie.id=casting.movieid) 
          JOIN actor 
          ON(casting.actorid=actor.id)
     WHERE actor.name = 'Julie Andrews'
) AS t
ON n.movieid=t.movieid
-- 13 Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.
SELECT a.name
FROM( SELECT actor.name, COUNT(casting.movieid) count
      FROM actor JOIN casting ON(actor.id=casting.actorid)
      WHERE casting.ord=1
      GROUP BY actor.name
) AS a
WHERE count>=30
ORDER BY a.name
-- 14 List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, COUNT(*) cast
FROM movie JOIN casting ON(movie.id=casting.movieid)
WHERE movie.yr=1978
GROUP BY movie.title
ORDER BY cast DESC, title
-- 15 List all the people who have worked with 'Art Garfunkel'.
SELECT name 
FROM actor JOIN casting ON(actor.id=casting.actorid) 
           JOIN(SELECT casting.movieid
                FROM actor JOIN casting ON(actor.id = 
                     casting.actorid)
                WHERE actor.name='Art Garfunkel') AS a 
           ON casting.movieid=a.movieid
WHERE actor.name<>'Art Garfunkel'





