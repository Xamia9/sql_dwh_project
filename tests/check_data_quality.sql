-- CHECK DATA QUALITY

-- File 1: silver.crm_cust_info --

SELECT * FROM silver.crm_cust_info;

-- Find duplicate in PK
-- Expectation: no result
SELECT 
	cst_id,
	COUNT (*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT (*) > 1 OR cst_id IS NULL;

-- Find unwanted spaces
-- Expectation: no result
SELECT
	cst_firstname
FROM silver.crm_cust_info
WHERE TRIM (cst_firstname) != cst_firstname;

-- Find unwanted spaces
-- Expectation: no result
SELECT
	cst_lastname
FROM silver.crm_cust_info
WHERE TRIM (cst_lastname) != cst_lastname;

-- Find how many types
SELECT DISTINCT
	cst_gndr
FROM silver.crm_cust_info

-- File 2: silver.crm_prd_info --

SELECT * FROM silver.crm_prd_info;

-- Find how many types
SELECT DISTINCT
	prd_line
FROM silver.crm_prd_info;

-- Check logic date
-- Expectation: no result
SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt

-- File 3: silver.crm_sales_details --

SELECT * FROM silver.crm_sales_details;

-- Find invalid dates
-- Expectation: no result
SELECT 
	sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
	OR LEN(sls_order_dt) != 8;

-- Find wrong logic sales
-- Expectation: no result
SELECT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_quantity * sls_price != sls_sales 
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0;

-- File 4: silver.erp_cust_az12 --

SELECT * FROM silver.erp_cust_az12;

-- Find types
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

-- Find invalid birthdays
-- Expectation: no result
SELECT 
	bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();