-- 4. Implementați în Oracle diagrama conceptuală realizată: definiți toate tabelele, adăugând toate constrângerile de integritate necesare (chei primare, cheile externe etc)

--
-- Sterge vechile tabele
--

begin execute immediate 'drop table tara cascade constraints';
exception when others then null;
end;
/

begin execute immediate 'drop table judet cascade constraints';
exception when others then null;
end;
/

begin execute immediate 'drop table locatie cascade constraints';
exception when others then null;
end;
/

begin execute immediate 'drop table spectator cascade constraints';
exception when others then null;
end;
/

begin execute immediate 'drop table spectator_locatie cascade constraints';
exception when others then null;
end;
/

begin execute immediate 'drop table istoric cascade constraints';
exception when others then null;
end;
/

begin execute immediate 'drop table organizator cascade constraints';
exception when others then null;
end;
/

begin execute immediate 'drop table utilizator cascade constraints';
exception when others then null;
end;
/

begin execute immediate 'drop table eveniment cascade constraints';
exception when others then null;
end;
/

begin execute immediate 'drop table bilet cascade constraints';
exception when others then null;
end;
/

begin execute immediate 'drop table eveniment_locatie cascade constraints';
exception when others then null;
end;
/

begin execute immediate 'drop table eveniment_istoric cascade constraints';
exception when others then null;
end;
/

--
-- Sterge vechile secvente (doar cele create de mine, nu si cele de sistem)
--

begin
    for r in (select sequence_name from user_sequences where sequence_name not like 'ISEQ$$%') loop
        execute immediate 'drop sequence ' || r.sequence_name;
    end loop;
end;
/

--
-- Creeaza noile secvente
--

create sequence seq_tara start with 1 increment by 1;
create sequence seq_judet start with 1 increment by 1;
create sequence seq_locatie start with 1 increment by 1;
create sequence seq_utilizator start with 1 increment by 1;
create sequence seq_istoric start with 1 increment by 1;
create sequence seq_eveniment start with 1 increment by 1;
create sequence seq_bilet start with 1 increment by 1;

--
-- Creeaza noile tabele
--

create table tara (
    id_tara number primary key,
    denumire varchar2(80)
);

create table judet (
    id_judet number primary key,
    id_tara number not null,
    denumire varchar2(80),

    constraint fk_tara_to_judet 
    foreign key (id_tara) 
    references tara(id_tara) 
    on delete cascade
);

create table locatie (
    id_locatie number primary key,
    id_judet number not null,
    denumire varchar2(80),

    constraint fk_judet_to_locatie foreign key (id_judet) 
    references judet(id_judet) on delete cascade
);

create table utilizator (
    id_utilizator number primary key,
    nume varchar2(80) not null,
    mail varchar2(80),
    parola varchar2(80)
);

create table organizator (
    id_utilizator number not null primary key,
    contact varchar2(80),

    constraint fk_utilizator_to_organizator
    foreign key (id_utilizator)
    references utilizator(id_utilizator)
    on delete cascade
);

create table spectator (
    id_utilizator number not null primary key,
    telefon varchar2(80),

    constraint fk_utilizator_to_spectator
    foreign key (id_utilizator)
    references utilizator(id_utilizator)
    on delete cascade
);

create table spectator_locatie (
    id_utilizator number not null,
    id_locatie number not null,

    primary key (id_utilizator, id_locatie),

    constraint fk_spectator_locatie_to_spectator 
    foreign key (id_utilizator) 
    references spectator(id_utilizator) 
    on delete cascade,

    constraint fk_spectator_locatie_to_locatie 
    foreign key (id_locatie) 
    references locatie(id_locatie) 
    on delete cascade
);

create table istoric (
    id_istoric number primary key,
    incepe date,
    termina date
);

create table eveniment (
    id_eveniment number primary key,
    id_utilizator number not null,
    denumire varchar2(80) not null,
    pret number(8, 2),

    constraint fk_organizator_to_eveniment 
    foreign key (id_utilizator) 
    references organizator(id_utilizator) 
    on delete cascade
);

create table bilet (
    id_bilet number primary key,
    id_utilizator number not null,
    id_eveniment number not null,
    pret number(8, 2),
    stare varchar2(80),
    loc number,

    constraint fk_eveniment_to_bilet 
    foreign key (id_eveniment) 
    references eveniment(id_eveniment) 
    on delete cascade,

    constraint fk_spectator_to_bilet 
    foreign key (id_utilizator) 
    references spectator(id_utilizator) 
    on delete cascade
);

create table eveniment_locatie (
    id_eveniment number not null,
    id_locatie number not null,

    primary key (id_eveniment, id_locatie),

    constraint locatie_to_eveniment_locatie 
    foreign key (id_locatie) 
    references locatie(id_locatie) 
    on delete cascade,

    constraint eveniment_to_eveniment_locatie 
    foreign key (id_eveniment) 
    references eveniment(id_eveniment) 
    on delete cascade
);

create table eveniment_istoric (
    id_eveniment number not null,
    id_istoric number not null,

    primary key (id_eveniment, id_istoric),

    constraint eveniment_to_eveniment_istoric 
    foreign key (id_eveniment) 
    references eveniment(id_eveniment) 
    on delete cascade,

    constraint istoric_to_eveniment_istoric 
    foreign key (id_istoric) 
    references istoric(id_istoric) 
    on delete cascade
);

-- Trigger pentru tara
create or replace trigger trg_tara_pk
before insert on tara
for each row
begin
    if :new.id_tara is null then
        :new.id_tara := seq_tara.nextval;
    end if;
end;
/

-- Trigger pentru judet
create or replace trigger trg_judet_pk
before insert on judet
for each row
begin
    if :new.id_judet is null then
        :new.id_judet := seq_judet.nextval;
    end if;
end;
/

-- Trigger pentru locatie
create or replace trigger trg_locatie_pk
before insert on locatie
for each row
begin
    if :new.id_locatie is null then
        :new.id_locatie := seq_locatie.nextval;
    end if;
end;
/

-- Trigger pentru utilizator
create or replace trigger trg_utilizator_pk
before insert on utilizator
for each row
begin
    if :new.id_utilizator is null then
        :new.id_utilizator := seq_utilizator.nextval;
    end if;
end;
/

-- Trigger pentru istoric
create or replace trigger trg_istoric_pk
before insert on istoric
for each row
begin
    if :new.id_istoric is null then
        :new.id_istoric := seq_istoric.nextval;
    end if;
end;
/

-- Trigger pentru eveniment
create or replace trigger trg_eveniment_pk
before insert on eveniment
for each row
begin
    if :new.id_eveniment is null then
        :new.id_eveniment := seq_eveniment.nextval;
    end if;
end;
/

-- Trigger pentru bilet
create or replace trigger trg_bilet_pk
before insert on bilet
for each row
begin
    if :new.id_bilet is null then
        :new.id_bilet := seq_bilet.nextval;
    end if;
end;
/

-- 5. Adăugați informații coerente în tabelele create (minim 5 înregistrări pentru fiecare entitate independentă; minim 10 înregistrări pentru fiecare tabelă asociativă)

--
-- Insereaza in tabele
--

-- TARA (entitate independenta)
insert into tara (denumire) values ('Romania');
insert into tara (denumire) values ('Ucraina');
insert into tara (denumire) values ('Ungaria');
insert into tara (denumire) values ('Serbia');
insert into tara (denumire) values ('Finlanda');
insert into tara (denumire) values ('Germania');
insert into tara (denumire) values ('Franta');

-- UTILIZATOR (entitate independenta)
insert into utilizator (nume, mail, parola) 
values ('George Petru', 'george-petru@gmail.com', 'georgepetru');
insert into utilizator (nume, mail, parola)
values ('Marcel Ioan', 'marcel-ioan@gmail.com', 'marcelioan');
insert into utilizator (nume, mail, parola)
values ('Vlada Gogu', 'vlada-gogu@gmail.com', 'vladagogu');
insert into utilizator (nume)
values ('Gheorghe Rut');
insert into utilizator (nume, mail, parola)
values ('Saiz Liviu', 'saiz-liviu@gmail.com', 'saizliviu');
insert into utilizator (nume, mail, parola)
values ('Ilie Karla', 'ilie-karla@gmail.com', 'iliekarla');
insert into utilizator (nume, mail, parola)
values ('Bratiloveanu Eva', 'bratiloveanu-eva@gmail.com', 'bratiloveanueva');

-- ISTORIC (entitate independenta)
insert into istoric (incepe, termina) values (
    to_date('2026-12-25 19:10', 'YYYY-MM-DD HH24:MI'),
    to_date('2026-12-25 21:10', 'YYYY-MM-DD HH24:MI')
);
insert into istoric (incepe, termina) values (
    to_date('2026-02-05 13:45', 'YYYY-MM-DD HH24:MI'),
    to_date('2026-02-05 15:15', 'YYYY-MM-DD HH24:MI')
);
insert into istoric (incepe, termina) values (
    to_date('2027-12-25 20:00', 'YYYY-MM-DD HH24:MI'),
    to_date('2027-12-25 23:00', 'YYYY-MM-DD HH24:MI')
);
insert into istoric (incepe, termina) values (
    to_date('2026-10-01 09:00', 'YYYY-MM-DD HH24:MI'),
    to_date('2026-10-01 12:00', 'YYYY-MM-DD HH24:MI')
);
insert into istoric (incepe, termina) values (
    to_date('2028-05-17 12:15', 'YYYY-MM-DD HH24:MI'),
    to_date('2028-05-18 10:15', 'YYYY-MM-DD HH24:MI')
);
insert into istoric (incepe, termina) values (
    to_date('2026-04-30 21:40', 'YYYY-MM-DD HH24:MI'),
    to_date('2026-05-01 08:00', 'YYYY-MM-DD HH24:MI')
);
insert into istoric (incepe, termina) values (
    to_date('2030-02-01 12:00', 'YYYY-MM-DD HH24:MI'),
    to_date('2031-01-02 12:00', 'YYYY-MM-DD HH24:MI')
);

-- JUDET (entitate dependenta de TARA)
insert into judet (id_tara, denumire) values (1, 'Vrancea');
insert into judet (id_tara, denumire) values (2, 'Cernauti');
insert into judet (id_tara, denumire) values (3, 'Baranya');
insert into judet (id_tara, denumire) values (4, 'Pirot');
insert into judet (id_tara, denumire) values (5, 'Ostrobotnia');
insert into judet (id_tara, denumire) values (6, 'Bavaria');
insert into judet (id_tara, denumire) values (7, 'Occitanie');

-- LOCATIE (entitate dependenta de JUDET)
insert into locatie (id_judet, denumire) values (1, 'Muzeul Unirii Focsani');
insert into locatie (id_judet, denumire) values (1, 'Teatrul Pastia');
insert into locatie (id_judet, denumire) values (1, 'Ateneul Popular');
insert into locatie (id_judet, denumire) values (1, 'Catedrala Unirii');
insert into locatie (id_judet, denumire) values (1, 'Mausoleul Sud');
insert into locatie (id_judet, denumire) values (1, 'Parcul Balcescu');
insert into locatie (id_judet, denumire) values (1, 'Piata Garii');
insert into locatie (id_judet, denumire) values (1, 'Stadionul Milcovul');
insert into locatie (id_judet, denumire) values (1, 'Biblioteca Judeteana');
insert into locatie (id_judet, denumire) values (1, 'Prefectura Veche');
insert into locatie (id_judet, denumire) values (1, 'Muzeul Satului');
insert into locatie (id_judet, denumire) values (1, 'Galeriile de Arta');
insert into locatie (id_judet, denumire) values (2, 'Parcul din Cozmeni');
insert into locatie (id_judet, denumire) values (3, 'Gerre Attila Villany');
insert into locatie (id_judet, denumire) values (4, 'Parcul din Babusnita');
insert into locatie (id_judet, denumire) values (5, 'Cabana Larsmo');
insert into locatie (id_judet, denumire) values (6, 'Piata Munchen');
insert into locatie (id_judet, denumire) values (7, 'Pont Vieux Albi');

-- ORGANIZATOR (subentitate UTILIZATOR)
insert into organizator (id_utilizator, contact) 
values (5, 'saizliviu.ro');
insert into organizator (id_utilizator, contact)
values (4, 'facebook.com/gheorhe-rut');
insert into organizator (id_utilizator, contact)
values (6, 'linkedin.com/in/ilie-karla');
insert into organizator (id_utilizator, contact)
values (7, 'bratiloveanu-eva.org');
insert into organizator (id_utilizator, contact)
values (3, 'youtube.com/@VladaGogu');

-- SPECTATOR (subentitate UTILIZATOR)
insert into spectator (id_utilizator, telefon)
values (1, '+40729583959');
insert into spectator (id_utilizator, telefon)
values (2, '+40758391849');
insert into spectator (id_utilizator, telefon)
values (3, '+40748593758');
insert into spectator (id_utilizator, telefon)
values (4, '+40738573968');
insert into spectator (id_utilizator, telefon)
values (5, '+40737584968');

-- SPECTATOR_LOCATIE (tabel asociativ)
insert into spectator_locatie (id_utilizator, id_locatie)
values (1, 5);
insert into spectator_locatie (id_utilizator, id_locatie)
values (1, 2);
insert into spectator_locatie (id_utilizator, id_locatie)
values (1, 7);
insert into spectator_locatie (id_utilizator, id_locatie)
values (2, 3);
insert into spectator_locatie (id_utilizator, id_locatie)
values (3, 2);
insert into spectator_locatie (id_utilizator, id_locatie)
values (3, 3);
insert into spectator_locatie (id_utilizator, id_locatie)
values (3, 4);
insert into spectator_locatie (id_utilizator, id_locatie)
values (4, 1);
insert into spectator_locatie (id_utilizator, id_locatie)
values (5, 4);
insert into spectator_locatie (id_utilizator, id_locatie)
values (5, 7);
insert into spectator_locatie (id_utilizator, id_locatie)
values (5, 6);
insert into spectator_locatie (id_utilizator, id_locatie)
values (5, 5);

-- EVENIMENT (entitate dependenta de ORGANIZATOR)
insert into eveniment (id_utilizator, denumire, pret)
values (3, 'Smart Hack', 149.49);
insert into eveniment (id_utilizator, denumire)
values (4, 'Seara Colinde');
insert into eveniment (id_utilizator, denumire, pret)
values (5, 'DAW Internship', 2039.89);
insert into eveniment (id_utilizator, denumire, pret)
values (6, 'Marsul Aparatorilor Credintei', 0);
insert into eveniment (id_utilizator, denumire)
values (7, 'Trezirea Natiunii');
insert into eveniment (id_utilizator, denumire, pret)
values (3, 'Hackathon', 749.49);
insert into eveniment (id_utilizator, denumire)
values (4, 'Maraton de iarna');

-- BILET (entitate de legatur intre SPECTATOR si EVENIMENT)
insert into bilet (id_utilizator, id_eveniment, pret, stare, loc)
values (1, 1, 149.49, 'folosit', 31);
insert into bilet (id_utilizator, id_eveniment, pret, stare, loc)
values (1, 1, 279.79, 'cumparat', 59);
insert into bilet (id_utilizator, id_eveniment, pret, stare, loc)
values (2, 4, 0, 'folosit', 150);
insert into bilet (id_utilizator, id_eveniment)
values (3, 2);
insert into bilet (id_utilizator, id_eveniment, pret, stare, loc)
values (4, 3, 2039.89, 'rezervat', 12);
insert into bilet (id_utilizator, id_eveniment)
values (5, 2);
insert into bilet (id_utilizator, id_eveniment)
values (5, 5);

-- EVENIMENT_LOCATIE (tabel asociativ)
insert into eveniment_locatie (id_eveniment, id_locatie) values (1, 17);
insert into eveniment_locatie (id_eveniment, id_locatie) values (1, 18);
insert into eveniment_locatie (id_eveniment, id_locatie) values (2, 18);
insert into eveniment_locatie (id_eveniment, id_locatie) values (2, 17);
insert into eveniment_locatie (id_eveniment, id_locatie) values (3, 16);
insert into eveniment_locatie (id_eveniment, id_locatie) values (3, 18);
insert into eveniment_locatie (id_eveniment, id_locatie) values (4, 14);
insert into eveniment_locatie (id_eveniment, id_locatie) values (4, 16);
insert into eveniment_locatie (id_eveniment, id_locatie) values (4, 18);
insert into eveniment_locatie (id_eveniment, id_locatie) values (5, 1);
insert into eveniment_locatie (id_eveniment, id_locatie) values (5, 16);
insert into eveniment_locatie (id_eveniment, id_locatie) values (5, 17);
insert into eveniment_locatie (id_eveniment, id_locatie) values (7, 2);
insert into eveniment_locatie (id_eveniment, id_locatie) values (7, 3);
insert into eveniment_locatie (id_eveniment, id_locatie) values (7, 4);
insert into eveniment_locatie (id_eveniment, id_locatie) values (7, 5);
insert into eveniment_locatie (id_eveniment, id_locatie) values (7, 6);
insert into eveniment_locatie (id_eveniment, id_locatie) values (7, 7);
insert into eveniment_locatie (id_eveniment, id_locatie) values (7, 8);
insert into eveniment_locatie (id_eveniment, id_locatie) values (7, 9);
insert into eveniment_locatie (id_eveniment, id_locatie) values (7, 10);
insert into eveniment_locatie (id_eveniment, id_locatie) values (7, 11);
insert into eveniment_locatie (id_eveniment, id_locatie) values (7, 12);

-- EVENIMENT_ISTORIC (tabel asociativ)
insert into eveniment_istoric (id_eveniment, id_istoric) values (1, 5);
insert into eveniment_istoric (id_eveniment, id_istoric) values (1, 6);
insert into eveniment_istoric (id_eveniment, id_istoric) values (2, 1);
insert into eveniment_istoric (id_eveniment, id_istoric) values (2, 3);
insert into eveniment_istoric (id_eveniment, id_istoric) values (3, 7);
insert into eveniment_istoric (id_eveniment, id_istoric) values (4, 2);
insert into eveniment_istoric (id_eveniment, id_istoric) values (4, 4);
insert into eveniment_istoric (id_eveniment, id_istoric) values (4, 5);
insert into eveniment_istoric (id_eveniment, id_istoric) values (4, 6);
insert into eveniment_istoric (id_eveniment, id_istoric) values (4, 1);
insert into eveniment_istoric (id_eveniment, id_istoric) values (5, 4);
insert into eveniment_istoric (id_eveniment, id_istoric) values (5, 5);

-- Salveaza modificarile 
commit;

select id_istoric, to_char(incepe, 'YYYY-MM-DD HH24:SS') as incepe, to_char(termina, 'YYYY-MM-DD HH24:SS') as termina from istoric;

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
    v_total_locatii_gasite number := 0;
    v_cnt number := 0;
begin
    -- Preia numele evenimentului
    select denumire into v_nume_eveniment from eveniment where id_eveniment = p_id_eveniment;
    dbms_output.put_line('# Raport eveniment: ' || v_nume_eveniment);
    dbms_output.put_line('');

    --
    -- a) INDEX-BY TABLE
    --

    for r_spectator in (
        select u.id_utilizator, u.nume
        from utilizator u, bilet b
        where u.id_utilizator = b.id_utilizator
        and b.id_eveniment = p_id_eveniment
    ) loop
        v_spectatori(r_spectator.id_utilizator) := r_spectator.nume;
    end loop;

    v_index := v_spectatori.first;

    dbms_output.put_line('## Spectatori inscrisi');

    -- Testeaza: raport_eveniment(2);
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

        -- Testeaza: raport_eveniment(1);
        dbms_output.put_line(''); 
        dbms_output.put_line('- Pretul mediu al unui bilet este ' || round(v_suma_preturi/v_preturi.count, 2));
    else
        -- Testeaza: raport_eveniment(6);
        dbms_output.put_line('Nu s-au gasit bilete'); 
    end if;

    --
    -- c) VARRAY
    --

    for r_loc in (
        select l.denumire
        from locatie l, eveniment_locatie el
        where l.id_locatie = el.id_locatie
        and el.id_eveniment = p_id_eveniment
    ) loop
        v_total_locatii_gasite := v_total_locatii_gasite + 1;
        if v_locatii.count < 10 then
            v_locatii.extend;
            v_locatii(v_locatii.last) := r_loc.denumire;
        end if;
    end loop;

    dbms_output.put_line('');
    dbms_output.put_line('## Locatii desfasurare');

    if v_total_locatii_gasite > 10 then
        -- Testeaza: raport_eveniment(7);
        dbms_output.put_line('S-au gasit mai multe locatii decat limita prestabilita');
    else
        v_cnt := 1;

        -- Testeaza: raport_eveniment(4);
        for i in 1..v_locatii.count loop
            dbms_output.put_line(v_cnt || '. ' || v_locatii(i));
            v_cnt := v_cnt + 1;
        end loop;
    end if;
exception
    when no_data_found then
        -- Testeaza: raport_eveniment(101);
        dbms_output.put_line('Eroare: Eveniment inexistent.');
    when others then
        dbms_output.put_line('Eroare: ' || sqlerrm);
end;
/

set serveroutput on;

begin
    raport_eveniment(101);
end;
/

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
        from utilizator u, organizator o
        where o.id_utilizator = u.id_utilizator
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

-- Sterge linia daca vrei sa actualizezi tabelul bilet cu noul pret (300 pentru primul, al doilea nu se modifica intrucat este deja folosit)
rollback;

-- Sterge linia daca vrei sa ramana trigger-ul
drop trigger protectie_bilete_folosite;

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
