-- Curs 6

-- Compileaza / Nu compileaza?
select &coloana
from &tabel
where &conditie; 

----------------------------
-- Problema colectii SGBD --
----------------------------

-- Cerinta: Vom numi “tip3” un tip de date ce folosește în definirea lui un alt tip de date (“tip2”), care la rândul lui utilizează un alt tip de date (“tip1”). Definiți un astfel de tip, indicați ce anume reprezintă și utilizați-l prin adăugarea unei coloane de acest tip la unul dintre tabelele din schema de la laborator. Cu ajutorul unui bloc anonim actualizați coloana adăugată cu informații relevante din schema.
-- Ierarhie:
-- 1. Tip1 descrie o adresa
-- 2. Tip2 foloseste Tip1 pentru a defini o locatie complexa
-- 3. Tip3 foloseste Tip2 pentru a defini un contactul cu o locatie complexa, pe langa numarul de telefon

-- Tip1: Adresa
create or replace type tip1 as object (
    strada varchar(40),
    numar number(10),
    cod_postal varchar (10)
);

-- Tip2: Locatie
create or replace type tip2 as object (
    oras varchar(100),
    adresa tip1
);

-- Tip3: Contact
create or replace type tip3 as object (
    telefon varchar(20),
    locatie tip2
);

-- Adauga coloana contact in tabelul employees
alter table employees
add (contact tip3)

-- Bloc anonim pentru actualizare
declare
    v_contact tip3;
begin
    v_contact := tip3 (
        '+40712345678',
        tip2 (
            'Bucuresti',
            tip1 (
                'Strada Academiei',
                14,
                '111234'
            )
        )
    );
    update employees
    set contact = v_contact
    where employee_id = 100;
    commit;
end;
/

-- Testeaza codul
select e.employee_id, e.contact.telefon, e.contact.locatie.oras, e.contact.locatie.adresa.strada, e.contact.locatie.adresa.numar, e.contact.locatie.adresa.cod_postal
from employees e
where e.employee_id = 100;

-- Sterge coloana adaugata
alter table employees
drop column contact;

-- Sterge tipurile create (ordinea conteaza, tip 3 depinde de tip 2 care depinde de tip 1)
drop type tip3;
drop type tip2;
drop type tip1;

-- Testeaza ca s-a sters coloana adaugata
select * from employees;



