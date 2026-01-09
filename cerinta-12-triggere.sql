-- 12. Definiți un trigger de tip LDD. Declanșați trigger-ul.

-- 
-- Problema formulata in limbaj natural
--
-- Creati un trigger de tip ldd care impiedica stergerea oricarui tabel.

create or replace trigger protectie_tabele_impotriva_stergerii
before drop on schema
begin
    -- Verifica daca este un tabel
    if dictionary_obj_type = 'TABLE' then
        raise_application_error(-20112, 'Eroare: Nu aveti permisiunea de a sterge niciun tabel');
    end if;
end;
/

set serveroutput on;

-- Declanseaza triggerul prin drop
begin
    dbms_output.put_line('Se incearca: Stergerea unui tabel');
    execute immediate 'drop table istoric';
exception
    when others then
        dbms_output.put_line('Error: ' || sqlerrm);
end;
/

-- Sterge linia urmatoare daca vrei sa pastrezi triggerul
drop trigger protectie_tabele_impotriva_stergerii;
