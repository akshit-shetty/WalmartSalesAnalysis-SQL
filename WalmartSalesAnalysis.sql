CREATE DATABASE IF NOT EXISTS walmartSales;

use walmartSales;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);






-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------Feature Engineering-------------------------------------------------------------------------------

-- time_of_day

SELECT time,
(
CASE 
WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END ) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN  time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (CASE 
WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
END);

-- day_name

SELECT 
date, DAYNAME(date) as day_name
FROM 
Sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(20);

UPDATE sales
SET day_name = DAYNAME(date);

-- month_name

SELECT 
date, MONTHNAME(date) as month_name
FROM 
Sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

UPDATE sales
SET month_name = MONTHNAME(date);



-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------Business Questions To Answer-------------------------------------------------------------------------------


-- Generic Question


-- How many unique cities does the data have?

SELECT DISTINCT
    city
FROM
    sales;
    
-- In which city is each branch?

SELECT DISTINCT
    city, branch
FROM
    sales;
    
    
-- Product

-- How many unique product lines does the data have?

SELECT 
    COUNT(DISTINCT product_line)
FROM
    sales;


-- What is the most common payment method?

SELECT DISTINCT
    payment, COUNT(payment) AS cnt
FROM
    sales
GROUP BY payment
ORDER BY cnt DESC
LIMIT 1;


-- What is the most selling product line?

SELECT DISTINCT
    product_line, COUNT(product_line) AS cnt
FROM
    sales
GROUP BY product_line
ORDER BY cnt DESC
LIMIT 1;

-- What is the total revenue by month?

SELECT 
    month_name AS Month, SUM(total) AS total_revenue
FROM
    sales
GROUP BY month_name
ORDER BY total_revenue DESC;


-- What month had the largest COGS?

SELECT month_name AS Month,  SUM(cogs) AS COGS
FROM
Sales
GROUP BY month_name
ORDER BY COGS DESC
LIMIT 1;


-- What product line had the largest revenue?

SELECT product_line, SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 1;

-- What is the city with the largest revenue?

SELECT 
    city, SUM(total) AS total_revenue
FROM
    sales
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 1;

-- What product line had the largest VAT?

SELECT 
    product_line, AVG(tax_pct) AS VAT
FROM
    sales
GROUP BY product_line
ORDER BY VAT DESC
LIMIT 1;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT product_line, 
       CASE WHEN total < (SELECT AVG(total) FROM sales) THEN "GOOD" ELSE "BAD" END AS category
FROM sales;


-- Which branch sold more products than average product sold?

SELECT branch, SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING qty > (SELECT AVG(quantity) FROM sales);


-- What is the most common product line by gender?

SELECT 
    gender, product_line, COUNT(gender) AS cnt
FROM
    sales
GROUP BY gender , product_line
ORDER BY cnt DESC;

-- What is the average rating of each product line?

SELECT product_line, ROUND(AVG(rating),2) as Ratings
FROM sales
GROUP BY product_line
ORDER BY Ratings DESC;


-- Sales

-- Number of sales made in each time of the day per weekday

SELECT 
    time_of_day, COUNT(*) AS total_sales
FROM
    sales
GROUP BY time_of_day
ORDER BY total_sales DESC;



-- Which of the customer types brings the most revenue?

SELECT 
    customer_type, SUM(total) AS total_revenue
FROM
    sales
GROUP BY customer_type
ORDER BY total_revenue DESC
LIMIT 1;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT 
    city, AVG(tax_pct) AS VAT
FROM
    sales
GROUP BY city
ORDER BY VAT DESC
LIMIT 1;

-- Which customer type pays the most in VAT?

SELECT 
    customer_type, AVG(tax_pct) AS VAT
FROM
    sales
GROUP BY customer_type
ORDER BY VAT DESC
LIMIT 1;

-- Customer


-- How many unique customer types does the data have?

SELECT DISTINCT
    customer_type
FROM
    sales;
    
-- How many unique payment methods does the data have?

SELECT DISTINCT
    payment
FROM
    sales;

-- Which customer type buys the most?

SELECT 
    customer_type, COUNT(*) AS cnt
FROM
    sales
GROUP BY customer_type
ORDER BY cnt DESC
LIMIT 1;


-- What is the gender of most of the customers?

SELECT gender, COUNT(*) as cnt_gen
FROM sales
GROUP BY gender
ORDER BY cnt_gen DESC
LIMIT 1;


-- What is the gender distribution per branch?

SELECT branch, gender, COUNT(*) as cnt_gen
FROM sales
GROUP BY gender, branch
ORDER BY branch;


-- Which time of the day do customers give most ratings?

SELECT 
    time_of_day, COUNT(rating) AS Rating
FROM
    Sales
GROUP BY time_of_day
ORDER BY Rating DESC
LIMIT 1;


-- Which time of the day do customers give most ratings per branch?

SELECT 
    branch, time_of_day, COUNT(rating) AS Rating
FROM
    Sales
GROUP BY branch, time_of_day
ORDER BY Rating DESC;

-- Which day fo the week has the best avg ratings?

SELECT day_name, AVG(rating) as best_avg_rat
FROM sales
GROUP BY day_name
ORDER BY best_avg_rat DESC;


-- Which day of the week has the best average ratings per branch?

SELECT branch, day_name, AVG(rating) as best_avg_rat
FROM sales
GROUP BY branch, day_name
ORDER BY best_avg_rat DESC;


-- ----------------------------------------------------------------------------------------------------------------------------------