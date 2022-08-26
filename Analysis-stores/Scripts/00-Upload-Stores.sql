SET GLOBAL local_infile = true;
LOAD DATA LOCAL INFILE 'D:/Gabriel/Desktop/SQL-Data-Science/Cap05/Analysis-case/archive/stores.csv' INTO TABLE stores CHARACTER SET UTF8
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;