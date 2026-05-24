--populate tables

--countries
INSERT INTO Countries VALUES (1, 'Romania');
INSERT INTO Countries VALUES (2, 'Germany');
INSERT INTO Countries VALUES (3, 'USA');

-- Cities
INSERT INTO Cities VALUES (1, 'București', 1);
INSERT INTO Cities VALUES (2, 'Cluj-Napoca', 1);
INSERT INTO Cities VALUES (3, 'Berlin', 2);
INSERT INTO Cities VALUES (4, 'New York', 3);

-- Actual Vehicle Types
INSERT INTO Vehicle_Types VALUES (1, 'Heavy Truck');
INSERT INTO Vehicle_Types VALUES (2, 'Delivery Van');
INSERT INTO Vehicle_Types VALUES (3, 'Cargo Plane');
COMMIT;

-- Hubs, Drivers, Fleet, Customers
DECLARE
BEGIN
    INSERT INTO Hubs VALUES (1, 1, 'Bucharest Sud Logistics');
    INSERT INTO Hubs VALUES (2, 2, 'Cluj Transylvania Hub');
    INSERT INTO Hubs VALUES (3, 4, 'Berlin Central'); 

    FOR i IN 1..50 LOOP
        INSERT INTO Drivers VALUES (i, 'Driver_' || i, 'RO' || TRUNC(DBMS_RANDOM.VALUE(100000, 999999)));
    END LOOP;

    FOR i IN 1..20 LOOP
        INSERT INTO Fleet VALUES (i, TRUNC(DBMS_RANDOM.VALUE(1, 4)), 'B-' || TRUNC(DBMS_RANDOM.VALUE(10, 99)) || '-TRK');
    END LOOP;

    FOR i IN 1..1000 LOOP
        INSERT INTO Customers VALUES (i, 'Corporate_Client_' || i || '_SRL');
    END LOOP;

    COMMIT;
END;
/
