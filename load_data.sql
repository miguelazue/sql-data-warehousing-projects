-- newbank is the schema created for the exercise
USE newbank;

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/migue/OneDrive/Documentos/GitHub/sql-data-warehousing-projects/bank-warehouse/data/account_data.csv'
INTO TABLE accounts
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW WARNINGS;


LOAD DATA LOCAL INFILE 'C:/Users/migue/OneDrive/Documentos/GitHub/sql-data-warehousing-projects/bank-warehouse/data/calendar_data.csv'
INTO TABLE calendar
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW WARNINGS;



LOAD DATA LOCAL INFILE 'C:/Users/migue/OneDrive/Documentos/GitHub/sql-data-warehousing-projects/bank-warehouse/data/customer_data.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW WARNINGS;


LOAD DATA LOCAL INFILE 'C:/Users/migue/OneDrive/Documentos/GitHub/sql-data-warehousing-projects/bank-warehouse/data/insurance_data.csv'
INTO TABLE insurance
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW WARNINGS;


LOAD DATA LOCAL INFILE 'C:/Users/migue/OneDrive/Documentos/GitHub/sql-data-warehousing-projects/bank-warehouse/data/location_data.csv'
INTO TABLE location
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW WARNINGS;


LOAD DATA LOCAL INFILE 'C:/Users/migue/OneDrive/Documentos/GitHub/sql-data-warehousing-projects/bank-warehouse/data/transfers_data.csv'
INTO TABLE transfers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW WARNINGS;


