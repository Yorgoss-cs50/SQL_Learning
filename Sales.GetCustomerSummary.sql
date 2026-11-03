USE TSQLV4;
GO
--1. Prepare Table 
IF NOT EXISTS (
SELECT 1 FROM sys.columns
WHERE object_id = OBJECT_ID('Sales.Customers') AND name =  'Score'
)
BEGIN 
ALTER TABLE Sales.Customers ADD Score INT NULL;
END;
GO
--2.Create Or Alter the Stored Procedure
--======================================
CREATE OR ALTER PROCEDURE Sales.GetCustomerSummary
@Country NVARCHAR(50) = 'USA'
AS 
BEGIN
--Declare local aggregation variables
DECLARE @TotalCustomers INT , @AvgScore FLOAT;
-- Data CleanUp Section
IF EXISTS (
SELECT 1
FROM Sales.Customers
WHERE Score IS NULL AND Country = @Country
)
BEGIN 
PRINT'Updating NULL Scores to 0...';
UPDATE Sales.Customers
SET Score = 0
WHERE Score IS NULL AND Country = @Country;
END 
ELSE
BEGIN
PRINT'No NULL Scores Found.';
END;
--Core Logic Report Generation
BEGIN TRY
--Query 1 : Calculate metrics and store them into variables
SELECT
@TotalCustomers = COUNT(*),
@AvgScore = AVG(CAST(Score AS FLOAT))
FROM Sales.Customers
WHERE Country = @Country;
--Print statements with correct closed quotation marks and string casting
PRINT'Total Customers from ' + @Country + ' : ' + CAST(ISNULL(@TotalCustomers, 0) AS VARCHAR(10));
PRINT'Average Score from ' + @Country + ' : ' + CAST(ISNULL(@AvgScore, 0) AS VARCHAR(10));
--Query 2 : Get Order Totals and sales totales
SELECT
COUNT(ov.orderid) AS TotalOrders,
SUM(ov.val) AS TotalSales
FROM Sales.OrderValues AS ov
INNER JOIN Sales.Customers AS c
ON c.custid = ov.custid
WHERE c.country = @Country;
END TRY
BEGIN CATCH 
PRINT'An error occured during report generation.';
END CATCH;
END;
GO
--==================================================
--3.RUN AND TEST THE PROCEDURE
--==================================================
EXEC Sales.GetCustomerSummary @Country = 'Germany';
GO