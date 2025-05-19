-- 1. Question Approach:
-- Identify each customer and their active months
-- calculate the profit per transaction
-- find account tenure, number of monthe since sign up with date diff
-- find the total transactions performed
-- calculate CLV = total_transactions/tenure * 12 * avg_profit_per_transaction

-- 2a. Challenges: Some customers may have just signed up, resulting in a tenure of 0 months. Dividing by zero causes errors.
-- Resolution: Use NULLIF to convert zero tenure into NULL and avoid division errors.

-- b. Challenges: Accurately calculating the months since signup is crucial. Edge cases where the join date is today or future dates can cause issues.
-- Resolution: Use TIMESTAMPDIFF(MONTH, date_joined, NOW()) and validate data for consistency.

SELECT id customer_id, CONCAT(first_name, ' ', last_name) name, NULLIF(TIMESTAMPDIFF(MONTH, date_joined, NOW()), 0) tenure_months, total_transactions, (total_transactions/TIMESTAMPDIFF(MONTH, date_joined, NOW())) * 12 * avg_profit_per_transaction estimated_clv
FROM adashi_staging.users_customuser users_cust
JOIN (SELECT owner_id, COUNT(owner_id) total_transactions, AVG(avg_profit_per_transaction) avg_profit_per_transaction
		FROM (SELECT owner_id, (confirmed_amount * 0.001) avg_profit_per_transaction
				FROM adashi_staging.savings_savingsaccount) avg_trans
		GROUP BY owner_id) total_avg_trans
ON users_cust.id = total_avg_trans.owner_id
ORDER BY estimated_clv DESC;


