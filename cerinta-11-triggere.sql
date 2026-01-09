-- 11. Definiți un trigger de tip LMD la nivel de linie. Declanșați trigger-ul.

--
-- Problema formulata in limbaj natural
--
-- Creati un trigger la nivel de rand asupra tabelului bilet care sa impiedice orice modificare a pretului sau a locatiei biletului daca acesta deja a fost folosit.

create or replace trigger protectie_bilete_folosite
before update on bilet
for each row
begin
    -- Verifica daca biletul a fost folosit
    if lower(:old.stare) = 'folosit' then
        -- Putem pune orice numar intre -20999 si -20000
        raise_application_error(-20123, 'Eroare: Biletele deja folosite nu mai pot fi modificate');
    end if;
end;
/

set serveroutput on;

-- Testeaza pentru un bilet cumparat
update bilet
set pret = 300
where id_bilet = 1;

-- Testeaza pentru un bilet folosit
begin
    update bilet
    set pret = 1000
    where id_bilet = 2;
exception
    when others then
        dbms_output.put_line('Eroare: ' || sqlerrm);
end;
/

-- Deoarece doar testam, nu salvam modificarile
rollback;
