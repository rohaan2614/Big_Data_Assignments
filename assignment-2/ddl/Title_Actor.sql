-- DDL for Title_Actor

DROP TABLE IF EXISTS Title_Actor CASCADE;
CREATE TABLE Title_Actor(
    actor INTEGER, 
    title INTEGER,
    CONSTRAINT pk_Title_Actor PRIMARY KEY (actor, title),
    CONSTRAINT fk_Title_Actor_Title FOREIGN KEY  (title) REFERENCES Title(id),
    CONSTRAINT fk_Title_Actor_Actor FOREIGN KEY  (actor) REFERENCES Member(id)
);