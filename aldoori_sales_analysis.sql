USE sample_sales;

SHOW TABLES;

DESCRIBE store_sales;
DESCRIBE online_sales;

SELECT *
FROM online_sales
WHERE ShiptoState = 'Maine'
LIMIT 10;

DESCRIBE store_locations;

SELECT *
FROM store_locations
LIMIT 10;

SELECT *
FROM store_locations
WHERE State = 'Maine';

SELECT *
FROM store_sales
LIMIT 10;

SELECT *
FROM store_sales AS s
INNER JOIN store_locations AS l
ON s.Store_ID = l.StoreID
WHERE l.State = 'Maine'
LIMIT 10;

-- What is total revenue overall for sales in the assigned territory, plus the start date and end date that tell you what period the data covers?
SELECT COUNT(*) AS Total_Transactions,
SUM(s.Sale_Amount) AS Total_Revenue,
MIN(s.Transaction_Date) AS Start_Date,
MAX(s.Transaction_Date) AS End_Date
FROM store_sales AS s
INNER JOIN store_locations AS l
ON s.Store_ID = l.StoreId
WHERE l.State = 'Maine';

-- What is the revenue breakdown by year and month for the sales territory?
SELECT
YEAR(s.Transaction_Date) AS Sales_Year, MONTH(s.Transaction_Date) AS Sales_Month, SUM(s.Sale_Amount) AS Total_Revenue
FROM store_sales AS s
INNER JOIN store_locations AS l
ON s.Store_ID = l.StoreID
WHERE l.State = 'Maine'
GROUP BY YEAR(s.Transaction_Date), MONTH(s.Transaction_Date)
ORDER BY Sales_Year ASC, Sales_Month ASC;

-- Provide a comparison of total revenue for the specific sales territory and the region it belongs to.
DESCRIBE management;
SELECT *
FROM management
LIMIT 10;

SELECT m.Region, Sum(s.Sale_Amount) AS Regional_Revenue
FROM store_sales AS s
INNER Join store_locations AS l
ON s.Store_ID = l.StoreId
INNER JOIN management AS m
ON l.State = m.State
WHERE m.Region = 'Northeast'
GROUP BY m.Region;

SELECT l.State, SUM(s.Sale_Amount) AS Total_Revenue
FROM store_sales AS s
INNER JOIN store_locations AS l
ON s.Store_ID = l.StoreId
INNER JOIN management AS m
ON l.State = m.State
WHERE m.Region = 'Northeast'
GROUP BY l.State
ORDER BY Total_Revenue DESC; -- Using this code helps with understanding other territory total revinue and confirming calculations.

SELECT ROUND((1877249.75 / 24237526.98) * 100, 2)
AS Maine_Regional_Percentage;

-- What is the number of transactions per month and average transaction amount by product category for the sales territory?
SELECT
    YEAR(s.Transaction_Date) AS Sales_Year,
    MONTH(s.Transaction_Date) AS Sales_Month,
    c.Category AS Product_Category,
    COUNT(*) AS Total_Transactions,
    ROUND(AVG(s.Sale_Amount), 2) AS Average_Transaction_Amount
FROM store_sales AS s
INNER JOIN store_locations AS l
    ON s.Store_ID = l.StoreId
INNER JOIN products AS p
    ON s.Prod_Num = p.ProdNum
INNER JOIN inventory_categories AS c
    ON p.Categoryid = c.Categoryid
WHERE l.State = 'Maine'
GROUP BY
    YEAR(s.Transaction_Date),
    MONTH(s.Transaction_Date),
    c.Category
ORDER BY
    Sales_Year ASC,
    Sales_Month ASC,
    Product_Category ASC;
    
    -- Can you provide a ranking of in-store sales performance by each store in the sales territory, or a ranking of online sales performance by state within an online sales territory?
    SELECT
l.StoreLocation AS Store_Name, l.State,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(s.Sale_Amount), 2) AS Total_Revenue
FROM store_sales AS s
INNER JOIN store_locations AS l
    ON s.Store_ID = l.StoreId
WHERE l.State = 'Maine'
GROUP BY l.StoreId, l.StoreLocation, l.State
ORDER BY Total_Revenue DESC;

-- What is your recommendation for where to focus sales attention in the next quarter?
-- I think we should focus more on Bar Harbor and Bangor next quarter because they had the lowest sales. We could try offering more promotions and encouraging customers to buy more products. We should also look at what South Portland is doing differently since it had the highest sales and see if other stores can do the same.



    
