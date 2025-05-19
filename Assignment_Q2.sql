-- 1. Question Approach:
-- identify the data set with the transactions
-- group by customers and count the number of transcations per customer each month
-- categorise the data and use a new clumn to indicate the category for high, medium and low frequency users
-- count number of customers per frequnecy category find the average 

-- 2a. Challenge: Averaging monthly transaction counts over months with differing activity (including months with zero transactions).
	-- Resolution: Averaged the monthly counts per customer using a nested query, ensuring only months with transactions were considered.
-- b. Challenge: Defining clear, non-overlapping frequency categories and applying them correctly.
	-- Resolution: Used a CASE statement with clear thresholds to categorize users into High, Medium, and Low Frequency groups.

SELECT frequency_category, COUNT(owner_id) customer_count, AVG(avg_trans) avg_transactions_per_month
FROM (SELECT trans_sum.owner_id, AVG(trans_sum.no_trans) avg_trans, CASE
																		WHEN AVG(trans_sum.no_trans) > 9 THEN 'High Frequency'
																		WHEN AVG(trans_sum.no_trans) BETWEEN 3 AND 9 THEN 'Medium Frequency'
																		WHEN AVG(trans_sum.no_trans) < 3 THEN 'Low Frequency'
																		ELSE 'outlier'
																	END AS frequency_category
		FROM (SELECT owner_id, MONTH(transaction_date) month, COUNT(transaction_date) no_trans
				FROM adashi_staging.savings_savingsaccount
				GROUP BY owner_id, MONTH(transaction_date)) trans_sum
		GROUP BY trans_sum.owner_id) t_avg
GROUP BY frequency_category;