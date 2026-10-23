USE TSQLV4;
GO

-- Step 1 : Find the total sales per Customer using Sales.OrderValues
WITH CTE_Total_Sales AS (
SELECT
custid,
SUM(val) AS TotalSales
FROM Sales.OrderValues
GROUP BY custid
),
-- Step 2 : Find the last order date for each customer from Sales.Orders
CTE_Last_Order AS (
SELECT
custid,
MAX(orderdate) AS Last_Order
FROM Sales.Orders
GROUP BY custid
)
-- Main Query : Combine customer infromation with sales and last order metrics 
SELECT
c.custid,
c.contactname,
cts.TotalSales,
clo.Last_Order
FROM Sales.Customers AS c
LEFT JOIN CTE_Total_Sales AS cts
ON c.custid = cts.custid
LEFT JOIN CTE_Last_Order AS clo
ON c.custid = clo.custid;