-- =============================================
-- T_SQL Indexing Practice : Rowstore VS ColumnStore efficiency
--Target Database : TSQLV4
-- =============================================
USE TSQLV4;
GO

-- --------------------------------------------------
-- Step 1 : Create a Heap (No Indexes)
-- --------------------------------------------------
IF OBJECT_ID('Sales.Orders_HEAP' , 'U') IS NOT NULL
DROP TABLE Sales.Orders_HEAP;
-- Copying the standard TSQL4 Orders data into a new Heap table
SELECT *
INTO Sales.Orders_HEAP
FROM Sales.Orders;
GO
-- -----------------------------------------------------
-- Step 2 : Create a Traditional RowSotre Table with Clustered and Non_Clustered Indexes
-- -------------------------------------------------------
IF OBJECT_ID('Sales.Orders_RS' , 'U') IS NOT NULL
DROP TABLE Sales.Orders_RS;

SELECT *
INTO Sales.Orders_RS
FROM Sales.Orders;
GO
-- Create a Clustered ROWSTORE Index (Primary Structure based on OrderID)
CREATE CLUSTERED INDEX idx_Orders_RS_OrderID
ON Sales.Orders_RS (orderid);
GO
--Create a Non_Clustered ROWSTORE Index to optimize lookups by Customer
CREATE NONCLUSTERED INDEX idx_Orders_RS_CustID
ON Sales.Orders_RS (custid)
INCLUDE (requireddate , freight);
GO
-- -----------------------------------------------------
-- Step 4 : Analyze and Compare Storage Space
-- ------------------------------------------------------
SELECT
t.name AS TableName,
i.name AS IndexName,
i.type_desc AS IndexType,
p.rows AS RowCounts,
SUM(a.total_pages) * 8 AS TotalSpaceKB,
SUM(a.used_pages) * 8 AS UsedSpaceKB
FROM sys.tables t
INNER JOIN sys.indexes i 
ON t.object_id = i.object_id
INNER JOIN sys.partitions p 
ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a 
ON p.partition_id = a.container_id
WHERE 
t.name IN ('Orders_HEAP' , 'Orders_RS' , 'Orders_CS')
GROUP BY 
t.NAME, i.name, i.type_desc , p.rows
ORDER BY 
TotalSpaceKB DESC;
GO