-- newbank is the schema created for the exercise
USE newbank;

-- The first accounts that were created, use of LIMIT and ORDER BY
SELECT *
FROM accounts
ORDER BY created_date ASC
LIMIT 5;

-- Number of accounts that were created this year, use of COUNT and WHERE 
SELECT COUNT(*) AS n_accounts_created_2024
FROM accounts
WHERE created_date >= "2024-01-01";

-- Extract the transferes that were done between 3 am and 6 am in August of 2024, use of HOUR, YEAR, MONTH, BETWEEN AND
SELECT *
FROM transfers
WHERE HOUR(transaction_requested_at) BETWEEN 3 AND 5
AND YEAR(transaction_requested_at) = 2024
AND MONTH(transaction_requested_at) = 8;


-- The last balance of each account, use of CASE WHEN, SUM and GROUP BY 
SELECT account_id,
SUM(CASE WHEN transaction_type = "deposit" THEN AMOUNT ELSE 0 END ) AS deposit_sum,
SUM(CASE WHEN transaction_type = "withdrawal" THEN AMOUNT ELSE 0 END ) AS withdrawal_sum,
SUM(CASE WHEN transaction_type = 'deposit' THEN amount ELSE 0 END) - SUM(CASE WHEN transaction_type = 'withdrawal' THEN amount ELSE 0 END) AS balance
FROM transfers
GROUP BY account_id;

-- Customers that have more than 2 insurance, use of HAVING
SELECT customer_id, COUNT(*) AS n_insurance
FROM insurance
GROUP BY customer_id
HAVING n_insurance>2;

-- Date of the first and last transfer fir each account, use of MIN and MAX
SELECT account_id, MIN(transaction_requested_date) AS first_transfer, MAX(transaction_requested_date) AS last_transfer
FROM transfers
GROUP BY account_id
ORDER BY account_id ASC
;

-- Average coverage amount of the insurance, use of AVG and ROUND
SELECT ROUND(AVG(coverage_amount),0) AS avg_coverage_amount
FROM insurance;


-- number of customers by location, use of JOINS
SELECT location.country,location.city, COUNT(customers.customer_id) AS n_customers
FROM location
LEFT JOIN customers ON location.location_id = customers.location_id
GROUP BY location.country,location.city
ORDER BY n_customers DESC;

-- number of insurance created per year, use of Joins
SELECT calendar.year, COUNT(insurance_id) n_insurance
FROM insurance
LEFT JOIN calendar ON insurance.created_date = calendar.date
GROUP BY calendar.year
ORDER BY calendar.year ASC;

-- number of transfers done by each customer and by type of transfer. use of Nested Queries
SELECT 
accounts.customer_id,
SUM(accounts_aggregates.n_deposits) AS n_deposits,
SUM(accounts_aggregates.n_withdrawals) AS n_withdrawals
FROM accounts
	LEFT JOIN (
		SELECT 
			account_id, 
			SUM(CASE WHEN transaction_type = "deposit" THEN 1 ELSE 0 END) AS n_deposits,
			SUM(CASE WHEN transaction_type = "withdrawal" THEN 1 ELSE 0 END) AS n_withdrawals
		FROM transfers
		GROUP BY account_id)
AS accounts_aggregates
ON accounts.account_id = accounts_aggregates.account_id
GROUP BY accounts.customer_id
ORDER BY accounts.customer_id;

-- Products summary by Costumer, use of Common Table Expressions (CTEs), WITH
WITH accounts_summary AS(
SELECT customer_id,
SUM(CASE WHEN status = "active" THEN 1 ELSE 0 END ) AS n_active_accounts,
SUM(CASE WHEN status = "inactive" THEN 1 ELSE 0 END ) AS n_inactive_accounts
FROM accounts
GROUP BY customer_id), 
insurance_summary AS (
SELECT customer_id,
COUNT(insurance_id) AS n_insurance
FROM insurance
GROUP BY customer_id)
SELECT 
customers.customer_id, 
CONCAT(customers.first_name," ", customers.last_name) AS customer_name,
location.country, 
location.city,
COALESCE(accounts_summary.n_active_accounts, 0) AS n_active_accounts,
COALESCE(accounts_summary.n_inactive_accounts,0) AS n_inactive_accounts,
COALESCE(insurance_summary.n_insurance,0) AS n_insurance
FROM customers
LEFT JOIN location ON customers.location_id = location.location_id
LEFT JOIN accounts_summary ON customers.customer_id = accounts_summary.customer_id
LEFT JOIN insurance_summary ON customers.customer_id = insurance_summary.customer_id;