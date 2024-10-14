-- newbank is the schema created for the exercise
USE newbank;

CREATE TEMPORARY TABLE monthlyBalance AS
SELECT account_id, YEAR(transaction_requested_date) AS balance_year,MONTH(transaction_requested_date) AS balance_month,
SUM(CASE WHEN transaction_type = "deposit" THEN AMOUNT ELSE 0 END ) AS deposit_sum,
SUM(CASE WHEN transaction_type = "withdrawal" THEN AMOUNT ELSE 0 END ) AS withdrawal_sum,
SUM(CASE WHEN transaction_type = 'deposit' THEN amount ELSE 0 END) - SUM(CASE WHEN transaction_type = 'withdrawal' THEN amount ELSE 0 END) AS account_monthly_balance
FROM transfers
GROUP BY account_id, balance_year,balance_month
ORDER BY account_id,balance_year,balance_month;

CREATE TEMPORARY TABLE cumulativeBalance AS
SELECT 
    account_id,
	balance_year,
    balance_month,
    deposit_sum,
    withdrawal_sum,
    account_monthly_balance,
    -- Calculate cumulative balance as a running total, considering current and the previous rows
    SUM(account_monthly_balance) OVER (PARTITION BY account_id ORDER BY balance_year, balance_month 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_balance
FROM monthlyBalance
ORDER BY account_id, balance_year, balance_month;

SELECT *
FROM cumulativeBalance;

-- OTHER WINDOW FUNCTIONS

-- HIGHEST TRANSFERS
SELECT account_id, amount, RANK() OVER (ORDER BY amount DESC) AS RANKING FROM transfers;

-- LAG, MOVING AVERAGE
SELECT 
    account_id,
	balance_year,
    balance_month,
    cumulative_balance, 
    LAG(cumulative_balance, 1) OVER (ORDER BY account_id,balance_year,balance_month) AS previous_amount,
    AVG(cumulative_balance) OVER (ORDER BY account_id,balance_year,balance_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_average_2
FROM cumulativeBalance;