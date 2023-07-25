#Segment 4: Ratings Analysis and Crew Members
#Retrieve the minimum and maximum values in each column of the ratings table (except movie_id).
#Identify the top 10 movies based on average rating.
#Summarise the ratings table based on movie counts by median ratings.
#Identify the production house that has produced the most number of hit movies (average rating > 8).
#Determine the number of movies released in each genre during March 2017 in the USA with more than 1,000 votes.
#Retrieve movies of each genre starting with the word 'The' and having an average rating > 8.
use imdb;

select 
min(avg_rating) as `MIN_AVG_RATING_`,
max(avg_rating) as `MAX_AVG_RATING`,
min(total_votes) as `MIN_TOTAL_VOTES`,
max(total_votes) as `MAX_TOTAL_VOTES`,
min(median_rating) as `MIN_MEDIAN_RATING`,
max(median_rating) as `MAX_MEDIAN_RATING`
from ratings;

select movie_id from ratings 
order by avg_rating desc
limit 10;

select count(movie_id),median_rating from ratings
group by median_rating
order by median_rating desc;

#Identify the production house that has produced the most number of hit movies (average rating > 8).
select DISTINCT production_company
from movie
join ratings on ratings.movie_id = movie.id
where ratings.avg_rating >8
and movie.production_company is not null;

#Determine the number of movies released in each genre during March 2017 in the USA with more than 1,000 votes.

SELECT COUNT(mov.id) AS movie_count, gen.genre
FROM movie AS mov
JOIN genre AS gen ON mov.id = gen.movie_id
JOIN RATINGS ON RATINGS.MOVIE_ID = MOV.ID
WHERE mov.`year` = 2019 AND MONTH(mov.date_published) = 3 AND RATINGS.TOTAL_VOTES >1000
GROUP BY gen.genre;

#Retrieve movies of each genre starting with the word 'The' and having an average rating > 8.
select title, gen.genre from `movie`
join ratings on ratings.movie_id = movie.id
join genre as gen on gen.movie_id = movie.id
where title like 'the%' and ratings.avg_rating > 8;
