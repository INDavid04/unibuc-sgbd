----------------------------------------------------------------------------------
-- Tema obligatorie 10                                                          --
-- Irimia David, Grupa 241, 10 Decembrie 2025, 15:00 - 02:25                    --
-- Din laboratorul 5, exercitiul 1, punctele e, f, g, h                         --
-- Sa se trateze si exceptiile care pot aparea in cele 2 proceduri              --
-- (functiile si procedurile  sunt tot blocuri, asa ca permit si ele utilizarea -- 
-- sectiunii EXCEPTION, asa cum s-a observat la laborator in blocurile anonime) --
----------------------------------------------------------------------------------

-- Specificatia
create or replace package pachet_gestiune_241 as
    -- 1.e (vezi in corp)
    procedure actualizeaza_salariu(v_nume varchar2, v_valoare number);
    
    -- 1.h (vezi in corp)
    procedure raport_complet;
    
    -------------------------------------------------------------------------------------------------------
    -- 1.f Cursor care obtine lista angajatiolor care lucreaza pe un job al carui cod e dat ca parametru --
    -------------------------------------------------------------------------------------------------------
    
    cursor c_angajati_job(v_job_id varchar2) return employees%rowtype is
        select * from employees where job_id = v_job_id;
        
    -----------------------------------------------------------------
    -- 1.g Cursor care obtine lista tuturor joburilor din companie --
    -----------------------------------------------------------------

    cursor c_joburi return jobs%rowtype is
        select * from jobs;
    
end pachet_gestiune_241;
/

-- Corpul
create or replace package body pachet_gestiune_241 as

    ------------------------------------------------------------------------------------------------------
    -- 1.e Procedură prin care se actualizează cu o valoare dată ca parametru salariul unui angajat al  --
    -- cărui nume este dat ca parametru:                                                                --
    --     - Se va verifica dacă valoarea dată pentru salariu respectă limitele impuse pentru acel job; --
    --     - Dacă sunt mai mulţi angajaţi care au acelaşi nume, atunci se va afişa un mesaj             --
    --       corespunzător şi de asemenea se va afişa lista acestora;                                   --
    --     - Dacă nu există angajaţi cu numele dat, atunci se va afişa un mesaj corespunzător;          --
    ------------------------------------------------------------------------------------------------------
        
    -- Observatie: Presupunem ca numele este reprezentat de last_name (bonus: prenume - first_name)
        
    procedure actualizeaza_salariu(v_nume varchar2, v_valoare number) is
        v_count number;
        v_job_id employees.job_id%type;
        v_employee_id employees.employee_id%type;
        v_min_salary jobs.min_salary%type;
        v_max_salary jobs.max_salary%type;
        
        cursor c_nume is
            select employee_id, first_name, last_name, job_id, salary
            from employees
            where upper(last_name) = upper(v_nume);
            
        exceptie_limite exception;
        exceptie_nume_multiplu exception;
        exceptie_nume_inexistent exception;
        
        begin
            -- Verifica cati angajati au numele respectiv
            select count(*) into v_count
            from employees
            where upper(last_name) = upper(v_nume);
            
            -- Cazul in care nu exista
            if v_count = 0 then
                raise exceptie_nume_inexistent;
            end if;
            
            -- Cazul in care sunt mai multi cu acelasi nume (adica last_name)
            if v_count > 1 then 
                dbms_output.put_line('Exista ' || v_count || ' angajati cu numele ' || v_nume);
                raise exceptie_nume_multiplu;
            end if;
            
            -- Obtine datele singurului angajat gasit
            select employee_id, job_id into v_employee_id, v_job_id
            from employees
            where upper(last_name) = upper(v_nume);
            
            -- Obtine salariul maxim si minim pentru job
            select min_salary, max_salary into v_min_salary, v_max_salary
            from jobs
            where job_id = v_job_id;
            
            -- Verifica daca v_valoare respecta limitele
            if v_valoare < v_min_salary or v_valoare > v_max_salary then
                dbms_output.put_line('Valoarea depaseste limitele: ' || v_min_salary || ' si ' || v_max_salary);
                raise exceptie_limite;
            end if;
            
            -- Actualizeaza salariul
            update employees
            set salary = v_valoare
            where employee_id = v_employee_id;
            dbms_output.put_line('Salariul angajatului cu numele de ' || v_nume || ' s-a schimbat in ' || v_valoare);
            
            commit;
            
        exception
            when exceptie_nume_inexistent then
                dbms_output.put_line('Numele ' || v_nume || ' nu exista');
            when exceptie_nume_multiplu then
                dbms_output.put_line('Numele ' || v_nume || ' apare de mai multe ori');
            when exceptie_limite then
                dbms_output.put_line('Salariul ' || v_valoare || ' nu respecta limitele');
            when no_data_found then
                dbms_output.put_line('Nu exista date');
            when others then
                dbms_output.put_line('Eroare: ' || sqlerrm);
                rollback;
    end actualizeaza_salariu;
        
    -----------------------------------------------------------------------------------------------------
    -- 1.h Procedură care utilizează cele două cursoare definite anterior şi obţine pentru fiecare job --
    -- numele acestuia şi lista angajaţilor care lucrează în prezent pe acel job; în plus, pentru      --
    -- fiecare angajat să se specifice dacă în trecut a mai avut sau nu jobul respectiv.               --
    -----------------------------------------------------------------------------------------------------
    
    procedure raport_complet is
        v_count_angajati number;
        v_a_avut_job number;
        v_mesaj varchar2(200);
        
        begin
            dbms_output.put_line('Raport complet');
            
            -- Parcurge toate job-urile (cursor de la punctul g)
            for v_job in c_joburi loop
                -- Numara angajatii
                select count(*) into v_count_angajati
                from employees
                where job_id = v_job.job_id;
                
                -- Afiseaza job-ul
                dbms_output.put_line(
                    'Job id: ' || v_job.job_id || 
                    ' | Job title: ' || v_job.job_title || 
                    ' | Salariu intre ' || v_job.min_salary || ' si ' || v_job.max_salary ||
                    ' | Numar angajati cu acest job: ' || v_count_angajati
                );
                
                -- Afiseaza angajatii
                if v_count_angajati > 0 then
                    dbms_output.put_line('Lista angajatilor: ');
                    for v_angajat in c_angajati_job(v_job.job_id) loop
                        -- Verifica daca angajatul a mai avut acest job
                        select count(*) into v_a_avut_job
                        from job_history
                        where employee_id = v_angajat.employee_id and job_id = v_job.job_id;
                        
                        if v_a_avut_job > 0 then
                            v_mesaj := 'A mai avut acest job';
                        else
                            v_mesaj := 'Nu a mai avut acest job';
                        end if;
                    
                        dbms_output.put_line(
                            'Id angajat: ' || v_angajat.employee_id || 
                            ' | Nume si prenume: ' || v_angajat.first_name || ' ' || v_angajat.last_name ||
                            ' | ' || v_mesaj
                        );
                    end loop;
                else -- adica v_count_angajati <= 0
                    dbms_output.put_line('Nu exista angajati cu acest job');
                end if;
                dbms_output.put_line(''); -- separam joburile
            end loop;
        exception
            when no_data_found then
                dbms_output.put_line('Nu s-au gasit datele');
            when others then
                dbms_output.put_line('Eroare: ' || sqlerrm);
    end raport_complet;
    
