-- DDL for Title_Genre Intersection Table

DROP TABLE IF EXISTS Title_Genre CASCADE;
CREATE TABLE Title_Genre (
    genre SMALLINT, 
    title INTEGER,
    CONSTRAINT pk_Title_Genre PRIMARY KEY (genre, title),
    CONSTRAINT fk_Tilte_Genre_Genre FOREIGN KEY (genre) REFERENCES Genre(id),
    CONSTRAINT fk_Tilte_Genre_Title FOREIGN KEY (title) REFERENCES Title(id)
);