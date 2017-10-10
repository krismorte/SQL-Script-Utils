/*Script to copy just on table at time

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/


--Export Table
Exec master..xp_cmdshell 'bcp "select * from Database..Table" queryout "d:\Table.bcp" -N -T -SServer'
--Import Table
Bulk insert Database..Table from 'd:\Table.bcp' WITH (DATAFILETYPE = 'native') 
