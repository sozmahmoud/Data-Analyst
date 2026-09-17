SELECT (salary +10) +10
FROM parks_and_recreation.employee_salary;
#PEMDAS

select * from parks_and_recreation.employee_salary;

select Distinct salary from parks_and_recreation.employee_salary;

show tables;

select * from employee_demographics;
select * from employee_salary;
select * from parks_departments;

select distinct salary from employee_salary;

select (salary*2) from employee_salary;

select department_id,department_name from parks_departments where department_name='Library';

select * from employee_demographics where birth_date='1986-07-27';

select * from employee_demographics where first_name like 'jer%';
select * from employee_demographics where first_name like 'a__';

select * from employee_demographics where first_name like 'a__%';
select * from employee_demographics where birth_date like '1994%';


select * from employee_demographics;

SELECT age
FROM employee_demographics
GROUP BY age;

select AVG(age) from employee_demographics;
select Min(age) from employee_demographics;
select Max(age) from employee_demographics;

select * from employee_demographics order by age;
select * from employee_demographics order by age DESC;

SELECT age
FROM employee_demographics
GROUP BY age having AVG(age) > 40;


select * from employee_demographics;
select * from employee_salary;
select * from parks_departments;

select salary from employee_salary where occupation Like '%Nurse%'
Group by salary
having AVG(salary)>=25000;

select * from parks_departments limit 4;

select department_name D from parks_departments group by department_name;

select * from employee_demographics;
select * from employee_salary;
select * from parks_departments;

select EG.employee_id,EG.first_name,EG.last_name from employee_demographics as EG 
join employee_salary as ES on EG.employee_id=ES.employee_id;

select EG.employee_id,EG.first_name,EG.last_name from employee_demographics as EG 
join employee_salary as ES on EG.employee_id+1=ES.employee_id;

ALTER TABLE employee_demographics
ADD department_id INT;

ALTER TABLE employee_salary
ADD department_id INT;

select EG.employee_id,EG.first_name,EG.last_name from employee_demographics as EG 
join employee_salary as ES 
on EG.employee_id=ES.employee_id
inner join parks_departments as PD 
on ES.department_id=PD.department_id;

select * from employee_demographics;
select * from employee_salary;
select * from parks_departments;

select first_name,salary from employee_salary
union all
select department_id,department_name from parks_departments;

select first_name,salary from employee_salary
union 
select department_id,department_name from parks_departments;

select first_name,last_name, 'old' as label 
from employee_demographics where age>50;

SELECT LENGTH(first_name) FROM employee_demographics;
SELECT UPPER(first_name) FROM employee_demographics;
SELECT LOWER(first_name) FROM employee_demographics;
SELECT TRIM(first_name) FROM employee_demographics;
SELECT LTRIM(first_name) FROM employee_demographics;
SELECT RTRIM(first_name) FROM employee_demographics;
SELECT LEFT(first_name, 3) FROM employee_demographics;
SELECT RIGHT(first_name, 3) FROM employee_demographics;
SELECT SUBSTRING(first_name, 1, 3) FROM employee_demographics;
SELECT REPLACE(first_name, 'a', 'A') FROM employee_demographics;
SELECT LOCATE('a', first_name) FROM employee_demographics;
SELECT CONCAT(first_name, ' ', last_name) FROM employee_demographics;


select * from employee_demographics;
select * from employee_salary;
select * from parks_departments;


select employee_id,first_name,age,
case
when age<=35 then 'young'
when age>35 then 'old'
end as new_coloumn 
from employee_demographics;

SELECT first_name, salary,
       CASE
           WHEN salary < 50000 THEN salary * 1.20
       END AS update_salary
FROM employee_salary;

select * from employee_demographics;
select * from employee_salary;
select * from parks_departments;


select * from employee_demographics where employee_id IN 
(select employee_id from employee_salary where employee_id=3);

select  employee_id,first_name, (select AVG(salary) from employee_salary)  AS avg_sal
from employee_demographics;

SELECT 
    employee_id,
    first_name,
    (SELECT AVG(salary)
     FROM employee_salary ES
     WHERE ES.department_id = ED.employee_id
     GROUP BY department_id) AS avg_sal
