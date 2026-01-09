-- 10. Definiți un trigger de tip LMD la nivel de comandă. Declanșați trigger-ul.

-- 
-- Problema formulata in limbaj natural
--
-- Creati un trigger care monitorizeaza modificarile tabelului bilet. Orice operatiune de tip insert, update, delete va trebui afisata. Triggerul se va executa o data pentru fiecare comanda sql.

create or replace trigger monitorizeaza_bilete
before insert or update or delete on bilet
begin
    if inserting then
        dbms_output.put_line('Se incearca: Adaugarea unui bilet');
    elsif updating then
        dbms_output.put_line('Se incearca: Actualizarea unui bilet');
    elsif deleting then
        dbms_output.put_line('Se incearca: Stergerea unui bilet');
    end if;

    dbms_output.put_line('(Data si ora: ' || to_char(current_date, 'YYYY-MM-DD HH24:MI') || ')');
end;
/

set serveroutput on;

-- Declanseaza triggerul prin insert
insert into bilet (id_utilizator, id_eveniment, pret, stare, loc)
values (5, 4, 123.99, 'folosit', 534);

-- Declanseaza triggerul prin update
update bilet
set stare = 'folosit'
where id_bilet = 2;

-- Declanseaza triggerul prin delete
delete from bilet where loc = 12;

-- Sterge linia urmatoare daca vrei sa ramana operatiunile
rollback;

-- Sterge linia daca vrei sa ramana trigger-ul
drop trigger monitorizeaza_bilete;
