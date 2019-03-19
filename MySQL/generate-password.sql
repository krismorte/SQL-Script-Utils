-- FUNCTION
DELIMITER $$

CREATE FUNCTION generate_pass(length SMALLINT(3)) RETURNS varchar(100) CHARSET utf8 DETERMINISTIC
begin
    SET @returnStr = '';
    SET @allowedChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz@#$%*()+=_';
    SET @i = 0;

    WHILE (@i < length) DO
        SET @returnStr = CONCAT(@returnStr, substring(@allowedChars, FLOOR(RAND() * LENGTH(@allowedChars) + 1), 1));
        SET @i = @i + 1;
    END WHILE;

    RETURN @returnStr;
END


--CALL
SELECT generate_pass(10)