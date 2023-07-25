#Segment 3: Production Statistics and Genre Analysis
#Retrieve the unique list of genres present in the dataset.
#Identify the genre with the highest number of movies produced overall.
#Determine the count of movies that belong to only one genre.
#Calculate the average duration of movies in each genre.
#Find the rank of the 'thriller' genre among all genres in terms of the number of movies produced

 


select distinct genre from genre;

select count(movie_id) as Movie_count,genre from genre
group by genre
order by Movie_count DESC
Limit 1;

select count(movie_id) as Movie_count,genre from genre
group by genre;

select avg(Mov.duration) as Avg_duration, gen.genre
from genre as gen
join movie as mov on mov.id =  gen.movie_id
group by gen.genre;

SELECT
  genre as `genn`,
  movie_count,
  RANK() OVER (ORDER BY movie_count DESC) AS genre_rank
FROM
  (SELECT
    gen.genre,
    COUNT(*) AS movie_count
  FROM
    genre AS gen
  JOIN
    movie AS mov
  ON
    mov.id = gen.movie_id
  GROUP BY
    gen.genre) AS genre_movie_counts
WHERE
  `genn` = 'thriller';

 