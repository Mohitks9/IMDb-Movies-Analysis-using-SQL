#this will be segment 1
#Segment 1: Database - Tables, Columns, Relationships
#What are the different tables in the database and how are they connected to each other in the database?
#Find the total number of rows in each table of the schema.
#Identify which columns in the movie table have null values.

use imdb;
select count(*) from director_mapping;
select count(*) from genre;
select count(*) from movie;
select count(*) from `names`;
select count(*) from ratings;
select count(*) from role_mapping;

SELECT * FROM MOVIE 
WHERE ID IS NULL;

SELECT * FROM MOVIE 
WHERE TITLE IS NULL;

SELECT * FROM MOVIE 
WHERE `YEAR` IS NULL;

SELECT * FROM MOVIE 
WHERE DATE_PUBLISHED IS NULL;

SELECT * FROM MOVIE 
WHERE DURATION IS NULL;

SELECT * FROM MOVIE 
WHERE COUNTRY IS NULL;
#COUNTRY COLUMN HAVE BLANK VALUES 

SELECT * FROM MOVIE 
WHERE WORLWIDE_GROSS_INCOME IS NULL;
#WORLDWIDE_GROSS_INCOME HAVE BLANK VALUES

SELECT * FROM MOVIE 
WHERE LANGUAGES IS NULL;
#LANGUAGES HAVE BLANK VALUES

SELECT * FROM MOVIE 
WHERE PRODUCTION_COMPANY IS NULL;
#PRODUCTION_COMPANY HAVE BLANK VALUE
