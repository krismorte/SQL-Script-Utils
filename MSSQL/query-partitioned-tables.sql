/*
Query partition tables, partitions and total rows per partition

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/
select distinct
	p.[object_id],
	OBJECT_NAME(p.[object_id]) AS TbName,
	ds.data_space_id,
	p.partition_number,
	p.rows,
	ds1.NAME AS [FILEGROUP_NAME],
	prv.value 
from sys.partitions p (nolock)
	inner join sys.indexes i (nolock)
		on p.[object_id] = i.[object_id] and p.index_id = i.index_id
	inner JOIN sys.data_spaces ds (nolock)
		on i.data_space_id = ds.data_space_id
	inner JOIN sys.partition_schemes ps (nolock)
		on ds.data_space_id = ps.data_space_id
	inner JOIN sys.partition_functions pf (nolock)
		on ps.function_id = pf.function_id
	inner join sys.destination_data_spaces dds (nolock)
		on dds.partition_scheme_id = ds.data_space_id and p.partition_number = dds.destination_id
	INNER JOIN sys.data_spaces ds1 (nolock)
		on ds1.data_space_id = dds.data_space_id
	left outer JOIN sys.partition_range_values prv (nolock)
		on prv.function_id = ps.function_id and p.partition_number = prv.boundary_id 