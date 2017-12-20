/*Script to move database through backup/restore commands

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

declare @db sysname
declare @bkpPath varchar(2000)
declare @restorePath varchar(2000)
declare @restoreCommand varchar(4000)

set @db='saude'
set @bkpPath='I:\'
set @restorePath='I:\saude2\'

print 'exec xp_cmdshell ''mkdir '+@bkpPath+@db+''''
print 'backup database '+@db+' to disk ='''+@bkpPath+@db+'.bak'' with stats=1,compression'+CHAR(13)

set @restoreCommand='restore database '+@db+' from disk ='''+@bkpPath+@db+'.bak'' with stats=1,'+CHAR(13)
SELECT  @restoreCommand=@restoreCommand+'MOVE '+''''+name+''+'''to'''+''+ @restorePath+
Substring(FILENAME, LEN(FILENAME) -  Charindex('\',Reverse(FILENAME))+2, LEN(FILENAME)) +''','+CHAR(13) FROM master..sysaltfiles where dbid=db_id(@db)
print Substring(@restoreCommand,1,len(@restoreCommand)-2)