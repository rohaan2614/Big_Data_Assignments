-- DDL for Title_Writer

DROP TABLE IF EXISTS Title_Writer CASCADE;
CREATE TABLE Title_Writer(
    writer INTEGER, 
    title INTEGER,
    CONSTRAINT pk_Title_Writer PRIMARY KEY (writer, title),
    CONSTRAINT fk_Title_Writer_Title FOREIGN KEY  (title) REFERENCES Title(id),
    CONSTRAINT fk_Title_Writer_Writer FOREIGN KEY  (writer) REFERENCES Member(id)
);