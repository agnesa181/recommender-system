DROP TABLE movies;
DROP TABLE RecommendationsBasedOnTitleField;

CREATE TABLE movies (
url text, 
title text, 
ReleaseDate text, 
Distributor text, 
Starring text, 
Summary text, 
Director text, 
Genre text, 
Rating text, 
Runtime text, 
Userscore text, 
Metascore text, 
scoreCounts text );


\copy movies FROM '/home/pi/RSL/moviesFromMetacritic (1).csv' delimiter ';' csv header;

SELECT * FROM movies where url='scary-movie';

ALTER TABLE movies
ADD lexemesTitle tsvector;

UPDATE movies
SET lexemesTitle = to_tsvector(title);

SELECT url FROM movies
WHERE lexemesTitle @@ to_tsquery('scary');

ALTER TABLE movies
ADD rank float4;

UPDATE movies
SET rank = ts_rank(lexemesTitle, plainto_tsquery((SELECT title FROM movies WHERE url='scary-movie')));

CREATE TABLE RecommendationsBasedOnTitleField AS SELECT url, rank FROM movies WHERE rank > 0.001 ORDER BY rank DESC LIMIT 50;

\copy (SELECT * FROM RecommendationsBasedOnTitleField) to '/home/pi/RSL/RecommendationsBasedOnTitle.csv' WITH csv;

SELECT * FROM RecommendationsBasedOnTitleField;

