/*Query size of all tdatabases

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

SHOW INDEX FROM yourtable;


SELECT DISTINCT
    TABLE_NAME,
    INDEX_NAME
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'your_schema';