SELECT * FROM adidas_sales.cleaned_adidas_sales;

# Insight Questions:

-- 1. Which retailer earns the lowest and highest revenue?
SELECT 
	Retailer,
	SUM(`Total Sales`) AS Total_Revenue
    FROM cleaned_adidas_sales
    GROUP BY Retailer
    ORDER BY Total_Revenue;

-- 2. Which state earns the lowest and highest revenue?
SELECT
	State,
    SUM(`Total Sales`) AS Total_Revenue
    FROM cleaned_adidas_sales
    GROUP BY State
    ORDER BY Total_Revenue DESC;

-- 3. Which retailer sells the most units but earns low profit?
SELECT
	Retailer,
	SUM(`Units Sold`) AS Total_Units_Sold,
    SUM(`Operating Profit`) AS Total_Profit,
    SUM(`Operating Profit`) / SUM(`Units Sold`) AS Profit_per_Unit
    FROM cleaned_adidas_sales
    GROUP BY Retailer
    ORDER BY Profit_per_Unit DESC;

-- 4. What product is most and least sold in each region?
SELECT
	Region,
    Product,
    Total_Units_Sold,
    'Most Sold' AS Category
FROM(
	SELECT 
		Region,
		Product, 
        SUM(`Units Sold`) AS Total_Units_Sold,
	RANK() OVER (
		PARTITION BY Region 
        ORDER BY SUM(`Units Sold`) DESC) AS Most_Product_per_Region
	FROM cleaned_adidas_sales
	GROUP BY Region, Product) ranked	
WHERE Most_Product_per_Region = 1

UNION ALL 

SELECT
	Region,
    Product,
    Total_Units_Sold,
    'Least Sold' AS Category
FROM(
	SELECT 
		Region,
		Product, 
        SUM(`Units Sold`) AS Total_Units_Sold,
	RANK() OVER (
		PARTITION BY Region 
        ORDER BY SUM(`Units Sold`)) AS Least_Product_per_Region
	FROM cleaned_adidas_sales
	GROUP BY Region, Product) ranked	
WHERE Least_Product_per_Region = 1;

-- 5. What is the most profitable product per region?
SELECT 
	Product,
    Region,
    Total_Profit_per_Region,
    'Most Profitable' AS Category
FROM 
	(
    SELECT 
		Region, 
        Product, 
        SUM(`Operating Profit`) AS Total_Profit_per_Region,
	RANK() OVER(
		PARTITION BY Region
        ORDER BY SUM(`Operating Profit`) DESC) AS Most_Profit_per_Region
	FROM cleaned_adidas_sales
    GROUP BY Region, Product) ranked_profit
WHERE Most_Profit_per_Region = 1

UNION ALL

SELECT 
	Product,
    Region,
    Total_Profit_per_Region,
    'Least Profitable' AS Category
FROM 
	(
    SELECT 
		Region, 
        Product, 
        SUM(`Operating Profit`) AS Total_Profit_per_Region,
	RANK() OVER(
		PARTITION BY Region
        ORDER BY SUM(`Operating Profit`)) AS Least_Profit_per_Region
	FROM cleaned_adidas_sales
    GROUP BY Region, Product) ranked_profit
WHERE Least_Profit_per_Region = 1;

-- 6. What products are most sold per region, monthly and quarterly?

WITH base AS (
    SELECT 
        DATE_FORMAT(`Invoice Date`, '%Y-%m') AS Month,
        CONCAT(YEAR(`Invoice Date`), '-Q', QUARTER(`Invoice Date`)) AS Quarter,
        Region,
        Product,
        `Units Sold`
    FROM cleaned_adidas_sales
)

-- MONTHLY 
SELECT
    'Monthly' AS Period_Type,
    Month AS Period,
    Region,
    Product,
    Total_Units
FROM (
    SELECT
        Month,
        Region,
        Product,
        SUM(`Units Sold`) AS Total_Units,
        RANK() OVER (
            PARTITION BY Month, Region
            ORDER BY SUM(`Units Sold`) DESC
        ) AS rnk
    FROM base
    GROUP BY Month, Region, Product
) m
WHERE rnk = 1

