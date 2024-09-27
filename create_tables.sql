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

