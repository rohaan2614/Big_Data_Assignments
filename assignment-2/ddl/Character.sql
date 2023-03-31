-- DDL for character table

DROP TABLE IF EXISTS Character CASCADE;
CREATE TABLE Character(
    id SERIAL PRIMARY KEY,
    character text
);