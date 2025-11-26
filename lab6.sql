-- Laborator 6 (5 Noiembrie 2025)

--------------------------------------------
-- Exercitiul 1 din Laborator PLSQL 3.pdf --
--------------------------------------------

-- Cerinta: E1. Pentru fiecare job (titlu – care va fi afișat o singură dată) obțineți lista angajaților (nume și salariu) care lucrează în prezent pe jobul respectiv. Tratați cazul în care nu există angajați care să lucreze în prezent pe un anumit job. Rezolvați problema folosind:

----------------------------
-- E1.a. Cursoare clasice --
----------------------------

declare
    cursor jobs_cursor is
        select distinct job_id from employees;
    cursor emps_cursor (j varchar) is
        select first_name, salary from employees where job_id = j;
begin
    for i_job in jobs_cursor loop
        dbms_output.putline(i_job.job_id);
        for i_emps in emps_cursor (i_job.job_id) loop
            dbms_output.put_line(i_emps.first_name || ' ' || i_emps.salary);
        end loop;
        dbms_output.put_line(' ');
    end loop;
end;
/

-----------------------
-- b. Ciclu cursoare --
-----------------------

------------------------------------
-- c. Ciclu cursoare cu subcereri --
------------------------------------

------------------------
-- d. Cxpresii cursor --
------------------------
