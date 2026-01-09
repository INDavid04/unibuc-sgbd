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
