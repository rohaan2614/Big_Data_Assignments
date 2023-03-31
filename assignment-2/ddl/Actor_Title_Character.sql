-- DDL for Actor_Title_Character

DROP TABLE IF EXISTS Actor_Title_Character CASCADE;
CREATE TABLE Actor_Title_Character(
    title INTEGER,
    actor INTEGER, 
    character INTEGER,
    CONSTRAINT pk_ATC PRIMARY KEY (actor, title, character)
);