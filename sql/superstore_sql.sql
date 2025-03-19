-- ##########################################################################################
-- **Data Cleaning & Preparation**
-- ##########################################################################################

-- **1. Check the structure of the superstore table**  
-- This query provides the structure of the dataset (column names, data types, etc.).  
DESCRIBE superstore;

-- **2. Fix Date Formats**
-- Ensure the 'Order Date' and 'Ship Date' columns are correctly formatted as DATE types.
-- This avoids issues in any future time-based analysis.
UPDATE superstore
SET `Order Date` = str_to_date(`Order Date`, '%m/%d/%Y'),
    `Ship Date` = str_to_date(`Ship Date`, '%m/%d/%Y')
WHERE 
    str_to_date(`Order Date`, '%m/%d/%Y') IS NOT NULL
    OR str_to_date(`Ship Date`, '%m/%d/%Y') IS NOT NULL;

-- **3. Rename Columns for Consistency**
-- This renaming of columns ensures consistency and proper data types, making the table easier to work with in the future.
ALTER TABLE superstore
CHANGE `Row ID` row_id INT,
CHANGE `Order ID` order_id VARCHAR(255),
CHANGE `Order Date` order_date DATE,
CHANGE `Ship Date` ship_date DATE,
CHANGE `Ship Mode` ship_mode VARCHAR(255),
CHANGE `Customer ID` customer_id VARCHAR(255),
CHANGE `Customer Name` customer_name VARCHAR(255),
CHANGE `Segment` segment VARCHAR(255),
CHANGE `country` country VARCHAR(255),
CHANGE `City` city VARCHAR(255),
CHANGE `State` state VARCHAR(255),
CHANGE `Postal Code` postal_code INT,
CHANGE `Region` region VARCHAR(255),
CHANGE `Product ID` product_id VARCHAR(255),
CHANGE `Category` category VARCHAR(255),
CHANGE `Sub-Category` sub_category VARCHAR(255),
CHANGE `Product Name` product_name VARCHAR(255),
CHANGE `Sales` sales DECIMAL(18,2),
CHANGE `Quantity` quantity INT,
CHANGE `Discount` discount DECIMAL(5,4),
CHANGE `Profit` profit DECIMAL(18,2);

-- **4. Check for Missing Values**  
-- This query checks for any missing values in the dataset to ensure the data is complete for analysis.  
SELECT 
    COUNT(CASE WHEN row_id IS NULL THEN 1 END) AS Missing_row_id,
    COUNT(CASE WHEN order_id IS NULL THEN 1 END) AS Missing_order_id,
    COUNT(CASE WHEN order_date IS NULL THEN 1 END) AS Missing_order_date,
    COUNT(CASE WHEN ship_date IS NULL THEN 1 END) AS Missing_ship_date,
    COUNT(CASE WHEN ship_mode IS NULL THEN 1 END) AS Missing_ship_mode,
    COUNT(CASE WHEN customer_id IS NULL THEN 1 END) AS Missing_customer_id,
    COUNT(CASE WHEN customer_name IS NULL THEN 1 END) AS Missing_customer_name,
    COUNT(CASE WHEN segment IS NULL THEN 1 END) AS Missing_segment,
    COUNT(CASE WHEN country IS NULL THEN 1 END) AS Missing_country,
    COUNT(CASE WHEN city IS NULL THEN 1 END) AS Missing_city,
    COUNT(CASE WHEN state IS NULL THEN 1 END) AS Missing_state,
    COUNT(CASE WHEN postal_code IS NULL THEN 1 END) AS Missing_postal_code,
    COUNT(CASE WHEN region IS NULL THEN 1 END) AS Missing_region,
    COUNT(CASE WHEN product_id IS NULL THEN 1 END) AS Missing_product_id,
    COUNT(CASE WHEN category IS NULL THEN 1 END) AS Missing_category,
    COUNT(CASE WHEN sub_category IS NULL THEN 1 END) AS Missing_sub_category,
    COUNT(CASE WHEN product_name IS NULL THEN 1 END) AS Missing_product_name,
    COUNT(CASE WHEN sales IS NULL THEN 1 END) AS Missing_sales,
    COUNT(CASE WHEN quantity IS NULL THEN 1 END) AS Missing_quantity,
    COUNT(CASE WHEN discount IS NULL THEN 1 END) AS Missing_discount,
    COUNT(CASE WHEN profit IS NULL THEN 1 END) AS Missing_profit
FROM superstore;
-- **Verdict: No missing values, dataset is clean for analysis.**

-- **5. Add Calculated Column: Profit Margin**
-- This adds a new column to calculate the profit margin for each row in the dataset.
-- Profit margin is an important indicator of profitability.
ALTER TABLE superstore
ADD COLUMN profit_margin DECIMAL(5,2);

UPDATE superstore
SET profit_margin = (profit / sales) * 100
WHERE sales > 0;  -- To avoid division by zero errors

-- ##########################################################################################
-- **Aggregation Queries**
-- ##########################################################################################

-- **6. Total Sales**  
-- This query calculates the total sales for the entire dataset.
SELECT SUM(sales) AS total_sales
FROM superstore;

-- **7. Sales by Region**  
-- This query calculates the total sales for each region, helping identify which regions generate the most sales.
SELECT 
    region, 
    SUM(sales) as total_sales
FROM superstore
GROUP BY region;

-- **8. Average Sales per Product**  
-- This query calculates the average sales for each product, which helps in product performance analysis.
SELECT 
    product_name, 
    AVG(sales) AS avg_sales
