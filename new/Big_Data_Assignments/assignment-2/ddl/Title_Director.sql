-- DDL for Title_Director

DROP TABLE IF EXISTS Title_Director CASCADE;
CREATE TABLE Title_Director(
    director INTEGER, 
    title INTEGER,
    CONSTRAINT pk_Title_Director PRIMARY KEY (director, title),
    CONSTRAINT fk_Title_Director_Title FOREIGN KEY  (title) REFERENCES Title(id),
    CONSTRAINT fk_Title_Director_Director FOREIGN KEY  (director) REFERENCES Member(id)
);