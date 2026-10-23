USE TSQLV4;
GO

SELECT
orderid,
custid,
empid,
orderdate,
shipperid
FROM Sales.Orders
WHERE custid IN (
SELECT custid
FROM Sales.Customers
WHERE country = N'Spain'
);