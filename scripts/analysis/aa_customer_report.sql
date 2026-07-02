/*
=====================================================================================
Customer Report
=====================================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors
Highlights:
	1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregates customer_level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend
=====================================================================================
*/

-- SELECT * FROM gold.report_customer
DROP VIEW IF EXISTS gold.report_customer;
GO
CREATE VIEW gold.report_customer AS
WITH base_query AS (
SELECT 
	s.order_number,
	s.product_key,
	s.order_date,
	s.sales_amount,
	s.quantity,
	s.customer_key,
	c.customer_number,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	DATEDIFF(year, c.birthdate, GETDATE()) AS age
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
WHERE order_date IS NOT NULL
)

, customer_aggergation AS (
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT(order_number)) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT(product_key)) AS total_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age
)

SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE
		WHEN age < 30 THEN 'below 30'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		WHEN age BETWEEN 50 AND 59 THEN '50-59'
		ELSE 'above 60'
	END age_group,
	CASE
		WHEN lifespan > 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan > 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END customer_segment,
	DATEDIFF(month, last_order_date, GETDATE()) AS recency,
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales/total_orders
	END avg_order_value,
	CASE
		WHEN lifespan = 0 THEN lifespan
		ELSE total_sales/lifespan
	END avg_monthly_spend,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	last_order_date,
	lifespan
FROM customer_aggergation
	
