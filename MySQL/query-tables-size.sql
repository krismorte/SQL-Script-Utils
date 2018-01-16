
/*Query size of all tables

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

SELECT table_name, table_rows, data_length, index_length,round(((data_length + index_length) / 1024 / 1024),2) "Size in MB"
FROM information_schema.TABLES 
where table_schema = "schema_name";