/*Query script to create all indexes

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/


SELECT TABLE_NAME,
    INDEX_NAME, 
    concat('create index ',INDEX_NAME, ' on ',TABLE_NAME,'(',GROUP_CONCAT(COLUMN_NAME),');')
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'DATABSE_NAME'
-- and TABLE_NAME in ('TABLE_NAME') --Just for some tables
-- and INDEX_NAME <> 'PRIMARY' -- except primary key indexes
group by 
    TABLE_NAME,
    INDEX_NAME;