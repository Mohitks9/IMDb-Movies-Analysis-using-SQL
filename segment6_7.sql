#Segment 6: Broader Understanding of Data
#Classify thriller movies based on average ratings into different categories.
#analyse the genre-wise running total and moving average of the average movie duration.
#Identify the five highest-grossing movies of each year that belong to the top three genres.
#Determine the top two production houses that have produced the highest number of hits among multilingual movies.
#Identify the top three actresses based on the number of Super Hit movies (average rating > 8) in the drama genre.
#Retrieve details for the top nine directors based on the number of movies, including average inter-movie duration, ratings, and more.
use imdb;

select movie.id,movie.title, 
CASE 
when ratings.avg_Rating >8 then 'Blockbaster'
when ratings.avg_Rating <=8 and ratings.avg_Rating >5 then 'SUPER_HIT'
when ratings.avg_Rating <=5 and ratings.avg_rating >3 then 'HIT'
when ratings.avg_rating <=3 then 'fine'
END as `cateorgy`

from movie
join ratings on ratings.movie_id = movie.id
join genre on genre.movie_id = movie.id
where genre.genre in ('thriller');

#analyse the genre-wise running total and moving average of the average movie duration.

SELECT genre.genre, 
       AVG(mov.duration) OVER (PARTITION BY genre.genre ORDER BY mov.duration) AS genre_avg_duration,
       SUM(AVG(duration)) OVER (PARTITION BY genre.genre ORDER BY mov.duration) AS genre_running_total
FROM (
    SELECT genre, 
           duration,
           AVG(duration) OVER (PARTITION BY genre) AS avg_duration
    FROM movie
    GROUP BY genre, duration
) AS subquery;

select genre.genre, avg(mov.duration) as avg_duration
from movie as mov
join genre on genre.movie_id = mov.id
group by genre.genre
order by avg_duration;

select genre.genre, sum(mov.duration) as total_duration
from movie as mov
join genre on genre.movie_id = mov.id
group by genre.genre
order by total_duration;

#Identify the five highest-grossing movies of each year that belong to the top three genres.
WITH TopGenres AS (
    SELECT genre.genre, 
           RANK() OVER (ORDER BY SUM(ratings.total_votes) DESC) AS genre_rank
    FROM genre
    join ratings on ratings.movie_id = genre.movie_id
    GROUP BY genre
),
RankedMovies AS (
    SELECT movie.title, genre.genre, movie.worlwide_gross_income,
           RANK() OVER (PARTITION BY genre.genre ORDER BY movie.worlwide_gross_income DESC) AS movie_rank
    FROM movie
    JOIN ratings ON movie.id = ratings.movie_id
    join genre on genre.movie_id = movie.id
    WHERE (genre.genre) IN (
        SELECT genre
        FROM TopGenres
        WHERE genre_rank <= 3
    )
)
SELECT title, genre, worlwide_gross_income
FROM RankedMovies
WHERE movie_rank <= 5
ORDER BY genre, worlwide_gross_income DESC;

#Determine the top two production houses that have produced the highest number of hits among multilingual movies.
WITH MovieHits AS (
    SELECT m.production_company, COUNT(*) AS hit_count,m.languages
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    WHERE r.avg_rating > 8 
    GROUP BY m.production_company
    HAVING count(m.languages) >1 
),
RankedHits AS (
    SELECT production_company, hit_count,languages,
           RANK() OVER (ORDER BY hit_count DESC) AS production_house_rank
    FROM MovieHits
)
SELECT production_company, hit_count
FROM RankedHits
WHERE production_house_rank <= 2
and production_company is not null;

#Identify the top three actresses based on the number of Super Hit movies (average rating > 8) in the drama genre.
WITH DramaSuperHits AS (
    SELECT m.id, COUNT(*) AS super_hit_count
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    join genre on genre.movie_id = m.id
    WHERE genre.genre = 'drama' AND r.avg_rating > 8
    GROUP BY m.id
),
MovieActresses AS (
    SELECT ro.name_id, a.`name`,ro.movie_id
    FROM role_mapping as ro
    JOIN `names` as a ON ro.name_id = a.id
    where ro.category in ('actress')
)
SELECT ma.`name`, COUNT(*) AS super_hit_count
FROM DramaSuperHits d
JOIN MovieActresses ma ON d.id = ma.movie_id
GROUP BY ma.`name`
ORDER BY super_hit_count DESC
LIMIT 3;

#Retrieve details for the top nine directors based on the number of movies, including average inter-movie duration, ratings, and more.
WITH DirectorMovies AS (
    SELECT director_mapping.name_id, COUNT(*) AS movie_count,
           AVG(m.duration) AS avg_inter_movie_duration,
           AVG(r.avg_rating) AS avg_rating
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    join director_mapping on director_mapping.movie_id = m.id
    GROUP BY name_id
),
RankedDirectors AS (
    SELECT name_id, movie_count, avg_inter_movie_duration, avg_rating,
           RANK() OVER (ORDER BY movie_count DESC) AS director_rank
    FROM DirectorMovies
)
SELECT d.`name`, rd.movie_count, rd.avg_inter_movie_duration, rd.avg_rating
FROM RankedDirectors rd
JOIN `names` d ON rd.name_id = d.id
WHERE director_rank <= 9
ORDER BY director_rank;


#segment 7:
#based on above analyze Action genre have highest revenu and hit count.