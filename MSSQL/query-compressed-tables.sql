/* 
Script to fint all compressed tables

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/


SELECT st.name, ix.name , st.object_id, sp.partition_id, sp.partition_number, sp.data_compression,sp.data_compression_desc
FROM sys.partitions SP 
INNER JOIN sys.tables ST ON st.object_id = sp.object_id 
LEFT OUTER JOIN sys.indexes IX ON sp.object_id = ix.object_id and sp.index_id = ix.index_id
WHERE sp.data_compression <> 0
order by st.name, sp.index_id 