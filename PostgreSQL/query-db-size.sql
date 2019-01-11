/* 
    @author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/
--single database
select pg_size_pretty(pg_database_size('drupaldb'));

--all databases					   
SELECT pg_database.datname as "database_name", pg_database_size(pg_database.datname)/1024/1024 AS size_in_mb 
	FROM pg_database 
ORDER by size_in_mb DESC;