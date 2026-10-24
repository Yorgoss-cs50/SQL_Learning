-- Step 1 : Calculate Total Sales per customer ( Standalone CTE )
WITH CTE_Total_Sales AS (
SELECT
 custid AS CustomerID,
SUM(val) AS TotalSales
FROM Sales.OrderValues
GROUP BY custid
),
-- Step 2 : Find the last order date for each customer (Standalone CTE )
CTE_Last_Order AS (
SELECT
 custid AS CustomerID,
MAX(orderdate) AS Last_Order
FROM Sales.Orders
GROUP BY custid
),
-- Step 3 : Rank Customers based on Total Sales(Nested CTE)
CTE_Customer_Rank AS (
SELECT
CustomerID,
TotalSales,
RANK() OVER(ORDER BY TotalSales DESC) AS CustomerRank
FROM CTE_Total_Sales
),
-- Step 4 : Segment customers based on their total sales tier
CTE_Customer_Segments AS (
SELECT
CustomerID,
CASE
WHEN TotalSales > 100 THEN 'High'
WHEN TotalSales > 50 THEN 'Medium'
ELSE'Low'
END AS CustomerSegments
FROM CTE_Total_Sales
)
-- Main Query : Join the base dimension table with all  calculated CTE views
SELECT
c.custid AS CustomerID,
c.companyname AS FirstName,
cts.TotalSales,
clo.Last_Order,
ccr.CustomerRank,
ccs.CustomerSegments
FROM Sales.Customers  c 
LEFT JOIN CTE_Total_Sales  cts
ON c.custid = cts.CustomerID
LEFT JOIN CTE_Last_Order  clo
ON c.custid = clo.CustomerID
LEFT JOIN CTE_Customer_Rank  ccr
ON c.custid = ccr.CustomerID
LEFT JOIN CTE_Customer_Segments  ccs
ON c.custid = ccs.CustomerID;