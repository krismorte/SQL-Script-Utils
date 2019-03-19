--VIEW
CREATE VIEW [dbo].[vwGetNewId]
AS
SELECT        NEWID() AS Id
GO

--FUNCTION

create FUNCTION [dbo].[generate_pass](@length INT = 8)
RETURNS NVARCHAR(MAX)
AS
BEGIN

DECLARE @result CHAR(2000);

DECLARE @String VARCHAR(2000);

SET @String = 'abcdefghijklmnopqrstuvwxyz' + --lower letters
'ABCDEFGHIJKLMNOPQRSTUVWXYZ' + --upper letters
'1234567890'+--number characters
'@#$%*()+=_'; --special characters

SELECT @result =
(
    SELECT TOP (@length)
           SUBSTRING(@String, 1 + number, 1) AS [text()]
    FROM master..spt_values
    WHERE number < DATALENGTH(@String)
          AND type = 'P'
    ORDER BY
(
    SELECT TOP 1 Id FROM dbo.vwGetNewId
)   --instead of using newid()
    FOR XML PATH('')
);

RETURN @result;

END;
GO
--CALL

select [dbo].[generate_pass](10)