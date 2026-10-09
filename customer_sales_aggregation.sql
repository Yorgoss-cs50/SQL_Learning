USE TSQLV4;
GO

SELECT
C.custid,
C.companyname,
C.country,
COUNT(O.orderid) AS TotalOreders,
SUM(O.val) AS TotalSalesAmount,
AVG(O.val) AS AverageOrderValue
FROM
   Sales.Customers AS C
INNER JOIN
Sales.OrderValues AS O ON C.custid = O.custid
GROUP BY
    C.custid,
    C.companyname,
    C.country  
HAVING
   SUM(O.val) > 5000
ORDER BY
    TotalSalesAmount DESC;
   