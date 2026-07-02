SELECT * FROM gold.fact_sales
SELECT * FROM gold.dim_customers
SELECT * FROM gold.dim_products

-- Find the total sales
SELECT SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity
FROM gold.fact_sales;

-- Find the average selling price
SELECT AVG(price) AS avg_price
FROM gold.fact_sales;

-- Find the total number of orders
SELECT COUNT(order_number) total_orders
FROM gold.fact_sales;

SELECT COUNT(DISTINCT(order_number)) total_orders_no_duplicate
FROM gold.fact_sales;

-- reason: different product key
SELECT * 
FROM (
	SELECT *, COUNT(*) OVER (PARTITION BY order_number) AS count_order_number
	FROM gold.fact_sales 
)t WHERE count_order_number > 1

-- Find the total number of products
SELECT COUNT(product_id) AS total_products 
FROM gold.dim_products;

SELECT COUNT(DISTINCT(product_id)) AS total_products 
FROM gold.dim_products;

-- Find the total number of customers
SELECT COUNT(customer_id) AS total_customers 
FROM gold.dim_customers;

SELECT COUNT(DISTINCT(customer_id)) AS total_customers 
FROM gold.dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT(customer_key)) AS total_order_customers 
FROM gold.fact_sales;

-- Generate a report that shows all key metrics of the business
SELECT 'total_sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'total_quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'avg_price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'total_orders_no_duplicate', COUNT(DISTINCT(order_number)) FROM gold.fact_sales
UNION ALL
SELECT 'total_products', COUNT(product_id) total_products FROM gold.dim_products
UNION ALL
SELECT 'total_customers', COUNT(customer_id) FROM gold.dim_customers
UNION ALL
SELECT 'total_order_customers', COUNT(DISTINCT(customer_key)) FROM gold.fact_sales;