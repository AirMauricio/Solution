-- CREA VISTA view_department_hires_above_mean_2021
USE HR;
CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW HR.view_department_hires_above_mean_2021 AS
SELECT
    td.department_id AS department_id,
    td.department AS department,
    COUNT(1) AS hired
FROM
    HR.tb_hired_employees AS the
    JOIN HR.tb_departments AS td ON the.department_id = td.department_id
GROUP BY
    td.department_id,
    td.department
HAVING
    COUNT(1) > (
        SELECT AVG(a.contratos) AS AVG_CONTRATOS
        FROM (
            SELECT
                the.department_id AS department_id,
                COUNT(1) AS contratos
            FROM
                HR.tb_hired_employees AS the
            WHERE
                YEAR(the.datetime) = 2021 AND the.department_id IS NOT NULL
            GROUP BY
                the.department_id
        ) AS a
    )
ORDER BY
    COUNT(1) DESC;

-- CREA VISTA view_employee_hires_by_job_and_dept_2021_quarterly
USE HR;
CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW HR.view_employee_hires_by_job_and_dept_2021_quarterly AS
select
    t.department AS department,
    t.job AS job,
    sum((case when (t.Q = 'Q1-21') then 1 else 0 end)) AS 'Q1-21',
    sum((case when (t.Q = 'Q2-21') then 1 else 0 end)) AS 'Q2-21',
    sum((case when (t.Q = 'Q3-21') then 1 else 0 end)) AS 'Q3-21',
    sum((case when (t.Q = 'Q4-21') then 1 else 0 end)) AS 'Q4-21'
from
    (
    select
        td.department AS department,
        tj.job AS job,
        (case
            when (month(the.datetime) in (1, 2, 3)) then concat('Q1-', right(year(the.datetime), 2))
            when (month(the.datetime) in (4, 5, 6)) then concat('Q2-', right(year(the.datetime), 2))
            when (month(the.datetime) in (7, 8, 9)) then concat('Q3-', right(year(the.datetime), 2))
            when (month(the.datetime) in (10, 11, 12)) then concat('Q4-', right(year(the.datetime), 2))
            else NULL
        end) AS Q
    from
        ((HR.tb_hired_employees the
    join HR.tb_departments td on
        ((the.department_id = td.department_id)))
    join HR.tb_jobs tj on
        ((the.job_id = tj.job_id)))
    where
        (year(the.datetime) = 2021)) t
group by
    t.department,
    t.job
order by
    t.department,
    t.job;
