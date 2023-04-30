-- Crear las tablas Origen
CREATE TABLE HR.hired_employees_origen(
	id 				int,
	name 			nvarchar(255),
	datetime 		nvarchar(255),
	department_id	int,
	job_id			int,
	created_at		datetime default now()
)

CREATE TABLE HR.departments_origen(
	id int,
	department	nvarchar(255),
	created_at		datetime default now()
)

CREATE TABLE HR.jobs_origen(
	id	int,
	job nvarchar(255),
	created_at		datetime default now()

)

-- Crear las tablas donde la información se almacena de forma limpia

CREATE TABLE HR.tb_departments (
	department_id 	int primary key,
	created_at 		datetime default now(),
	updated_at 		datetime default now(),
	deleted_at 		datetime,
	department 		nvarchar(255)	
)

CREATE TABLE HR.tb_jobs (
	job_id 		int primary key,
	created_at 	datetime default now(),
	updated_at 	datetime default now(),
	deleted_at 	datetime,
	job 		nvarchar(255)	
)

CREATE TABLE HR.tb_hired_employees (
	hired_employee_id 	int primary key,
	created_at 			datetime default now(),
	updated_at 			datetime default now(),
	deleted_at 			datetime,	
	name 				nvarchar(255),
	datetime 			datetime,
	department_id 		int,
	job_id 				int,
	FOREIGN KEY(department_id) REFERENCES tb_departments(department_id),
	FOREIGN KEY(job_id) REFERENCES tb_jobs(job_id)	
)

-- INSERTA A LAS TABLAS LIMPIAS


-- Inserta a la tabla limpi a de 
INSERT INTO HR.tb_departments (department_id, department)
SELECT do.id, UPPER(TRIM(do.department)) department
 FROM HR.departments_origen do
  LEFT JOIN HR.tb_departments d 
   ON do.id = d.department_id 
WHERE d.department_id  IS NULL

INSERT INTO HR.tb_jobs (job_id, job)
SELECT oo.id, UPPER(TRIM(oo.job)) job  
 FROM HR.jobs_origen oo
  LEFT JOIN HR.tb_jobs o 
   ON oo.id = o.job_id 
WHERE o.job_id  IS NULL

INSERT INTO HR.tb_hired_employees (hired_employee_id, name, datetime, department_id, job_id)
SELECT heo.id, UPPER(TRIM(heo.name)) name, 
	CAST(CONCAT(LEFT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),4), '-', 
	   		  			 REPLACE(LEFT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),6), LEFT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),4),''), '-', 
	   					 RIGHT(LEFT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),8),2), ' ', 
	   					 LEFT(RIGHT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),6),2), ':', 
	   					 REPLACE(RIGHT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),4),RIGHT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),2),''), ':', 
	   					 RIGHT(REGEXP_REPLACE(heo.datetime, '[^0-9!@#]', ''),2)) AS DATETIME)fecha_completa, heo.department_id, heo.job_id	
 FROM HR.hired_employees_origen heo
  LEFT JOIN HR.tb_hired_employees he
   ON heo.id = he.hired_employee_id 
WHERE he.hired_employee_id IS NULL;


--=============== PUNTO 1	
 		
	SELECT department, job, 
		   SUM(CASE WHEN Q = 'Q1-21' THEN 1 ELSE 0 END) AS 'Q1-21',
		   SUM(CASE WHEN Q = 'Q2-21' THEN 1 ELSE 0 END) AS 'Q2-21',
		   SUM(CASE WHEN Q = 'Q3-21' THEN 1 ELSE 0 END) AS 'Q3-21',
		   SUM(CASE WHEN Q = 'Q4-21' THEN 1 ELSE 0 END) AS 'Q4-21'
	FROM (
			  SELECT 	td.department, tj.job, 
					    CASE
					      WHEN MONTH(the.datetime) IN (1,2,3) THEN CONCAT('Q1-', RIGHT(YEAR(the.datetime),2))
					      WHEN MONTH(the.datetime) IN (4,5,6) THEN CONCAT('Q2-', RIGHT(YEAR(the.datetime),2))
					      WHEN MONTH(the.datetime) IN (7,8,9) THEN CONCAT('Q3-', RIGHT(YEAR(the.datetime),2))
					      WHEN MONTH(the.datetime) IN (10,11,12) THEN CONCAT('Q4-', RIGHT(YEAR(the.datetime),2))
					      ELSE NULL
					    END Q
			  FROM HR.tb_hired_employees the
			  	INNER JOIN HR.tb_departments td 
			  		ON the.department_id = td.department_id 
			  	INNER JOIN HR.tb_jobs tj 
			  		ON the.job_id  = tj.job_id 
			 WHERE YEAR(the.datetime) = 2021
	)t
	GROUP BY department, job
	ORDER BY department, job
	

	
	-- PUNTO 2
	
	SELECT td.department_id ,td.department, count(1) hired
	 FROM HR.tb_hired_employees the
	  JOIN HR.tb_departments td 
	   ON the.department_id = td.department_id 
	GROUP BY td.department_id ,td.department
	HAVING count(1) > (	SELECT AVG(contratos) AVG_CONTRATOS
						 FROM (
								SELECT the.department_id, count(1) contratos
									FROM  HR.tb_hired_employees the  
								WHERE YEAR(the.datetime) = 2021
								AND the.department_id IS NOT NULL
								GROUP BY the.department_id 
							)A)
	ORDER BY 3 DESC