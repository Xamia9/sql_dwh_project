/*
=====================================================================================
Product Report
=====================================================================================
Purpose:
	- This report consolidates key product metrics and behaviors
Highlights:
	1. Gathers essential fields such as product name, cateogry, subcategory, and cost.
	2. Segments products by revenue to identity High-Performers, Mid-Range, or Low-Performers.
	3. Aggregates product_level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order revenue (AOR)
		- average monthly revenue
=====================================================================================
*/

-- SELECT * FROM gold.report_product
DROP VIEW IF EXISTS gold.report_product;
GO
CREATE VIEW gold.report_product AS
WITH base_query AS (
SELECT 
	s.order_number,
	s.product_key,
	p.product_id,
	p.product_name,
	s.customer_key,
	s.order_date,
	s.sales_amount,
	s.quantity,
	s.price,
	p.category,
	p.subcategory,
	p.cost
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
)

, product_aggregation AS (
SELECT
	product_key,
	product_id,
	product_name,
	category,
	subcategory,
	cost,
	COUNT(DISTINCT(order_number)) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT(customer_key)) AS total_customers,
	MAX(order_date) AS last_order_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
	AVG(price) AS avg_selling_price
FROM base_query
GROUP BY 
	product_key,
	product_id,
	product_name,
	category,
	subcategory,
	cost
)

SELECT
	product_key,
	product_id,
	product_name,
	category,
	subcategory,
	cost,
	DATEDIFF(month, last_order_date, GETDATE()) AS recency,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	last_order_date,
	lifespan,
	avg_selling_price,
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales/total_orders
	END avg_order_value,
	CASE
		WHEN lifespan = 0 THEN lifespan
		ELSE total_sales/lifespan
	END avg_monthly_spend
FROM product_aggregation