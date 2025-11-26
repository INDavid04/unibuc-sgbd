-------------------------
-- Curs 9 - 26.11.2025 --
-------------------------

create or replace view etc as
select employee_id, last_name, salary
from employees;
    
select * from etc;

alter table employees
modify salary number(10, 2);

select * from employees;

update etc
set salary = 189
where employee_id = 171;

select * from employees where employee_id = 171;


