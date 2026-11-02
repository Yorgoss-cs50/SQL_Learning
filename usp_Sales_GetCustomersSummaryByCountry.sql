USE TSQLV4;
GO

CREATE PROCEDURE Sales.GetCustomersSummaryByCountry
@Country AS NVARCHAR(50)
AS
BEGIN
SELECT
COUNT(*) AS TotalCustomers,
AVG(CAST(custid AS FLOAT)) AS AvgScore
FROM Sales.Customers
WHERE country = @country;
END;
GO
EXEC Sales.GetCustomersSummaryByCountry @Country = N'Germany';
EXEC Sales.GetCustomersSummaryByCountry @Country = N'USA';
GO