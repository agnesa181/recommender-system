DROP TABLE movies;
DROP TABLE RecommendationsBasedOnSummaryField;

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
ADD lexemesSummary tsvector;

UPDATE movies
SET lexemesSummary = to_tsvector(Summary);

SELECT url FROM movies
WHERE lexemesSummary @@ to_tsquery('scary');

ALTER TABLE movies
ADD rank float4;

UPDATE movies
SET rank = ts_rank(lexemesSummary, plainto_tsquery((SELECT Summary FROM movies WHERE url='scary-movie')));

CREATE TABLE RecommendationsBasedOnSummaryField AS SELECT url, rank FROM movies WHERE rank > 0.50 ORDER BY rank DESC LIMIT 50;

\copy (SELECT * FROM RecommendationsBasedOnSummaryField) to '/home/pi/RSL/RecommendationsBasedOnSummary.csv' WITH csv;

SELECT * FROM RecommendationsBasedOnSummaryField;
