-- CREA LAS TABLAS ORIGEN
CREATE TABLE HR.hired_employees_origen(
	id int,
	name nvarchar(255),
	datetime nvarchar(255),
	department_id int,
	job_id int,
	created_at datetime default now()
);

CREATE TABLE HR.departments_origen(
	id int,
	department nvarchar(255),
	created_at datetime default now()
);

CREATE TABLE HR.jobs_origen(
	id int,
	job nvarchar(255),
	created_at datetime default now()

);

-- CREA LAS TABLAS LIMPIAS

CREATE TABLE HR.tb_departments (
	department_id 	int primary key,
	created_at 		datetime default now(),
	updated_at 		datetime default now(),
	deleted_at 		datetime,
	department 		nvarchar(255)	
);

CREATE TABLE HR.tb_jobs (
	job_id 		int primary key,
	created_at 	datetime default now(),
	updated_at 	datetime default now(),
	deleted_at 	datetime,
	job 		nvarchar(255)	
);

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
);