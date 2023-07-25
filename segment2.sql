#Segment 2: Movie Release Trends
#Determine the total number of movies released each year and analyse the month-wise trend.
#Calculate the number of movies produced in the USA or India in the year 2019.

select count(id),`year`  from movie
group by `year`;

select count(id), month(date_published) as `Month`
from movie 
group by `Month`
order by `Month`;

select count(id) as Movie_Count from movie
where 
country in ('india','USA')
and `year` = 2019;