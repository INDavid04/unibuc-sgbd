----------------------------------------
-- Tema obligatorie - 4               --
-- Irimia David, 241                  --
-- Problema 4 din Set 1 exercitii.pdf --
----------------------------------------

-- Cerinta: Pastrati intr-o colectie codurile celor mai prost platiti 5 angajati care nu castiga comision. Folosind aceasta colectie mariti cu 5% salariul acestor angajati. Afisati valoarea veche a salariului, respectiv valoarea noua a salariului

------------------
-- Implementare --
------------------

declare
    -- Creeaza tipul colectiei (nested table) v_ids care va stoca id-urile angajatilor respectivi
    type emp_id_table is table of employees.employee_id%type;
    -- Creeaza colectia v_ids de tipul definit mai sus
    v_ids emp_id_table := emp_id_table();
    -- Declara variabila v_old pentru a retine salariul vechi al unui angajat
    v_old employees.salary%type;
    -- Declara variabila v_new pentru a retine salariul nou al unui angajat
    v_new employees.salary%type;
begin
    -- Pastreaza in colectia v_ids codurile celor mai prost platiti cinci angajati care nu castiga comision
    select employee_id
    bulk collect into v_ids
    from employees
    where commission_pct is null
    order by salary asc
    fetch first 5 rows only;
    
    -- Parcurge colectia v_ids
    for i in 1 .. v_ids.count loop
        -- Selecteaza salariul angajatului curent
        select salary
        into v_old
        from employees
        where employee_id = v_ids(i);
        
        -- Calculeaza noul salariu al angajatului curent
        v_new := v_old + v_old * 5/100;
        
        -- Afiseaza modificarea salariului angajatului curent
        dbms_output.put_line('Angajatul #' || v_ids(i) || ' trece de la salariul de ' || v_old || ' lei la salariul de ' || v_new || ' lei.');
        
        -- Actualizeaza tabelul employees cu noul salariu pentru angajatul curent
        update employees
        set salary = v_new
        where employee_id = v_ids(i);
    end loop;
end;
/

-----------
-- Aside --
-----------

-- Revino la salariile initiale
rollback;

-- Dbms Output
--Angajatul #133 trece de la salariul de 3300 lei la salariul de 3465 lei.
--Angajatul #187 trece de la salariul de 3307.5 lei la salariul de 3472.88 lei.
--Angajatul #197 trece de la salariul de 3307.5 lei la salariul de 3472.88 lei.
--Angajatul #118 trece de la salariul de 3318.34 lei la salariul de 3484.26 lei.
--Angajatul #143 trece de la salariul de 3318.34 lei la salariul de 3484.26 lei.

-- Vezi angajatii in ordinea crescatoare a salariului
select employee_id, salary
from employees
order by salary asc;
