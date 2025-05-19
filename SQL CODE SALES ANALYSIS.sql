select * from sales_analysis;

SELECT 
    AVG(SALES / Quantity_Sold) AS Avg_Unit_Price
FROM sales_analysis;

SELECT 
    Date, 
    ((Sales - Cost_Of_Sales) / Sales) * 100 AS Gross_Profit_Percentage
FROM sales_analysis;

WITH price_changes AS (
    SELECT 
        Date,
        LAG(Sales / Quantity_Sold) OVER (ORDER BY Date) AS Prev_Daily_Unit_Price,
        LAG(Quantity_Sold) OVER (ORDER BY Date) AS Prev_Quantity_Sold,
        (Sales / Quantity_Sold) AS Current_Daily_Unit_Price,
        Quantity_Sold AS Current_Quantity_Sold
    FROM sales_analysis
)
SELECT 
    Date, 
    ((Current_Quantity_Sold - Prev_Quantity_Sold) / Prev_Quantity_Sold) AS Quantity_Change_Percentage,
    ((Current_Daily_Unit_Price - Prev_Daily_Unit_Price) / Prev_Daily_Unit_Price) AS Price_Change_Percentage,
    ((Current_Quantity_Sold - Prev_Quantity_Sold) / Prev_Quantity_Sold) /
    ((Current_Daily_Unit_Price - Prev_Daily_Unit_Price) / Prev_Daily_Unit_Price) AS Price_Elasticity
FROM price_changes
WHERE Prev_Quantity_Sold IS NOT NULL AND Prev_Daily_Unit_Price IS NOT NULL;



SELECT 
    Date, 
    Sales / Quantity_Sold AS Daily_Unit_Price
FROM sales_analysis;

SELECT 
    Date, 
    Sales, 
    AVG(Sales) OVER (ORDER BY Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS Day_Rolling_Avg
FROM sales_analysis;

SELECT * 
FROM sales_analysis
WHERE Date BETWEEN '01/01/2024' AND '31/01/2024';

SELECT * 
FROM sales_analysis
WHERE Sales > 500000;

SELECT 
    LEFT(Date, 7) AS Month, 
    SUM(Sales) AS Total_Sales, 
    SUM(Quantity_Sold) AS Total_Quantity 
FROM sales_analysis
GROUP BY Month
ORDER BY Month;

SELECT 
    LEFT(Date, 7) AS Month, 
    AVG(Sales / Quantity_Sold) AS Avg_Unit_Price, 
    AVG((Sales - Cost_Of_Sales) / Sales) * 100 AS Avg_Gross_Profit_Percentage
FROM sales_analysis
GROUP BY Month;

SELECT Date, Sales 
FROM sales_analysis
ORDER BY Sales DESC
LIMIT 5;

SELECT COUNT(*) AS High_Sales_Days 
FROM sales_analysis
WHERE Sales > 100000;

SELECT 
    LEFT(Date, 7) AS Month, 
    SUM(Sales) AS Total_Sales
FROM sales_analysis
GROUP BY Month
HAVING Total_Sales > 1000000;

SELECT 
    Date, 
    COALESCE(Sales, 0) AS Sales, 
    COALESCE(Cost_Of_Sales, 0) AS Cost_Of_Sales
FROM sales_analysis;

WITH yearly_sales AS (
    SELECT 
        LEFT(Date, 4) AS Year,
        SUM(Sales) AS Total_Sales
    FROM sales_analysis
    GROUP BY Year
)
SELECT 
    Year, 
    Total_Sales, 
    LAG(Total_Sales) OVER (ORDER BY Year) AS Previous_Year_Sales,
    ((Total_Sales - LAG(Total_Sales) OVER (ORDER BY Year)) / LAG(Total_Sales) OVER (ORDER BY Year)) * 100 AS YoY_Change_Percentage
FROM yearly_sales;

SELECT 
    Date, 
    Sales, 
    RANK() OVER (ORDER BY Sales DESC) AS Sales_Rank
FROM sales_analysis
LIMIT 10;

SELECT 
    Date,
    ((Quantity_Sold - LAG(Quantity_Sold) OVER (ORDER BY Date)) / LAG(Quantity_Sold) OVER (ORDER BY Date)) * 100 AS Percentage_Change_in_Quantity,
    ((Daily_Sales_Price_Per_Unit - LAG(Daily_Sales_Price_Per_Unit) OVER (ORDER BY Date)) / LAG(Daily_Sales_Price_Per_Unit) OVER (ORDER BY Date)) * 100 AS Percentage_Change_in_Price
FROM (
    SELECT 
        Date, 
        Sales / Quantity_Sold AS Daily_Sales_Price_Per_Unit, 
        Quantity_Sold
    FROM sales_analysis
) subquery;











