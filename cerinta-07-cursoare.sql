-- 7. Formulați în limbaj natural o problemă pe care să o rezolvați folosind un subprogram stocat independent care să utilizeze 2 tipuri diferite de cursoare studiate, unul dintre acestea fiind cursor parametrizat, dependent de celălalt cursor. Apelați subprogramul.

--
-- Problema formulata in limbaj natural
--
-- Implementati o procedura stocata care sa genereze un raport detaliat al organizatorilor. Subprogramul va folosi un cursor neparametrizat de tip REF CURSOR pentru a itera prin lista tuturor utilizatorilor care sunt inregistrati ca organizatori. Pentru fiecare organizator gasit, se va utiliza un cursor clasic parametrizat care sa extraga toate evenimentele create de acesta, afisand denumirea evenimentului si pretul biletului.
-- 

create or replace procedure raport_activitate_organizatori is
    -- Variabile pentru primul cursor
    v_id_org utilizator.id_utilizator%type;
    v_nume_org utilizator.nume%type;

    -- Cursor explicit dinamic, neparametrizat, ref cursor
    type t_cursor_org is ref cursor;
    v_cursor_org t_cursor_org;

    -- Cursor explicit parametrizat, dependent de cursorul v_cursor_org
    cursor c_evenimente (p_id_utilizator eveniment.id_utilizator%type) is
        select denumire, pret
        from eveniment
        where id_utilizator = p_id_utilizator;

    v_registru_eveniment c_evenimente%rowtype;
    v_am_gasit_evenimente boolean; 
begin
    dbms_output.put_line('#######################');
    dbms_output.put_line('# Raport organizatori #');
    dbms_output.put_line('#######################');

    -- Deschide ref cursorul pentru a gasi toti organizatorii
    open v_cursor_org for
        select u.id_utilizator, u.nume
        from utilizator u
        join organizator o on o.id_utilizator = u.id_utilizator
    ;

    loop
        fetch v_cursor_org into v_id_org, v_nume_org;
        exit when  v_cursor_org%notfound;

        dbms_output.put_line('');
        dbms_output.put_line('Organizator: ' || v_nume_org || ' (id: ' || v_id_org || ')');
        v_am_gasit_evenimente := false;

        -- Deschide cursorul parametrizat folosind id-ul de la primul cursor
        open c_evenimente(v_id_org);
        loop
            fetch c_evenimente into v_registru_eveniment;
            exit when c_evenimente%notfound;

            v_am_gasit_evenimente := true;
            dbms_output.put_line('- Eveniment: ' || v_registru_eveniment.denumire || ' (' || nvl(to_char(v_registru_eveniment.pret), '0') || 'RON)');
        end loop;

        if not v_am_gasit_evenimente then
            dbms_output.put_line(' - Inca nu a organizat evenimente');
        end if;

        close c_evenimente;
    end loop;

    close v_cursor_org;
exception
    when others then    
        if c_evenimente%isopen then 
            close c_evenimente;
        end if;

        if v_cursor_org%isopen then
            close v_cursor_org;
        end if;

        dbms_output.put_line('Eroare: ' || sqlerrm);
end;
/

set serveroutput on;
begin
    raport_activitate_organizatori;
end;
/
