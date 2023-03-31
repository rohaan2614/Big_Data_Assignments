-- DDL for Genre table

DROP TABLE IF EXISTS Genre CASCADE;
CREATE TABLE Genre(
    id SERIAL PRIMARY KEY, 
    genre VARCHAR(15)
);