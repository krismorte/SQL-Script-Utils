/*
Script to shrink all log files in all database


@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

declare @cmd nvarchar(4000)
declare @bd varchar(100)
declare @file nvarchar(100)
declare @size nvarchar(100)
declare pap_log cursor read_only forward_only for 

	SELECT 
	db_name(sf.dbid) as [Database_Name],
	sf.name as [File_Name],
	(sf.size/128.0 - CAST(FILEPROPERTY(file_name(fileid), 'SpaceUsed') AS int)/128.0) AS 'Available_Space_MB'

	FROM	master..sysaltfiles	sf
	WHERE	groupid = 0
	and db_name(sf.dbid) not in('model')
	ORDER BY	Available_Space_MB	DESC


open pap_log
fetch next from pap_log into @bd,@file,@size
while @@fetch_status = 0
begin 
	/*Choose you edition*/
	/*2005*/
	--set @cmd='backup log '+@bd+' with no_log ;use '+@bd+';dbcc shrinkfile(['+@file+'],0);'
	/*2000*/
	--set @cmd='backup log '+@bd+' with no_log ;use '+@bd+';dbcc shrinkfile('+@file+',0);'
	/*2008*/
	set @cmd='use '+@bd+';dbcc shrinkfile('+@file+',0);'
	exec sp_executeSQL @cmd
	declare @filepath varchar(100)
	print ''
	print @bd
	print rtrim(ltrim(@file+' '+@size))
	select @filepath=filename from master..sysaltfiles where name=@file
	print @filepath
	print ''
	fetch next from pap_log into @bd,@file,@size
end
close pap_log
deallocate pap_log
