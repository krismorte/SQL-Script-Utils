/*
kill all processes running in the specific database
*/

declare @database sysname
set @database='dbinovar'

declare @scrRipper nvarchar(500)
set @scrRipper=''
select @scrRipper =@scrRipper+'kill '+convert(varchar,spid)+CHAR(13) from sysprocesses where dbid=db_id(@database)
exec sp_executesql @scrRipper