/*Query size of all tdatabases

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

select sb.name,
ltrim(rtrim((select str(sum(convert(dec(17,2),size)) / 128,10,2) from dbo.sysaltfiles where dbid = db_id(sb.name)))) as size_mb
 from sysdatabases sb
 union all
select distinct 'total',
ltrim(rtrim((select str(sum(convert(dec(17,2),size)) / 128,10,2) from dbo.sysaltfiles ))) as size_mb
 from sysdatabases sb