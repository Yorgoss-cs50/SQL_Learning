USE TSQLV4;
GO

WITH CustomerSalesCTE AS (
SELECT
c.custid,
c.companyname,
c.country,
COUNT(DISTINCT o.orderid) AS TotalOrders,
-- Calculate net revenue after discounts , handling potential NULL's
COALESCE(SUM(od.qty * od.unitprice * ( 1 - od.discount)),0) AS TotalNetRevenue,
MAX(o.orderdate) AS LastOrderDate
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.custid = o.custid 
LEFT JOIN Sales.OrderDetails AS od
ON o.orderid = od.orderid
GROUP BY 
c.custid,
c.companyname,
c.country
),
RankedCustomersCTE AS (
SELECT 
custid,
companyname,
country,
TotalOrders,
CAST(TotalNetRevenue AS DECIMAL(10,2)) AS NetRevenue,
LastOrderDate,
-- Rank Customers by revenue within their specific country 
DENSE_RANK() OVER(
PARTITION BY country
ORDER BY TotalNetRevenue DESC
) AS CountryRevenueRank,
-- Segment customers into business tiers
CASE 
WHEN TotalNetRevenue >= 20000 THEN ' Tier 1 : VIP'
WHEN TotalNetRevenue >= 5000 THEN ' Tier 2 : Core'
WHEN TotalNetRevenue > 0 THEN 'Tier 3 : Standard'
ELSE 'Inactive'
END AS CustomerSegment
FROM CustomerSalesCTE
)
SELECT 
custid,
companyname,
country,
TotalOrders,
NetRevenue,
CountryRevenueRank,
CustomerSegment,
LastOrderDate
FROM RankedCustomersCTE
WHERE CountryRevenueRank <= 3 
ORDER BY 
country ASC,
CountryRevenueRank ASC;