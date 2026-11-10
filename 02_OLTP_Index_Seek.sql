-- Focus : Index Seek, Key Lookup,and Nested Loops Join
SELECT orderid,orderdate,shipcity,custid
FROM Sales.Orders
WHERE custid = 1;