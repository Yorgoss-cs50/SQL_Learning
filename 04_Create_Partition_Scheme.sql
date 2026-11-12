-- Step 4 : Create a partition schema
CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2014,FG_2015,FG_2016,FG_2017);
GO
-- Verify the partition scheme mapping
SELECT
ps.name AS PartitionSchemeName,
pf.name AS PartitionFunctionName,
ds.destination_id AS PartitionNumber,
fg.name AS FileGroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds ON ps.data_space_id = ds.partition_scheme_id
JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id;
GO