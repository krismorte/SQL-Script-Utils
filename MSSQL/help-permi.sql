/*procedure that helps given permission

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

create proc ups_permihelp 
@username sysname,
@base sysname,
@permi sysname,
@login bit = 0
as
begin

declare @cmd nvarchar(4000)
declare @role nvarchar(4000)
set @cmd =''
if(@login=1)
begin
	set @cmd ='exec xp_grantlogin ['+@username+']'+char(13)
end

if(@permi='R')
begin
	set @role='exec sp_addrolemember db_datareader,['+@username+']'
end 
else if(@permi='W')
begin
	set @role='exec sp_addrolemember db_datawriter,['+@username+']'
end 
else if(@permi='RW')
begin
	set @role='exec sp_addrolemember db_datareader,['+@username+']
	exec sp_addrolemember db_datawriter,['+@username+']'
end 
else if(@permi='O')
begin
	set @role='exec sp_addrolemember db_owner,['+@username+']'
end 
else 
begin
	set @role='exec sp_addrolemember ['+@permi+'],['+@username+']'
end


set @cmd +='use ['+@base+']'+char(13)+'go
exec sp_grantdbaccess ['+@username+']'+char(13)+@role

exec sp_executeSQL @cmd

end