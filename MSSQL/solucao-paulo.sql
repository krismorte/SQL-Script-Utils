
declare @file varchar(500)
declare @datatexto varchar(50)
set @file ='colibri8-20181002050023-(a710e507-e771-4d83-97be-2f77d1df2560)-Full'
select charindex('-',@file), charindex('-',substring(@file,10, len(@file))) 
set @datatexto = substring(@file,charindex('-',@file)+1,charindex('-',substring(@file,10, len(@file)))-1)
select @datatexto 
set @datatexto = (substring(@datatexto,0,5)+'-'+substring(@datatexto,5,2)+'-'+substring(@datatexto,7,2)+' '
+substring(@datatexto,9,2)+':'+substring(@datatexto,11,2)+':'+substring(@datatexto,13,2))
select convert(datetime,@datatexto )



