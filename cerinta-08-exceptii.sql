-- 8. Formulați în limbaj natural o problemă pe care să o rezolvați folosind un subprogram stocat independent de tip funcție care să utilizeze într-o singură comandă SQL 3 dintre tabelele create. Tratați toate excepțiile care pot apărea, incluzând excepțiile predefinite NO_DATA_FOUND și TOO_MANY_ROWS. Apelați subprogramul astfel încât să evidențiați toate cazurile tratate

--
-- Problema formulata in limbaj natural
--
-- Sa se implementeze o functie stocata care, primind id-ul unui spectator, returneaza un mesaj care contine: numele spectatorului, denumirea evenimentului si pretul biletului. Sa se trateze urmatoarele situatii: spectatorul nu a cumparat niciun bilet, spectatorul are mai multe bilete, spectatorul nu are adresa de mail completata

create or replace function raport_spectator (p_id_utilizator utilizator.id_utilizator%type) return varchar2 is
    v_nume utilizator.nume%type;
    v_eveniment eveniment.denumire%type;
    v_pret bilet.pret%type;
    v_mail utilizator.mail%type;

    lipseste_mail exception;
begin
    select u.nume, e.denumire, b.pret, u.mail
    into v_nume, v_eveniment, v_pret, v_mail
    from utilizator u, bilet b, eveniment e
    where b.id_utilizator = u.id_utilizator
    and e.id_eveniment = b.id_eveniment
    and u.id_utilizator = p_id_utilizator;

    if v_mail is null then
        raise lipseste_mail;
    end if;

    return 'Spectatorul ' || v_nume || ' are bilet la evenimentul ' || v_eveniment || ' in valoare de ' || nvl(to_char(v_pret), 0) || ' RON.';
exception
    -- Testeaza: raport_spectator(7);
    when no_data_found then
        return 'Eroare: Spectatorul nu are niciun bilet.';
    -- Testeaza: raport_spectator(1);
    when too_many_rows then
        return 'Eroare: Spectatorul are mai multe bilete.';
    when lipseste_mail then
    -- Testeaza: raport_spectator(4);
        return 'Eroare: Spectatorul are profilul incomplet (lipseste mail).';
    when others then
        return 'Eroare: ' || sqlerrm;
    -- Reusit: raport_spectator(2);
end;
/

set serveroutput on;
begin
    dbms_output.put_line(raport_spectator(2));
end;
/