FROM superstore
GROUP BY product_name;

-- **9. Sales by Year and Month**  
-- This query breaks down total sales by year and month, useful for time-based analysis and trend detection.
SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, SUM(sales) AS total_sales
FROM superstore
GROUP BY year, month;

-- **10. Total Profit by Region**  
-- This query aggregates profit by region, allowing us to identify which regions are the most profitable.
SELECT region, SUM(profit) AS total_profit
FROM superstore
GROUP BY region;

-- **11. Average Profit by Category**  
-- This query calculates the average profit per category, giving insight into which product categories are more profitable.
SELECT category, AVG(profit) AS avg_profit
FROM superstore
GROUP BY category;

-- **12. Profit Margin by Region**  
-- This query calculates the profit margin (profit/sales) for each region.
SELECT region, 
       SUM(profit) / SUM(sales) * 100 AS profit_margin
FROM superstore
GROUP BY region;

-- **13. Quantity by Region**  
-- This query calculates the total quantity sold by region, showing the volume of sales in each region.
SELECT region, SUM(quantity) AS total_quantity
FROM superstore
GROUP BY region;

-- **14. Average Quantity per Order by Segment**  
-- This query calculates the average quantity per order, segmented by customer segment.
SELECT segment, AVG(quantity) AS avg_quantity
FROM superstore
GROUP BY segment;

-- **15. Total Discount by Region**  
-- This query calculates the total discount given in each region.
SELECT region, SUM(discount) AS total_discount
FROM superstore
GROUP BY region;

-- **16. Average Discount by Category**  
-- This query calculates the average discount applied to each product category.
SELECT category, AVG(discount) AS avg_discount
FROM superstore
GROUP BY category;

-- **17. Total Orders by Region**  
-- This query calculates the total number of orders in each region.
SELECT region, COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY region;

-- **18. Total Orders by Segment**  
-- This query calculates the total number of orders placed by each customer segment.
SELECT segment, COUNT(DISTINCT order_id) AS order_count
FROM superstore
GROUP BY segment;

-- **19. Unique Customers by Region**  
-- This query counts the number of distinct customers in each region.
SELECT region, COUNT(DISTINCT customer_id) AS unique_customers
FROM superstore
GROUP BY region;

-- **20. Total Sales per Customer**  
-- This query calculates the total sales made to each customer.
SELECT customer_id, SUM(sales) AS total_sales_per_customer
FROM superstore
GROUP BY customer_id;

-- **21. Monthly Sales by Year**  
-- This query aggregates total sales by month and year, offering a high-level view of monthly performance.
SELECT YEAR(order_date) AS year, MONTH(order_date) AS month, SUM(sales) AS monthly_sales
FROM superstore
GROUP BY year, month;

-- **22. Annual Sales by Year**  
-- This query calculates the total sales per year, useful for yearly trend analysis.
SELECT YEAR(order_date) AS year, SUM(sales) AS annual_sales
FROM superstore
GROUP BY year
ORDER BY year;

-- ##########################################################################################
-- **Analytical Queries**
-- ##########################################################################################

-- **23. Region with Highest Sales**  
-- This query identifies the region with the highest total sales.
SELECT region, SUM(sales) AS total_sales
FROM superstore
GROUP BY region
ORDER BY total_sales DESC
LIMIT 1;

-- **24. Region with Lowest Sales**  
-- This query identifies the region with the lowest total sales.
SELECT region, SUM(sales) AS total_sales
FROM superstore
GROUP BY region
ORDER BY total_sales ASC
LIMIT 1;

-- **25. Top Selling Products**  
-- This query identifies the top 10 best-selling products by total sales.
SELECT product_name, SUM(sales) AS total_sales
FROM superstore
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- **26. Profit Margin by Product**  
-- This query calculates the profit margin for each product, showing which products are the most profitable.
SELECT product_name,
       (SUM(profit) / SUM(sales)) * 100 AS profit_margin
FROM superstore
GROUP BY product_name
ORDER BY profit_margin DESC;

-- **27. Most Profitable Products**  
-- This query identifies the 10 most profitable products, based on total profit.
SELECT product_name, SUM(profit) AS total_profit
FROM superstore
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;

-- **28. Lifetime Value (LTV) of Customers**  
-- This query calculates the lifetime value (LTV) for each customer, which is the total sales generated by each customer.
SELECT
    customer_id, 
    SUM(sales) AS lifetime_value
FROM superstore
GROUP BY customer_id;

-- **29. Customers with Highest Total Purchases**  
-- This query lists the top 10 customers based on total sales made.
SELECT customer_id, SUM(sales) AS total_purchases
FROM superstore
GROUP BY customer_id
ORDER BY total_purchases DESC
LIMIT 10;

-- **30. Total Sales and Profit per Product**  
-- This query calculates the total sales and profit per product.
SELECT product_name, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
GROUP BY product_name
ORDER BY total_sales DESC;

-- **31. Product Performance by Region**  
-- This query calculates total sales for each product, broken down by region.
SELECT product_name, region, SUM(sales) AS total_sales
FROM superstore
GROUP BY product_name, region;

-- **32. Effect of Discount on Sales and Profit**  
-- This query analyzes how discounts affect both sales and profit across regions.
SELECT region,
       SUM(sales) AS total_sales,
       SUM(profit) AS total_profit,
       SUM(discount) AS total_discount
FROM superstore
GROUP BY region;


