-- Helper Query : Run the first to see your exact DATA folder path
SELECT physical_name
FROM sys.database_files;
GO

USE TSQLV4;
GO
ALTER DATABASE TSQLV4 ADD FILE
(
NAME = P_2014,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2014.ndf'
) TO FILEGROUP FG_2014;
ALTER DATABASE TSQLV4 ADD FILE
(
NAME = P_2015,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2015.ndf'
) TO FILEGROUP FG_2015;
ALTER DATABASE TSQLV4 ADD FILE
(
NAME = P_2016,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2016.ndf'
) TO FILEGROUP FG_2016
ALTER DATABASE TSQLV4 ADD FILE
(
NAME = P_2017,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2017.ndf'
) TO FILEGROUP FG_2017;
GO
-- Verify all physical files are mapped to the right filegroups
SELECT
fg.name AS FilegroupName,
mf.name AS LogicalFileName,
mf.physical_name AS PhysicalFilePath,
mf.size / 128 AS SizeInMB
FROM sys.filegroups fg
JOIN sys.master_files mf ON fg.data_space_id = mf.data_space_id
WHERE mf.database_id = DB_ID('TSQLV4');
GO
