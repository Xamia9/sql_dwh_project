-- segment products into cost ranges
-- and count how many products fall into each segment

WITH product_segments AS (
	SELECT
		product_name,
		cost,
		CASE
			WHEN cost < 100 THEN 'below 100'
			WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'above 1000'
		END cost_range
	FROM gold.dim_products
)

SELECT
	cost_range,
	COUNT(cost_range) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY cost_range DESC


/* Group customers into 3 segments based on their spending behavior:
	- VIP: customers with at least 12 months of history and spending more than 5.000
	- Regular: customers with at least 12 months of history but spending 5000 or less
	- New: customer with a lifespan less than 12 months
And find the total number of customers by each group */
	
WITH customer_spending AS (
SELECT
	s.customer_key,
	SUM(sales_amount) AS spending,
	DATEDIFF (month, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY s.customer_key
)

SELECT
	customer_segment,
	COUNT(customer_segment) AS total_customers
FROM (
SELECT
	customer_key,
	CASE
		WHEN lifespan > 12 AND spending > 5000 THEN 'VIP'
		WHEN lifespan > 12 AND spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END customer_segment
FROM customer_spending)t
GROUP BY customer_segment
ORDER BY COUNT(customer_segment) DESC
