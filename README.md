# DataAnalytics-Assessment

---

## 🛠️ Tools Used

- **MySQL** – for querying and aggregation
- **SQL Workbench / CLI** – for query execution
- **Git & GitHub** – for version control and documentation

---

## 🧾 Test Questions, Approaches & Challenges

---

### 🔹 Q1: Identify Active Users Across Savings and Investments

**🧩 Objective**  
Identify customers who actively use both savings and investment products, including their total deposits.

**🛠️ Approach**
- Identify the savings and investment plans separately.
- Count savings accounts and investment accounts per customer.
- Filter customers with **at least 1 of each**.
- Concatenate `first_name` and `last_name` into a full name.
- Aggregate total confirmed deposits.
- Sort results by total deposit amount.

**⚠️ Challenges**
- **Using multiple subqueries** for savings and investment counts complicated filtering.
  - ✅ **Resolution**: Merged logic into a single grouped subquery using **conditional sums** (`SUM(CASE WHEN...)`) for simplicity and better performance.

---

### 🔹 Q2: Segment Users Based on Transaction Frequency

**🧩 Objective**  
Categorize users as **High**, **Medium**, or **Low** frequency customers based on their monthly transaction activity.

**🛠️ Approach**
- Use transaction history to count monthly transactions per customer.
- Calculate the average number of transactions per month per user.
- Apply thresholds using a `CASE` statement:
  - High: > 9 transactions/month  
  - Medium: 3–9 transactions/month  
  - Low: < 3 transactions/month
- Group and count users by frequency category.
- Calculate average transactions per category.

**⚠️ Challenges**
- **Monthly aggregation varies** for customers with inconsistent activity.
  - ✅ **Resolution**: Used a **nested query** to average only active months.
- **Overlapping or unclear thresholds** for categories.
  - ✅ **Resolution**: Applied clear logic using `CASE` statements with non-overlapping ranges.

---

### 🔹 Q3: Identify Inactive Accounts

**🧩 Objective**  
Return accounts (savings or investment) that have **no transaction for at least 1 year**.

**🛠️ Approach**
- Join `plans_plan` and `savings_savingsaccount` tables.
- Filter for savings and investment products only.
- Calculate the last transaction date per plan.
- Compute inactivity as `DATEDIFF(CURDATE(), MAX(transaction_date))`.
- Return plans with inactivity ≥ 365 days.

**⚠️ Challenges**
- **MySQL strict mode** errors from selecting non-aggregated fields without grouping.
  - ✅ **Resolution**: Ensured all selected non-aggregated columns were either grouped or aggregated.

---

### 🔹 Q4: Estimate Customer Lifetime Value (CLV)

**🧩 Objective**  
Estimate the CLV for each customer based on their transaction behavior and average profit.

**🛠️ Approach**
- Compute `tenure_months` as the number of months since the account was created.
- Calculate profit per transaction using `(confirmed_amount * 0.001)`.
- Count total transactions per customer.
- Estimate CLV using the formula:  
  CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction

**⚠️ Challenges**
- **Division by zero** for newly joined customers with `tenure = 0`.
  - ✅ **Resolution**: Used `NULLIF(tenure_months, 0)` to avoid runtime errors.
- **Incorrect tenure calculation** for edge cases (e.g., sign-up today or future date).
  - ✅ **Resolution**: Used `TIMESTAMPDIFF(MONTH, date_joined, NOW())` with data validation for consistency.

---

## 🙋‍♂️ Author

**Owoeye Peace Iyioluwa**  
Data Analyst | SQL Developer | Mechatronics Graduate  
📧 [iyi.owoeye@yahoo.com]  
🔗 [LinkedIn](www.linkedin.com/in/peace-owoeye-2a78b0153)
