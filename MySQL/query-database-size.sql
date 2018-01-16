/*Query size of all tdatabases

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

SELECT table_schema "Data Base Name", sum( data_length + index_length) / 1024 / 1024 "Data Base Size in MB" 
FROM information_schema.TABLES 
GROUP BY table_schema ;