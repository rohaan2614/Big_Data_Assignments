-- this script exports Title_Genre table for preprocessing
\c csci_620_ass_2;
COPY (SELECT id, genres FROM interim_basics ) TO '/Users/rohaan/Desktop/Projects/RIT/CSCI_601_Intro_To_Big_Data/Big-Data-Assignments/assignment-2/clean_data/title_genres.txt' (DELIMITER(','));