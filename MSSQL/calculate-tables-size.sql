/* To find tables size

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/
CREATE TABLE [dbo].[#tb_size](
	[Tabela] [nvarchar](128) NULL,
	[Linhas] [bigint] NOT NULL,
	[Reservado] [bigint] NULL,
	[Dados] [bigint] NULL,
	[Indice] [bigint] NULL,
	[NaoUtilizado] [bigint] NULL
) ON [PRIMARY]

insert into [#tb_size]

SELECT
    OBJECT_NAME(object_id) As Tabela, Rows As Linhas,
    SUM(Total_Pages * 8) As Reservado,
    SUM(CASE WHEN Index_ID > 1 THEN 0 ELSE Data_Pages * 8 END) As Dados,
        SUM(Used_Pages * 8) -
        SUM(CASE WHEN Index_ID > 1 THEN 0 ELSE Data_Pages * 8 END) As Indice,
    SUM((Total_Pages - Used_Pages) * 8) As NaoUtilizado
FROM 
    sys.partitions As P
    INNER JOIN sys.allocation_units As A ON P.hobt_id = A.container_id
    --where object_id=object_id('adc_con')
GROUP BY OBJECT_NAME(object_id), Rows


select * from [#tb_size] where Reservado-dados>1000