/*Query to generate a MD5 per row to help you to find differences

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

select concat('select MD5(concat(',GROUP_CONCAT(col_quote),')) from ',table_name) from (
	select CONCAT('QUOTE(',COLUMN_NAME,')') as col_quote, table_name from information_schema.columns
	where table_name = 'YOURTABLE'
	order by table_name,ordinal_position
) as tb