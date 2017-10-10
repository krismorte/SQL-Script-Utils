/*procedure that's split text*/

create proc split_function
@ARRAY VARCHAR(8000), @DELIMITADOR VARCHAR(100)
as
begin
SET NOCOUNT ON
 
DECLARE @S VARCHAR(8000)
 
-- VALORES PASSADOS PARA A VARIAVEL @ARRAY
--SELECT @ARRAY = 'OLA ,TUDO BEM, MAIS OU MENOS, TRANQUILIS'
-- SETANDO O DELIMITADOR
--SELECT @DELIMITADOR = ','
 
IF LEN(@ARRAY) > 0 SET @ARRAY = @ARRAY + @DELIMITADOR 
CREATE TABLE #ARRAY(ITEM_ARRAY VARCHAR(8000))
 
WHILE LEN(@ARRAY) > 0
BEGIN
   SELECT @S = LTRIM(SUBSTRING(@ARRAY, 1, CHARINDEX(@DELIMITADOR, @ARRAY) - 1))
   INSERT INTO #ARRAY (ITEM_ARRAY) VALUES (@S)
   SELECT @ARRAY = SUBSTRING(@ARRAY, CHARINDEX(@DELIMITADOR, @ARRAY) + 1, LEN(@ARRAY))
END
 
-- MOSTRANDO O RESULTADO JÁ POPULADO NA TABELA TEMPORÁRIA
SELECT * FROM #ARRAY
DROP TABLE #ARRAY
 
SET NOCOUNT OFF
end

/*example*/
--exec split_function 'OLA ,TUDO BEM, MAIS OU MENOS, TRANQUILIS',','