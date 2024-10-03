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
    balance_month,
    balance_year,
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
