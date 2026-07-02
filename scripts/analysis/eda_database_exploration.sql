-- Explore all objects in database
SELECT * FROM INFORMATION_SCHEMA.TABLES


-- Explore all columns in database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales'