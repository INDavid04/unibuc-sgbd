-- 9. Formulați în limbaj natural o problemă pe care să o rezolvați folosind un subprogram stocat independent de tip procedură care să aibă minim 2 parametri și să utilizeze într-o singură comandă SQL 5 dintre tabelele create. Definiți minim 2 excepții proprii, altele decât cele predefinite la nivel de sistem. Apelați subprogramul astfel încât să evidențiați toate cazurile definite și tratate.

--
-- Problema formulata in limbaj natural
--
-- Sa se implementeze o procedura stocata care primeste ca parametri numele unui spectator si numele unei locatii. Procedura trebuie sa verifice daca spectatorul respectiv detine un bilet pentru un eveniment care se desfasoara in acea locatie specifica. Intr-o singura comanda sql se vor uni cinci tabele, anume: utilizator, bilet, eveniment, eveniment_locatie si locatie. Se va tine cont sa fie un profil complet, adica sa aiba si mail, precum si un bilet in respectiva locatie.

create or replace procedure are_profil_si_bilet (
    p_nume in utilizator.nume%type,
    p_locatie in locatie.denumire%type
) is
    -- Cele doua exceptii
    nu_e_profil_complet exception;
    nu_are_bilet_in_locatie exception;

    -- Variabile
    v_mail utilizator.mail%type;
    v_eveniment eveniment.denumire%type;
    v_nr_bilete number := 0;
    v_nr_locatii_gasite number := 0;
begin
    -- Ca sa nu pierdem userul daca nu are bilet, folosim left join
    select u.mail, count(distinct b.id_bilet), count(l.id_locatie), max(e.denumire)
    into v_mail, v_nr_bilete, v_nr_locatii_gasite, v_eveniment
    from utilizator u
    left join bilet b on u.id_utilizator = b.id_utilizator
    left join eveniment e on b.id_eveniment = e.id_eveniment
    left join eveniment_locatie el on e.id_eveniment = el.id_eveniment
    left join locatie l on el.id_locatie = l.id_locatie and l.denumire = p_locatie
    where u.nume = p_nume
    group by u.mail;

    -- Verifica exceptiile
    if v_mail is null then
        raise nu_e_profil_complet;
    end if;

    if v_nr_locatii_gasite = 0 then
        raise nu_are_bilet_in_locatie;
    end if;

    dbms_output.put_line('########################################################');
    dbms_output.put_line('# Raport: Spectator cu mail si cu bilet intr-o locatie #');
    dbms_output.put_line('########################################################');

    -- Testeaza: are_profil_si_bilet('George Petru', 'Piata Munchen');
    dbms_output.put_line('');
    dbms_output.put_line('Spectatorul cu:');
    dbms_output.put_line('- Numele: ' || p_nume);
    dbms_output.put_line('- Mailul: ' || v_mail);
    dbms_output.put_line('- Are ' || v_nr_bilete || ' bilet(e)');
    dbms_output.put_line('- Printe care si un bilet la evenimentul ' || v_eveniment || ' in locatia ' || p_locatie);
exception
    -- Testeaza: are_profil_si_bilet('Gogu Simion', 'Valenii de Munte');
    when no_data_found then
        dbms_output.put_line('Eroare: Spectatorul nu exista');
    -- Testeaza: are_profil_si_bilet('Gheorghe Rut', 'Piata Unirii');
    when nu_e_profil_complet then
        dbms_output.put_line('Eroare: Spectatorul nu are profilul complet (lipseste mail-ul)');
    -- Testeaza: are_profil_si_bilet('Saiz Liviu', 'Larsmo');
    when nu_are_bilet_in_locatie then
        dbms_output.put_line('Eroare: Spectatorul nu are bilet in locatia precizata');
    when others then
        dbms_output.put_line('Eroare: ' || sqlerrm);
end;
/

set serveroutput on;
begin
    are_profil_si_bilet('Saiz Liviu', 'Pont Vieux Albi');
end;
/
