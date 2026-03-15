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
