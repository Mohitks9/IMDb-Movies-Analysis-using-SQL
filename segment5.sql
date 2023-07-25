#Segment 5: Crew Analysis
#Identify the columns in the names table that have null values.
#Determine the top three directors in the top three genres with movies having an average rating > 8.
#Find the top two actors whose movies have a median rating >= 8.
#Identify the top three production houses based on the number of votes received by their movies.
#Rank actors based on their average ratings in Indian movies released in India.
#Identify the top five actresses in Hindi movies released in India based on their average ratings.
use imdb;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'names' 
AND TABLE_SCHEMA = 'imdb'
AND COLUMN_NAME IS not NULL
AND COLUMN_NAME NOT IN (
  SELECT COLUMN_NAME 
  FROM `names`
  WHERE COLUMN_NAME IS NOT NULL
);

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'names' 
AND TABLE_SCHEMA = 'your_database_name'
AND COLUMN_NAME IN (
  SELECT COLUMN_NAME 
  FROM `names`
  WHERE COLUMN_NAME IS NOT NULL
);
###################################################
#Determine the top three directors in the top three genres with movies having an average rating > 8.
#Find the top two actors whose movies have a median rating >= 8.
select `name` from 
`names`
join director_mapping as dir_map on dir_map.name_id = `names`.id
join ratings on ratings.movie_id = dir_map.movie_id
where ratings.median_rating >=8
group by `names`.`name`
order by count(ratings.total_votes) desc
limit 2;

#Identify the top three production houses based on the number of votes received by their movies.
select production_company,count(ratings.total_votes) as vote_count
from movie
join ratings on ratings.movie_id = movie.id
where production_company is not null
group by movie.production_company
order by vote_count desc
limit 3;

#Rank actors based on their average ratings in Indian movies released in India.
select `names`.`name` , DENSE_RANK() over(order by ratings.avg_rating desc) as `Actor_Rank`
from `names`
join role_mapping as rol_map on rol_map.name_id = `names`.id
join movie on movie.id = rol_map.movie_id
join ratings on ratings.movie_id = rol_map.movie_id
where movie.country = 'india'
and rol_map.category in ('actor');

#Identify the top five actresses in Hindi movies released in India based on their average ratings.

select `names`.`name` , DENSE_RANK() over(order by ratings.avg_rating desc) as `Actress_Rank`
from `names`
join role_mapping as rol_map on rol_map.name_id = `names`.id
join movie on movie.id = rol_map.movie_id
join ratings on ratings.movie_id = rol_map.movie_id
where movie.country = 'india'
and rol_map.category in ('actress')
and movie.languages like '%hindi%'
limit 5;


select `names`.`name` from `names` 
join role_mapping on role_mapping.name_id = `names`.id
where role_mapping.category = 'actress';
 
select name_id from role_mapping
where category like '%acterss%';

select category from role_mapping;
'acterss'

