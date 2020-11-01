DROP TABLE movies;
DROP TABLE RecommendationsBasedOnStarringField;

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
ADD lexemesStarring tsvector;

UPDATE movies
SET lexemesStarring = to_tsvector(Starring);

SELECT url FROM movies
WHERE lexemesStarring @@ to_tsquery('Faris');

ALTER TABLE movies
ADD rank float4;

UPDATE movies
SET rank = ts_rank(lexemesStarring, plainto_tsquery((SELECT Starring FROM movies WHERE url='scary-movie')));

CREATE TABLE RecommendationsBasedOnStarringField AS SELECT url, rank FROM movies WHERE rank > 0.001 ORDER BY rank DESC LIMIT 50;

\copy (SELECT * FROM RecommendationsBasedOnStarringField) to '/home/pi/RSL/RecommendationsBasedOnStarring.csv' WITH csv;

SELECT * FROM RecommendationsBasedOnStarringField;

