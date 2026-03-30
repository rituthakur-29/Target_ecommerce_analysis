-- PART I : Intial Exp
-- 1.Checking the structure and characteristics of the dataset
-- Use information_schema to understand tables, columns, nullability, and data types.
SELECT
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- 2. Data type of all columns in the "customers" table
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns
WHERE table_name = 'customers'
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 3. Get the time range between which the order was placed
SELECT MIN(order_purchase_timestamp) AS first_order_date, 
MAX(order_purchase_timestamp) AS last_order_date
FROM orders;

-- Changing Datatype 
ALTER TABLE orders
ALTER COLUMN order_purchase_timestamp TYPE TIMESTAMP
USING TO_TIMESTAMP(order_purchase_timestamp, 'DD-MM-YY HH24:MI');


-- 4. Count the Cities & States of customer who ordered during the given period
SELECT c.customer_state AS state, c.customer_city AS city, COUNT( DISTINCT c.customer_id) AS customer_count
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
WHERE o.order_purchase_timestamp BETWEEN '2016-09-04' AND '2018-10-17'
GROUP BY c.customer_state, c.customer_city
ORDER BY c.customer_state, customer_count DESC;

-- PART II : In-Depth Exploration
-- 1. Trend: Number of orders over the years
SELECT EXTRACT(YEAR FROM order_purchase_timestamp) as order_year,
COUNT(order_id) as total_orders
FROM orders
GROUP BY order_year
ORDER BY order_year;

--2. Monthly Seasonality in Orders
SELECT EXTRACT(YEAR FROM order_purchase_timestamp) AS order_year,
	EXTRACT(MONTH FROM order_purchase_timestamp) AS order_month,
	COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

--3. Time of Day when Brazilian customers placed orders
SELECT 
	CASE WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 0 AND 5
	THEN 'Dawn'
	WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 6 AND 11
	THEN 'Morning'
	WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 12 AND 17
	THEN 'Afternoon'
	ELSE 'Night'
END AS time_of_day,
COUNT(o.order_id) AS total_orders
FROM orders o 
JOIN customers c ON o.customer_id= c.customer_id
WHERE c.customer_state IS NOT NULL
GROUP BY time_of_day
ORDER BY total_orders DESC;

-- PART III : Evolution of E-commerce Orders in Brazil
-- 1. Month on Month numberr of orders placed in each state
SELECT c.customer_state AS state,
	DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
	COUNT(o.order_id) AS total_orders
	FROM orders o JOIN customers c
	ON o.customer_id= c.customer_id
	GROUP BY c.customer_state, DATE_TRUNC('month', o.order_purchase_timestamp)
	ORDER BY state, order_month;

-- 2. Distribution of customers across all states
SELECT customer_state AS state, 
	COUNT( DISTINCT customer_unique_id) AS total_customers
	FROM customers
	GROUP BY customer_state
	ORDER BY total_customers DESC;

-- PART IV: Impact on Economy
-- 1. Analyze money movement( order prices, freight and other factors)
	--  A. Total Revenue, Total freight, Total Order Value
	-- This will give the overall money flowing through the platform
SELECT SUM(oi.price) AS total_product_value,
		SUM(oi. freight_value) AS total_freight_value,
		SUM(oi.price + oi.freight_value) AS total_order_value
	FROM order_items oi;

-- Changing datatype of price and freight value, as it is stored as a text
ALTER TABLE order_items
ALTER COLUMN price TYPE NUMERIC USING price::NUMERIC;

ALTER TABLE order_items
ALTER COLUMN freight_value TYPE NUMERIC USING freight_value::NUMERIC;

	-- B. Revenue Trend by Year
	-- To see if business scaled finacially
SELECT EXTRACT (YEAR FROM o.order_purchase_timestamp) as order_year,
	SUM(oi.price + oi.freight_value) as total_order_value
FROM orders o JOIN order_items oi 
ON o.order_id = oi.order_id
GROUP BY order_year
ORDER BY order_year;

-- 2. Percentage increase in cost of orders(2017 → 2018 Jan-Aug)
SELECT ROUND ((sales_2018 - sales_2017)/ sales_2017 * 100, 2) AS percentage_increase
FROM(
	SELECT
		SUM(CASE WHEN EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2017
		THEN oi.price + oi.freight_value
	END) AS sales_2017,
		SUM( CASE WHEN EXTRACT(YEAR FROM o.order_purchase_timestamp) = 2018
		AND EXTRACT( MONTH FROM o.order_purchase_timestamp) <= 8
		THEN oi.price+ oi.freight_value
	END) AS sales_2018
FROM orders o JOIN order_items oi 
ON o.order_id = oi.order_id
) t;

-- 3. Total & Average order price and freight for each state
SELECT c.customer_state, 
	SUM(oi.price) as total_product_value, ROUND(AVG(oi.price),2) as avg_product_value,
	SUM(oi.freight_value) as total_freight_value, ROUND(AVG(oi.freight_value),2) as avg_freight_value
FROM orders o JOIN order_items oi
	ON o.order_id= oi.order_id
JOIN customers c
	ON o.customer_id= c.customer_id
GROUP BY c.customer_state
ORDER BY total_product_value;

-- PART V: Analysis on Sales, Freight and Delivery Time
-- 1. Calculate delivery time & difference between estimated & actual delivery
	-- A. Delivery Time (Actual)
	-- Delivery time in days
SELECT o.order_id, EXTRACT(DAY FROM 
	(o.order_delivered_customer_date - o.order_purchase_timestamp)
) AS delivery_days
FROM orders o
WHERE o.order_delivered_customer_date IS NOT NULL;

	-- B. Difference between Estimated & Actual Delivery
SELECT o.order_id, (o.order_delivered_customer_date - o.order_estimated_delivery_date)
AS delivery_difference
FROM orders o
WHERE o.order_delivered_customer_date IS NOT NULL;

-- 2. Top 5 states : Highest & Lowest Average Freight
-- Top 5 Highest Average Freight 
SELECT c.customer_state, ROUND(AVG(oi.freight_value::numeric),2) AS avg_freight
FROM orders o JOIN customers c 
ON o.customer_id= c.customer_id 
JOIN order_items oi ON o.order_id= oi.order_id
GROUP BY c.customer_state
ORDER BY avg_freight DESC
LIMIT 5;

-- Top 5 Lowest Average Freight
SELECT c.customer_state, ROUND(AVG(oi.freight_value::numeric),2) AS avg_freight
FROM orders o JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY avg_freight ASC
LIMIT 5; 

-- 3. Top 5 States : Highest & Lowest Average Delivery Time
-- Highest Average Delivery Time
SELECT c.customer_state, 
ROUND(AVG(EXTRACT(DAY FROM(o.order_delivered_customer_date - o.order_purchase_timestamp))),)
