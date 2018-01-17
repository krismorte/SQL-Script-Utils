/*Script to generate restore statement

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

create proc Restore_Database 
@dirMDF varchar(500),
@dirLDF varchar(500)= null,
@dbName sysname,
@filePath varchar(500)
as
begin
	DECLARE @CMD nvarchar(4000)

	if @dirLDF is null
	begin
		set @dirLDF=@dirMDF
	end

	declare @filelist table (LogicalName nvarchar(128), PhysicalName nvarchar(260), Type char(1), FilegroupName varchar(10), size bigint, MaxSize bigint, field int, createlsn bit, droplsn bit, uniqueid uniqueidentifier, readonlylsn bit, readwritelsn bit, backupsizeinbytes bigint, sourceblocksize int, filegroupid int, loggroupguid uniqueidentifier, differentialbaselsn bit, differentialbaseguid uniqueidentifier, isreadonly bit, ispresent bit, tdethumbprint varchar(5));
	set @CMD=N'restore filelistonly from disk='''+@filePath+''''
	insert into @filelist exec sp_executesql @CMD;

	set @CMD='restore database '+@dbName+' from disk='''+@filePath+''' with stats=1,'+char(13)
	declare @logicalName sysname
	declare @PhysicalName sysname
	declare @lastBash int
	while (select count(1) from @filelist where [type]='D')>0
		begin
		select top 1 @logicalName=LogicalName, @PhysicalName=PhysicalName from @filelist where [type]='D'
		
		SET @lastBash = LEN(@PhysicalName) - CHARINDEX('\',REVERSE(@PhysicalName))+1
		set @PhysicalName=@dirMDF+ SUBSTRING(@PhysicalName,@lastBash+1,LEN(@PhysicalName) )

		set @CMD=+@CMD+'move '''+@logicalName+''' to'''+@PhysicalName+''','+char(13)
		delete from @filelist where logicalName=@logicalName
	end

	while (select count(1) from @filelist where [type]='L')>0
	begin
		select top 1 @logicalName=LogicalName, @PhysicalName=PhysicalName from @filelist where [type]='L'
		print @logicalName
		SET @lastBash = LEN(@PhysicalName) - CHARINDEX('\',REVERSE(@PhysicalName))+1
		set @PhysicalName=@dirLDF+ SUBSTRING(@PhysicalName,@lastBash+1,LEN(@PhysicalName) )

		set @CMD=+@CMD+'move '''+@logicalName+''' to'''+@PhysicalName+''','+char(13)
		delete from @filelist where logicalName=@logicalName
	end
	set @CMD=substring(@CMD,0,len(@CMD)-1)
	print @CMD
end
