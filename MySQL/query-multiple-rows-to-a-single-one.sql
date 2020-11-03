/*Get multiple rows into a single one, below an example of all tables names

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

SELECT GROUP_CONCAT(table_name) FROM information_schema.tables 
where TABLE_SCHEMA ='YOUR DATABASE' 
and TABLE_TYPE='BASE TABLE';