UNION ALL

-- MONTHLY (ALL Regions)
SELECT
    'Monthly' AS Period_Type,
    Month AS Period,
    'ALL' AS Region,
    Product,
    Total_Units
FROM (
    SELECT
        Month,
        Product,
        SUM(`Units Sold`) AS Total_Units,
        RANK() OVER (
            PARTITION BY Month
            ORDER BY SUM(`Units Sold`) DESC
        ) AS rnk
    FROM base
    GROUP BY Month, Product
) m_all
WHERE rnk = 1

UNION ALL

-- QUARTERLY 
SELECT
    'Quarterly' AS Period_Type,
    Quarter AS Period,
    Region,
    Product,
    Total_Units
FROM (
    SELECT
        Quarter,
        Region,
        Product,
        SUM(`Units Sold`) AS Total_Units,
        RANK() OVER (
            PARTITION BY Quarter, Region
            ORDER BY SUM(`Units Sold`) DESC
        ) AS rnk
    FROM base
    GROUP BY Quarter, Region, Product
) q
WHERE rnk = 1

UNION ALL

-- QUARTERLY (ALL Regions)
SELECT
    'Quarterly' AS Period_Type,
    Quarter AS Period,
    'ALL' AS Region,
    Product,
    Total_Units
FROM (
    SELECT
        Quarter,
        Product,
        SUM(`Units Sold`) AS Total_Units,
        RANK() OVER (
            PARTITION BY Quarter
            ORDER BY SUM(`Units Sold`) DESC
        ) AS rnk
    FROM base
    GROUP BY Quarter, Product
) q_all
WHERE rnk = 1;

-- 7. What is the most preferred method of buying products per Region and State?
SELECT
	'Region' AS Level,
    Region AS Location,
    `Sales Method`,
    Total_Count
FROM (
	SELECT
		Region, 
        `Sales Method`,
        COUNT(*) AS Total_Count,
		RANK() OVER (PARTITION BY Region ORDER BY COUNT(*) DESC) AS method_ranked
	FROM cleaned_adidas_sales
    GROUP BY Region, `Sales Method`
) ranked
WHERE method_ranked = 1

UNION ALL 

SELECT
	'State' AS Level,
    State AS Location,
    `Sales Method`,
    Total_Count
FROM (
	SELECT
		State, 
        `Sales Method`,
        COUNT(*) AS Total_Count,
		RANK() OVER (PARTITION BY State ORDER BY COUNT(*) DESC) AS method_ranked
	FROM cleaned_adidas_sales
    GROUP BY State, `Sales Method`
) ranked
WHERE method_ranked = 1;

-- 8. What is the monthly or quarterly sales trends per region and per state?
WITH date_base AS (
	SELECT
		DATE_FORMAT(`Invoice Date`, '%Y-%m') AS Month,
        CONCAT(YEAR(`Invoice Date`), '-Q', QUARTER(`Invoice Date`)) AS Quarter,
        `Total Sales`,
        Region, 
        State
	FROM cleaned_adidas_sales
)

-- Monthly
SELECT 
	'Monthly' AS Periodic_Type,
    Month AS Period, 
    Region, 
    State,
    SUM(`Total Sales`) AS Total_Revenue
FROM date_base
GROUP BY Region, State, Month

UNION ALL

SELECT 
	'Quarterly' AS Periodic_Type,
    Quarter AS Period, 
    Region, 
    State,
    SUM(`Total Sales`) AS Total_Revenue
FROM date_base
GROUP BY Region, State, Quarter;

-- 9. How does these variables: Price per Unit, Units Sold, Total Sales, Operating Profit, Operating Margin affect one another ?
SELECT 
	`Price per Unit`,
    `Units Sold`,
    `Total Sales`,
    `Operating Profit`,
    (`Operating Profit`/NULLIF(`Total Sales`, 0)) AS Profit_Margin
FROM cleaned_adidas_sales