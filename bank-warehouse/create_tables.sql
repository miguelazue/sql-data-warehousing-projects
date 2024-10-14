-- newbank is the schema created for the exercise
USE newbank;

CREATE TABLE accounts (
    account_id BIGINT PRIMARY KEY,
    customer_id BIGINT,
    created_date DATE,
    status VARCHAR(128),
    account_number VARCHAR(128)
);

CREATE TABLE calendar (
    date DATE PRIMARY KEY,
    year INT,
    month INT,
    day INT,
    quarter INT
);


CREATE TABLE customers (
    customer_id BIGINT PRIMARY KEY, 
    location_id BIGINT,
    first_name VARCHAR(128),
    last_name VARCHAR(128)
);



CREATE TABLE insurance (
    insurance_id BIGINT PRIMARY KEY, 
    customer_id BIGINT,
    created_date DATE,
    policy_number VARCHAR(128),
    coverage_amount FLOAT
);


CREATE TABLE location (
    location_id BIGINT PRIMARY KEY,
    country VARCHAR(128),
    city VARCHAR(256)
);



CREATE TABLE transfers (
    id BIGINT PRIMARY KEY,
    account_id BIGINT,
    transaction_type VARCHAR(128),
    amount FLOAT,
    transaction_requested_date DATE,
    transaction_requested_at TIMESTAMP,
    status VARCHAR(128)
);

-- Partition by Year
/*
CREATE TABLE transfers (
    id BIGINT PRIMARY KEY,
    account_id BIGINT,
    transaction_type VARCHAR(128),
    amount FLOAT,
    transaction_requested_date DATE,
    transaction_requested_at TIMESTAMP,
    status VARCHAR(128)
)
PARTITION BY RANGE (YEAR(transaction_requested_date)) (
    PARTITION p2020 VALUES LESS THAN (2021),
    PARTITION p2021 VALUES LESS THAN (2022),
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2025 VALUES LESS THAN (2025),
    PARTITION p_max VALUES LESS THAN MAXVALUE  -- For future dates
);
*/

-- Indexing by IDs frequently used in joins

CREATE UNIQUE INDEX idx_customer_id ON customers (customer_id);
CREATE UNIQUE INDEX idx_account_id ON accounts (account_id);

-- Create index on orders table
CREATE INDEX idx_customer_id ON accounts (customer_id);
CREATE INDEX idx_account_id ON transfers (account_id);

