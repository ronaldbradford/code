DELIMITER $$
DROP PROCEDURE IF EXISTS run_in_all_schemas$$
CREATE PROCEDURE run_in_all_schemas()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE val VARCHAR(64);
  DECLARE cnt INT DEFAULT 0;
  DECLARE total INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT schema_name FROM INFORMATION_SCHEMA.SCHEMATA WHERE schema_name NOT IN ('mysql','test','information_schema','performance_schema') ORDER BY 1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  SELECT COUNT(*) INTO total FROM INFORMATION_SCHEMA.SCHEMATA WHERE schema_name NOT IN ('mysql','test','information_schema','performance_schema');

  OPEN cur;
  l: LOOP
    FETCH cur INTO val;
    IF done THEN
      LEAVE l;
    END IF;
    SET cnt := cnt + 1;
    SELECT CONCAT(cnt,'/',total,' - ',val) AS t;

    /* SET @sql=CONCAT('UPDATE ',val,'.tbl SET col1=val2'); */
    SET @sql=CONCAT('SELECT NOW()');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


  END LOOP;

  CLOSE cur;
END$$
DELIMITER ;
