/*Kill all process in sleep on a RDS instance

@author Krisnamourt Filho - krisnamourt_ti@hotmail.com
*/


CREATE PROCEDURE `terminator`()
BEGIN
DECLARE n INT DEFAULT 0;
DECLARE i INT DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT CONCAT(@p1, ':', @p2);
END;

SELECT COUNT(*) from information_schema.processlist where
COMMAND = 'Sleep' and user <>'rdsadmin' INTO n;
SET i=0;
WHILE i<n DO
SET @cmd=(Select concat('CALL mysql.rds_kill(',id,');') from information_schema.processlist where
COMMAND = 'Sleep' and user <>'rdsadmin' limit 1 );
PREPARE stm FROM @cmd;
EXECUTE stm;
DEALLOCATE PREPARE stm;
SET i = i + 1;
END WHILE;
END;