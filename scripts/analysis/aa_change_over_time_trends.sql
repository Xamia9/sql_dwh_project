SELECT * FROM gold.fact_sales

-- analyze sales performance over time (year)
SELECT
	YEAR(order_date) year,
	SUM(sales_amount) total_sales,
	COUNT(DISTINCT(customer_key)) total_customers,
	SUM(quantity) total_quantity
FROM gold.fact_sales
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

-- analyze sales performance over time (month)
SELECT
	MONTH(order_date) month,
	SUM(sales_amount) total_sales,
	COUNT(DISTINCT(customer_key)) total_customers,
	SUM(quantity) total_quantity
FROM gold.fact_sales
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date)

-- analyze sales performance over time (year, month)
-- using YEAR, MONTH
SELECT
	YEAR(order_date) year,
	MONTH(order_date) month,
	SUM(sales_amount) total_sales,
	COUNT(DISTINCT(customer_key)) total_customers,
	SUM(quantity) total_quantity
FROM gold.fact_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)

-- using DATETRUNC
SELECT
	DATETRUNC(month,order_date) order_date,
	SUM(sales_amount) total_sales,
	COUNT(DISTINCT(customer_key)) total_customers,
	SUM(quantity) total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)
ORDER BY DATETRUNC(month,order_date)

-- using FORMAT (note: string not date, so can't filter month)
SELECT
	FORMAT(order_date, 'yyyy-MMM') order_date,
	SUM(sales_amount) total_sales,
	COUNT(DISTINCT(customer_key)) total_customers,
	SUM(quantity) total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM')