FROM employee_demographics ED;


select * from employee_demographics;
select * from employee_salary;
select * from parks_departments;

SELECT 
    ed.first_name,
    ed.last_name,
    ROW_NUMBER() OVER (
        PARTITION BY es.department_id 
        ORDER BY ed.age DESC
    ) AS row_num
    ,
    RANK() OVER (
    PARTITION BY es.salary
    ORDER BY ed.age DESC
) AS rank_num
FROM employee_demographics AS ed
JOIN employee_salary AS es
    ON ed.employee_id = es.employee_id;
    
    SELECT
    ed.first_name,
    ed.last_name,
    es.salary,
    RANK() OVER (
        ORDER BY es.salary DESC
    ) AS rank_num
FROM employee_demographics AS ed
JOIN employee_salary AS es
    ON ed.employee_id = es.employee_id;

WITH cte_ex AS (
    SELECT 
        ED.employee_id,
        ED.first_name,
        (
            SELECT AVG(ES.salary)
            FROM employee_salary AS ES
            WHERE ES.department_id = ED.employee_id
            GROUP BY ES.department_id
        ) AS avg_sal
    FROM employee_demographics AS ED
)
SELECT *
FROM cte_ex;

with cte_ex2 AS(
  SELECT
    ed.first_name,
    ed.last_name,
    es.salary,
    RANK() OVER (
        ORDER BY es.salary DESC
    ) AS rank_num
FROM employee_demographics AS ed
JOIN employee_salary AS es
    ON ed.employee_id = es.employee_id
)
    SELECT *
FROM cte_ex2;


WITH cte_ex AS (
    SELECT 
        ED.employee_id,
        ED.first_name,
        ED.department_id
    FROM employee_demographics AS ED
),
cte_ex2 AS (
    SELECT
        ES.employee_id,
        ES.salary,
        RANK() OVER (
            ORDER BY ES.salary DESC
        ) AS rank_num
    FROM employee_salary AS ES
)
SELECT *
FROM cte_ex AS cx
JOIN cte_ex2 AS cx2
    ON cx.employee_id = cx2.employee_id;



CREATE TEMPORARY TABLE t1 (
    employee_id VARCHAR(20),
    first_name VARCHAR(20),
    age INT
);

INSERT INTO t1
VALUES
(1, 'John', 30),
(2, 'Sarah', 25),
(3, 'Mike', 40);

SELECT * FROM t1;

select * from employee_demographics;
select * from employee_salary;
select * from parks_departments;

delimiter $$
create procedure l()
begin
select * from employee_demographics
where age > 45;

select * from employee_demographics
where age > 38;
end $$

DELIMITER ;

DROP PROCEDURE l;

call l();

select * from employee_salary;

CREATE TABLE salary_log (
    employee_id INT,
    salary DECIMAL(10,2),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER employee_salary1
AFTER INSERT ON employee_salary
FOR EACH ROW
BEGIN
    INSERT INTO salary_log (employee_id, salary)
    VALUES (NEW.employee_id, NEW.salary);
END $$

DELIMITER ;

INSERT INTO employee_salary
(employee_id, first_name, last_name, occupation, salary, dept_id, department_id)
VALUES
(20, 'John', 'Smith', 'Developer', 50000, 1, 1);

SELECT * FROM salary_log;


DELIMITER $$

CREATE TRIGGER employee_salary2
BEFORE INSERT ON employee_salary
FOR EACH ROW
BEGIN
    IF NEW.salary < 5000 THEN
        SET NEW.salary = NEW.salary * 1.20;
    END IF;
END $$

DELIMITER ;

INSERT INTO employee_salary
(employee_id, first_name, last_name, occupation, salary, dept_id, department_id)
VALUES
(20, 'John', 'Smith', 'Developer', 4000, 1, 1);

select * from employee_salary;

Delimiter $$
create event delete_retire_employee
on schedule every 1 month
do 
begin
delete from employee_demographics
where age > 60 ;layoffs
end $$
DELIMITER ;

SET GLOBAL event_scheduler = ON;

SHOW VARIABLES LIKE 'event_scheduler';
SHOW VARIABLES LIKE 'event%';

select * from employee_demographics;

