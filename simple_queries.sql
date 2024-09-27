SELECT t.*,a.created_date,c.first_name,c.last_name
FROM transfers as t
left join accounts as a on t.account_id =a.account_id
left join customers as c on a.customer_id = c.customer_id
ORDER BY a.created_date DESC
LIMIT 5;