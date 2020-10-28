/*Query all columns by table

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

select COLUMN_NAME from information_schema.columns
where table_name = 'YOUR TABLE'
order by table_name,ordinal_position