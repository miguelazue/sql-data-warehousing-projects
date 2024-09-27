-- nubank is the schema created for the exercise
USE newbank;

CREATE TABLE accounts (
    account_id BINARY(16) PRIMARY KEY, -- UUID stored as binary
    customer_id BINARY(16),
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
    customer_id BINARY(16) PRIMARY KEY, -- UUID stored as binary
    location_id BINARY(16),
    first_name VARCHAR(128),
    last_name VARCHAR(128)
);



CREATE TABLE insurance (
    insurance_id BINARY(16) PRIMARY KEY, -- UUID stored as binary
    customer_id BINARY(16),
    created_date DATE,
    policy_number VARCHAR(128),
    coverage_amount FLOAT
);


CREATE TABLE location (
    location_id BINARY(16) PRIMARY KEY, -- UUID stored as binary
    country VARCHAR(128),
    city VARCHAR(256)
);


CREATE TABLE transfers (
    id BINARY(16) PRIMARY KEY, -- UUID stored as binary
    account_id BINARY(16),
    transaction_type VARCHAR(128),
    amount FLOAT,
    transaction_requested_date DATE,
    transaction_requested_at TIMESTAMP,
    status VARCHAR(128)
);

