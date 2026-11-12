USE TSQLV4;
GO

-- Step 1 : Create a Partition Function
CREATE PARTITION FUNCTION PartitionByYear ( DATE )
AS RANGE LEFT FOR VALUES ('2014-12-31','2015-12-31','2016-12-31');
GO

SELECT
name,
function_id,
type,
type_desc,
boundary_value_on_right
FROM sys.partition_functions;
GO
