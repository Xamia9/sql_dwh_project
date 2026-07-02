-- Find the date of the first and last order
SELECT 
	MAX(order_date) AS last_order,
	MIN(order_date) AS first_order,
	DATEDIFF(YEAR,MIN(order_date),MAX(order_date)) AS order_range_years
FROM gold.fact_sales;

-- Find the youngest and the oldest customer
SELECT 
	DATEDIFF(YEAR,MAX(birthdate),GETDATE()) AS oldest_customer_age,
	DATEDIFF(YEAR,MIN(birthdate),GETDATE()) AS youngest_customer_age,
	DATEDIFF(YEAR,MIN(birthdate),MAX(birthdate)) AS age_gap
FROM gold.dim_customers;