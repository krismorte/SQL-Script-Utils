/* 
Script to delete huge table without having disc space problems

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/

declare @var int, @var2 int
set @var = (select count(1) from <Table_to_Delete> WHERE <Your-delete-clause>)
set @var2 = 0

while @var2 <> @var
begin
	set rowcount 50000--batchsize

	print getdate()
	delete from <Table_to_Delete>  WHERE <Your-delete-clause>

	set @var2 = @var2+@@ROWCOUNT
	print getdate()

	checkpoint--it's optional for avoid log grow

end