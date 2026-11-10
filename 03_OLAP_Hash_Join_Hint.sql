-- Focus : Hash Match Join
SELECT o.orderid,o.custid,c.companyname,c.contactname
FROM Sales.Orders AS o
JOIN Sales.Customers AS c
ON o.custid = c.custid
OPTION ( HASH JOIN );