end pachet_gestiune_241;
/
    
------------------
-- Testeaza 1.e --
------------------

-- Nume inexistent (Numele Irimia nu exista)
begin
    pachet_gestiune_241.actualizeaza_salariu('Irimia', 12345);
end;

-- Nume multiplu (Exista 2 angajati cu numele King, Numele King apare de mai multe ori)
begin
    pachet_gestiune_241.actualizeaza_salariu('King', 1234);
end;

-- Salariu in afara limitelor (Valoarea depaseste limitele: 2500 si 5500, Salariul 7000 nu respecta limitele)
begin
    pachet_gestiune_241.actualizeaza_salariu('Tobias', 7000);
end;

-- Actualizeaza salariul
begin
    -- Tobias are job id PU_CLERK si range-ul salarial intre 2500 si 5500
    -- Inial are salariul 4000
    pachet_gestiune_241.actualizeaza_salariu('Tobias', 4400);
end;
/
select * 
from employees 
where last_name = 'Tobias';

------------------
-- Testeaza 1.f --
------------------

begin
    for v_angajat in pachet_gestiune_241.c_angajati_job('IT_PROG') LOOP
        dbms_output.put_line('Angajat: ' || v_angajat.first_name || ' ' || v_angajat.last_name);
    end loop;
end;
/

------------------
-- Testeaza 1.g --
------------------

begin
    for v_job in pachet_gestiune_241.c_joburi loop
        dbms_output.put_line('Job: ' || v_job.job_id || ' - ' || v_job.job_title);
    end loop;
end;
/

------------------
-- Testeaza 1.h --
------------------

begin
    pachet_gestiune_241.raport_complet();
end;
/
