-- 1. Question Approach:
-- identify the data set with the activity indicator
-- filter for active saving and investment accounts
-- return accounts with no transaction for 1year

-- 2a. Challenges: SQL strict modes require all non-aggregated selected columns to be in the GROUP BY clause. Forgetting to include all necessary columns (like is_a_fund and is_regular_savings) can cause errors.
	-- Resolution: Include all non-aggregated columns in the GROUP BY or apply aggregate functions.

SELECT plan_id, owner_id, CASE
								WHEN is_a_fund = 1 THEN 'Investments'
								WHEN is_regular_savings = 1 THEN 'Savings'
								ELSE 'ERROR'
							END type, 
		DATE(MAX(transaction_date)) last_transaction_date, DATEDIFF(CURDATE(), MAX(transaction_date)) inactivity_days
        
FROM (SELECT ss.plan_id, pp.owner_id, ss.transaction_date, pp.is_a_fund, pp.is_regular_savings, ss.confirmed_amount
		FROM adashi_staging.plans_plan pp
		JOIN adashi_staging.savings_savingsaccount ss
		ON pp.id = ss.plan_id
		WHERE is_a_fund = 1 OR is_regular_savings = 1) trans_in
        
GROUP BY plan_id, owner_id
HAVING inactivity_days >= 365;
