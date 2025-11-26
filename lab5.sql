----------------------------------------------------------------
-- 1. Definiți un bloc anonim prin care sa afisati numărul de --
-- angajați pentru un departament dat de la tastatura.        --
----------------------------------------------------------------

DECLARE
    NUMAR_ANGAJATI NUMBER(10);
    NUMAR_DEPARTAMENT NUMBER(10);
BEGIN
    SELECT
        COUNT(*) INTO NUMAR_ANGAJATI
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = &NUMAR_DEPARTAMENT; -- CU & CITIM VARIABILA NUMAR_DEPARTAMENT
    
    DBMS_OUTPUT.PUT_LINE('DEPARTAMENTUL ' || NUMAR_DEPARTAMENT || 'ARE ' || NUMAR_ANGAJATI || ' ANGAJATI');
END;
/

------------------------------------------------------------------------------
-- 2. Definiți un bloc în care sa afisati pentru fiecare departament numele --
-- si procentul de angajați din firma, pe care il are.                      --
------------------------------------------------------------------------------

DECLARE
    NUMAR_DEPARTAMENT EMPLOYEES.DEPARTMENT_ID%TYPE := :DEPARTMENT_ID;
    NUMAR_ANGAJATI NUMBER(10);
BEGIN   
    SELECT COUNT(*)
    INTO v_num_angajati
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = v_department_id;

    DBMS_OUTPUT.PUT_LINE('Numarul de angajati din departamentul ' || v_department_id || ' este: ' || v_num_angajati);
END;
/

---------------------------------------------------------------------------------
-- 3. Definiți un bloc în care pentru fiecare zi a lui octombrie sa se afișeze --
-- numărul de angajari.                                                        --
---------------------------------------------------------------------------------

DECLARE
BEGIN
    FOR I IN (SELECT HIRE_DATE, COUNT(*) AS NUMAR_ANGAJATI
                FROM EMPLOYEES
                WHERE EXTRACT(MONTH FROM HIRE_DATE) = 10
                GROUP BY HIRE_DATE
                ORDER BY HIRE_DATE) LOOP
        DBMS_OUTPUT.PUT_LINE('DATA: ' || I.HIRE_DATE || ' ; NUMAR ANGAJATI: ' || I.NUMAR_ANGAJATI);
    END LOOP;
END;
/

----------------------------------------------------------------------------------
-- 4. Păstrați într-o colecție codurile celor mai prost plătiți 5 angajați care --
--nu câștigă comision. Folosind această colecție măriți cu 5% salariul          --
--acestor angajați. Afișați valoarea veche a salariului, respectiv              --
--valoarea nouă a salariului.                                                   --
----------------------------------------------------------------------------------

DECLARE
    TYPE AngajatiColectie IS TABLE OF EMPLOYEES.EMPLOYEE_ID%TYPE;
    coduri_angajati AngajatiColectie;

    salariu_vechi EMPLOYEES.SALARY%TYPE;
    salariu_nou EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT EMPLOYEE_ID
    BULK COLLECT INTO coduri_angajati
    FROM EMPLOYEES
    WHERE COMMISSION_PCT IS NULL
    ORDER BY SALARY
    FETCH FIRST 5 ROWS ONLY;

    FOR i IN 1 .. coduri_angajati.COUNT LOOP
        SELECT SALARY INTO salariu_vechi
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID = coduri_angajati(i);

        salariu_nou := salariu_vechi * 1.05;

        UPDATE EMPLOYEES
        SET SALARY = salariu_nou
        WHERE EMPLOYEE_ID = coduri_angajati(i);

        DBMS_OUTPUT.PUT_LINE('Angajat ' || coduri_angajati(i) || ': vechi=' || salariu_vechi || ', nou=' || salariu_nou);
    END LOOP;

    COMMIT;
END;
/

