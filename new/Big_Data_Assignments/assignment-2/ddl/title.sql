-- ddl for title table

DROP TABLE IF EXISTS Title CASCADE;
CREATE TABLE Title (
    id INTEGER PRIMARY KEY, 
    title_type VARCHAR (50), 
    title text, 
    originalTitle text, 
    startYear CHAR(4), 
    endYear CHAR(4), 
    runtime VARCHAR(10), 
    avgRating VARCHAR(5), 
    numVotes VARCHAR(8)
);