
-- PROCEDIMIENTO QUE INSERTA A LA TABLA DEPARMENTS
USE HR;
DELIMITER $$
CREATE PROCEDURE `HR`.`insert_departments`()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE count_inserted INT DEFAULT 0;
    DECLARE count_errors INT DEFAULT 0;
    DECLARE id INT;
    DECLARE department VARCHAR(100);

    DECLARE cur CURSOR FOR 
        SELECT do.id, UPPER(TRIM(do.department)) department
        FROM HR.departments_origen do
        LEFT JOIN HR.tb_departments d 
        ON do.id = d.department_id 
        WHERE d.department_id IS NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO id, department;

        IF done THEN
            LEAVE read_loop;
        END IF;

        BEGIN
            INSERT INTO HR.tb_departments (department_id, department) VALUES (id, department);
            SET count_inserted = count_inserted + ROW_COUNT();
        END;
        
        IF ROW_COUNT() = 0 THEN
            SET count_errors = count_errors + 1;
        END IF;

    END LOOP;

    CLOSE cur;

    SELECT CONCAT('Se insertaron ', count_inserted, ' registros en la tabla HR.tb_departments. Se presentaron ', count_errors, ' errores.') AS message;
END;
$$
DELIMITER ;


-- PROCEDIMIENTO QUE INSERTA A LA TABLA JOBS
USE HR;
DELIMITER $$
CREATE PROCEDURE `HR`.`insert_jobs`()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE count_inserted INT DEFAULT 0;
    DECLARE count_errors INT DEFAULT 0;
    DECLARE id INT;
    DECLARE job VARCHAR(100);

    DECLARE cur CURSOR FOR 
        SELECT oo.id, UPPER(TRIM(oo.job)) job  
        FROM HR.jobs_origen oo
        LEFT JOIN HR.tb_jobs o 
        ON oo.id = o.job_id 
        WHERE o.job_id  IS NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET count_errors = count_errors + 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO id, job;

        IF done THEN
            LEAVE read_loop;
        END IF;

        BEGIN
            INSERT INTO HR.tb_jobs (job_id, job) VALUES (id, job);
            SET count_inserted = count_inserted + 1;
        END;
    END LOOP;

    CLOSE cur;

    SELECT CONCAT('Se insertaron ', count_inserted, ' registros en la tabla HR.tb_jobs. Se presentaron ', count_errors, ' errores.') AS message;
END
$$
DELIMITER ;


-- PROCEDIMIENTO QUE INSERTA A LA TABLA HIRED EMPLOYEES

USE HR;
DELIMITER $$
CREATE PROCEDURE HR.insert_hired_employees()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE count_inserted INT DEFAULT 0;
    DECLARE count_errors INT DEFAULT 0;
    DECLARE id INT;
    DECLARE name VARCHAR(100);
    DECLARE datetime DATETIME;
    DECLARE department_id INT;
    DECLARE job_id INT;
    DECLARE fecha_completa DATETIME;

    DECLARE cur CURSOR FOR 
        SELECT heo.id, UPPER(TRIM(heo.name)) name,
        	CAST(CONCAT(LEFT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),4), '-', 
                            REPLACE(LEFT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),6), LEFT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),4),''), '-', 
                            RIGHT(LEFT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),8),2), ' ', 
                            LEFT(RIGHT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),6),2), ':', 
                            REPLACE(RIGHT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),4),RIGHT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),2),''), ':', 
                            RIGHT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),2)) AS DATETIME) datetime,
            heo.department_id, heo.job_id
        FROM HR.hired_employees_origen heo
        LEFT JOIN HR.tb_hired_employees he 
        ON heo.id = he.hired_employee_id 
        WHERE he.hired_employee_id IS NULL
        AND heo.id != 1814;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET count_errors = count_errors + 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO id, name, datetime, department_id, job_id;

        IF done THEN
            LEAVE read_loop;
        END IF;

        BEGIN
            INSERT INTO HR.tb_hired_employees (hired_employee_id, name, datetime, department_id, job_id) 
            VALUES (id, name, datetime, department_id, job_id);
            SET count_inserted = count_inserted + 1;
        END;
    END LOOP;

    CLOSE cur;

    SELECT CONCAT('Se insertaron ', count_inserted, ' registros en la tabla HR.tb_hired_employees. Se presentaron ', count_errors, ' errores.') AS message;
END
$$
DELIMITER ;
--