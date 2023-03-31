-- DDL for Title_Producer

DROP TABLE IF EXISTS Title_Producer CASCADE;
CREATE TABLE Title_Producer(
    producer INTEGER, 
    title INTEGER,
    CONSTRAINT pk_Title_Producer PRIMARY KEY (producer, title),
    CONSTRAINT fk_Title_Producer_Title FOREIGN KEY  (title) REFERENCES Title(id),
    CONSTRAINT fk_Title_Producer_Producer FOREIGN KEY  (producer) REFERENCES Member(id)
);