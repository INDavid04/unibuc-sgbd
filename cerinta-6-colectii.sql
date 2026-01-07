-- 6. Formulați în limbaj natural o problemă pe care să o rezolvați folosind un subprogram stocat independent care să utilizeze toate cele 3 tipuri de colecții studiate. Apelați subprogramul. 

--
-- Problema formulata in limbaj natural
--
-- Implementati un subprogram stocat independent care sa afiseze un raport al unui eveniment. Se vor extrage:
-- a) Catalogul spectatorilor, intr-o structura de tip dictionar care sa asocieze id-ul utilizatorului cu numele acestuia
-- b) Lista preturilor biletelor, intr-o lista dinamica, pentru a calcula ulterior media
-- c) Locatiile evenimentului, intr-o structura de tip vector cu dimensiune fixa de zece elemente
--

create or replace procedure raport_eveniment (p_id_eveniment eveniment.id_eveniment%type) is
    -- a) INDEX-BY TABLE
    type t_spectatori is table of utilizator.nume%type index by pls_integer;
    v_spectatori t_spectatori;
    -- b) NESTED TABLE
    type t_preturi is table of bilet.pret%type;
    v_preturi t_preturi := t_preturi();
    -- c) VARRAY
    type t_locatii is varray(10) of locatie.denumire%type;
    v_locatii t_locatii := t_locatii();

    v_nume_eveniment eveniment.denumire%type;
    v_index pls_integer;
    v_suma_preturi number := 0;
    v_cnt number := 0;
begin
    -- Preia numele evenimentului
    select denumire into v_nume_eveniment from eveniment where id_eveniment = p_id_eveniment;
    dbms_output.put_line('# Raport eveniment: ' || v_nume_eveniment);
    dbms_output.put_line('');

    --
    -- a) INDEX-BY TABLE (Recomand: raport_eveniment(2);)
    --

    for r_spectator in (
        select u.id_utilizator, u.nume
        from utilizator u
        join bilet b on u.id_utilizator = b.id_utilizator
        where b.id_eveniment = p_id_eveniment
    ) loop
        v_spectatori(r_spectator.id_utilizator) := r_spectator.nume;
    end loop;

    dbms_output.put_line('## Spectatori inscrisi');
    v_index := v_spectatori.first;
    while v_index is not null loop
        v_cnt := v_cnt + 1;
        dbms_output.put_line('');
        dbms_output.put_line(v_cnt || '. ID: ' || v_index || ' | ' || 'Nume: ' || v_spectatori(v_index));
        v_index := v_spectatori.NEXT(v_index);
    end loop;
     
    --
    -- b) NESTED TABLE
    --

    select pret bulk collect into v_preturi from bilet where id_eveniment = p_id_eveniment;

    dbms_output.put_line('');
    dbms_output.put_line('## Analiza preturi');
    
    if v_preturi.count > 0 then 
        for i in 1..v_preturi.count loop
            v_suma_preturi := v_suma_preturi + NVL(v_preturi(i), 0);
        end loop;

        dbms_output.put_line('');
        dbms_output.put_line('- Pretul mediu al unui bilet este ' || round(v_suma_preturi/v_preturi.count, 2));
    else
        dbms_output.put_line('Nu s-au gasit bilete');
    end if;

    --
    -- c) VARRAY
    --

    for r_loc in (
        select l.denumire
        from locatie l
        join eveniment_locatie el on l.id_locatie = el.id_locatie
        where el.id_eveniment = p_id_eveniment
    ) loop
        if v_locatii.count < 10 then
            v_locatii.extend;
            v_locatii(v_locatii.last) := r_loc.denumire;
        end if;
    end loop;

    dbms_output.put_line('');
    dbms_output.put_line('## Locatii desfasurare');
    v_cnt := 1;
    for i in 1..v_locatii.count loop
        dbms_output.put_line(v_cnt || '. ' || v_locatii(i));
        v_cnt := v_cnt + 1;
    end loop;
exception
    when no_data_found then
        dbms_output.put_line('Eroare: Eveniment inexistent.');
    when others then
        dbms_output.put_line('Eroare: ' || sqlerrm);
end;
/

set serveroutput on;

begin
    raport_eveniment(5);
end;
/
