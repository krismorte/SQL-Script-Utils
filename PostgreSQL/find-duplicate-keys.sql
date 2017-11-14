/*Query to find out duplicate key in a table

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

select <column_key1> ,<column_key2>,count(*)
	from <Search_Table>
	group by <column_key1> ,<column_key2>
	having count(*) >1