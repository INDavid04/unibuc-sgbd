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
insert into utilizator (nume, mail, parola)
values ('Gheorge Rut', 'gheorghe-rut@gmail.com', 'gheorgherut');
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
insert into eveniment (id_utilizator, denumire, pret)
values (4, 'Seara Colinde');
insert into eveniment (id_utilizator, denumire, pret)
values (5, 'DAW Internship', 2039.89);
insert into eveniment (id_utilizator, denumire, pret)
values (6, 'Marsul Aparatorilor Credintei', 0);
insert into eveniment (id_utilizator, denumire, pret)
values (7, 'Trezirea Natiunii');

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
values (5, 7);

-- EVENIMENT_LOCATIE (tabel asociativ)
insert into eveniment_locatie (id_eveniment, id_locatie) values (1, 6);
insert into eveniment_locatie (id_eveniment, id_locatie) values (1, 7);
insert into eveniment_locatie (id_eveniment, id_locatie) values (2, 7);
insert into eveniment_locatie (id_eveniment, id_locatie) values (2, 6);
insert into eveniment_locatie (id_eveniment, id_locatie) values (3, 5);
insert into eveniment_locatie (id_eveniment, id_locatie) values (3, 7);
insert into eveniment_locatie (id_eveniment, id_locatie) values (4, 3);
insert into eveniment_locatie (id_eveniment, id_locatie) values (4, 5);
insert into eveniment_locatie (id_eveniment, id_locatie) values (4, 7);
insert into eveniment_locatie (id_eveniment, id_locatie) values (5, 1);
insert into eveniment_locatie (id_eveniment, id_locatie) values (5, 5);
insert into eveniment_locatie (id_eveniment, id_locatie) values (5, 6);

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

-- Salveaza datele inserate
commit;
