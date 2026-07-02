SELECT * FROM gold.dim_products

-- Which 5 products generate the highest revenue
-- using GROUP BY + TOP
SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount) AS revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY revenue DESC;

-- using Window Function
SELECT * FROM (
SELECT
	p.product_name,
	SUM(s.sales_amount) AS revenue,
	ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount) DESC) ranking
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_name)t
WHERE ranking <= 5;


-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount) AS revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY revenue ASC;

-- Find the top 10 customers who generated the highest revenue
SELECT TOP 10
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY total_revenue DESC;

-- Find the 3 customers with the fewest orders placed
SELECT TOP 3
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT(s.order_number)) AS count_order
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY 
	c.customer_key,
	c.first_name,
	c.last_name
ORDER BY count_order;
