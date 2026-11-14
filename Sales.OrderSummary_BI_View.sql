USE TSQLV4; 
GO
CREATE OR ALTER VIEW Sales.vw_OrderSummary AS
SELECT
o.orderid AS OrderID,
o.orderdate AS OrderDate,
YEAR(o.orderdate) AS OrderYear,
MONTH(o.orderdate) AS OrderMonth,
c.companyname AS CustomerName,
c.country AS CustomerCountry,
cat.categoryname AS Category,
p.productname AS ProductName,
od.qty AS Quantity,
CAST(od.qty * od.unitprice * (1 - od.discount) AS DECIMAL(10,2)) AS NetAmount
FROM Sales.Orders AS  o 
INNER JOIN Sales.Customers AS c
ON o.custid = c.custid
INNER JOIN Sales.OrderDetails AS od
ON o.orderid = od.orderid
INNER JOIN Production.Products AS p
ON od.productid = p.productid
INNER JOIN Production.Categories AS cat
ON p.categoryid = cat.categoryid;
GO
-- Test your newly created View:
SELECT TOP 20 *
FROM Sales.vw_OrderSummary
ORDER BY NetAmount DESC;
