-- DDL for Member Table

DROP TABLE IF EXISTS Member CASCADE;
CREATE TABLE Member (
    id INTEGER PRIMARY KEY, 
    name text, 
    birthYear SMALLINT, 
    deathYear SMALLINT
);