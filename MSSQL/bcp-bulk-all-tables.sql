/* Backup All tables datas

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

select 'Exec master..xp_cmdshell ''bcp "select * from '+db_name()+'..'+name+'" queryout "w:\sqlbackups\'+name+'.bcp" -n -T -S'+@@servername+''''
from sysobjects where xtype='U'

select 'Bulk insert '+db_name()+'..'+name+' from ''w:\sqlbackups\tclou.bcp'' WITH (DATAFILETYPE = ''native'') '
from sysobjects where xtype='U'