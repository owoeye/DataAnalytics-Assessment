-- 1. Question Approach:
-- identify the data set with the savings plans 
-- identify the data set with the investment plans
-- count the number of saving account per customer
-- count the number of investment accounts per customer
-- identify customers with MIN 1 savings AND 1 investment plan
-- concatinate first and last name to a single column
-- merge first and last name
-- sort by total deposits

-- 2. Challenges: Using multiple sub queries for savings and investments complicated joining and filtering
	-- Resolution: Combined logic into a single grouped subquery with conditional sums for clarity and efficiency

SELECT owner_id, CONCAT(user_c.first_name, ' ', user_c.last_name) name, savings_count, investment_count, total_deposits
FROM adashi_staging.users_customuser user_c
JOIN (SELECT pp.owner_id, 
				SUM(CASE WHEN pp.is_regular_savings = 1 THEN 1 ELSE 0 END) savings_count, 
				SUM(CASE WHEN pp.is_a_fund = 1 THEN 1 ELSE 0 END) investment_count, 
				SUM(confirmed_amount) total_deposits
		FROM adashi_staging.plans_plan pp
		JOIN adashi_staging.savings_savingsaccount ss
		ON pp.id = ss.plan_id AND ss.confirmed_amount > 0 AND (pp.is_regular_savings = 1 OR pp.is_a_fund = 1)
		GROUP BY pp.owner_id
        HAVING savings_count >= 1 AND investment_count >= 1) accounts
ON accounts.owner_id = user_c.id
ORDER BY total_deposits;
