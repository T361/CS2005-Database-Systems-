-- =============================================
-- SUZUKI DATABASE MANAGEMENT SYSTEM
-- TAIMOOR SHAUKAT  24i-3015
-- =============================================

-- Reset database to prevent 'in use' errors
USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Suzuki_Assignment')
BEGIN
    ALTER DATABASE Suzuki_Assignment SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Suzuki_Assignment;
END
GO

CREATE DATABASE Suzuki_Assignment;
GO
USE Suzuki_Assignment;
GO

-- =============================================
-- PART 3a: CREATE TABLES
-- =============================================

CREATE TABLE COLOR (
    Color_Name         VARCHAR(30)  PRIMARY KEY,
    Price_Incr_Percent DECIMAL(4,2) NOT NULL DEFAULT 0.00
);

CREATE TABLE SHOWROOM (
    Showroom_No INT          PRIMARY KEY,
    SR_Name     VARCHAR(100) NOT NULL,
    Owner_FN    VARCHAR(50),
    Owner_LN    VARCHAR(50),
    Owner_CNIC  VARCHAR(15),
    Reg_Date    DATE,
    City        VARCHAR(50),
    SR_Address  VARCHAR(255),
    Phone_No    VARCHAR(15)
);

CREATE TABLE CLIENT (
    Client_ID    INT          PRIMARY KEY,
    Email        VARCHAR(100),
    Phone_Number VARCHAR(15),
    Street       VARCHAR(100),
    City         VARCHAR(50),
    ZIP          VARCHAR(10)
);

CREATE TABLE CUSTOMER (
    Client_ID  INT          PRIMARY KEY,
    CNIC       VARCHAR(15) NOT NULL,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name  VARCHAR(50) NOT NULL,
    FOREIGN KEY (Client_ID) REFERENCES CLIENT(Client_ID)
);

CREATE TABLE SUPPLIER (
    Client_ID       INT          PRIMARY KEY,
    NTN_No          VARCHAR(20)  NOT NULL,
    Company_Name    VARCHAR(100) NOT NULL,
    Company_Address VARCHAR(255),
    FOREIGN KEY (Client_ID) REFERENCES CLIENT(Client_ID)
);

CREATE TABLE VEHICLE (
    VIN              VARCHAR(17)   PRIMARY KEY,
    Model_Name       VARCHAR(50)   NOT NULL,
    Variant          VARCHAR(20)   CHECK (Variant IN ('Automatic','Manual')),
    Manufacture_Year INT,
    Launch_Date      DATE,
    Base_Price       DECIMAL(12,2) NOT NULL,
    Seats            INT,
    Doors            INT,
    Tyres            INT
);

CREATE TABLE CAR (
    VIN       VARCHAR(17) PRIMARY KEY,
    Body_Type VARCHAR(20) CHECK (Body_Type IN ('Sedan','Hatchback')),
    FOREIGN KEY (VIN) REFERENCES VEHICLE(VIN) ON DELETE CASCADE
);

CREATE TABLE TRUCK (
    VIN              VARCHAR(17)   PRIMARY KEY,
    Has_Chassis      BIT           NOT NULL DEFAULT 1,
    Loading_Capacity DECIMAL(10,2),
    FOREIGN KEY (VIN) REFERENCES VEHICLE(VIN) ON DELETE CASCADE
);

CREATE TABLE MOTORCYCLE (
    VIN                   VARCHAR(17) PRIMARY KEY,
    Has_Stability_Control BIT         NOT NULL DEFAULT 0,
    FOREIGN KEY (VIN) REFERENCES VEHICLE(VIN) ON DELETE CASCADE
);

CREATE TABLE ACCESSORY (
    Accessory_ID       INT         PRIMARY KEY,
    Accessory_Name     VARCHAR(50) NOT NULL,
    Price_Incr_Percent DECIMAL(4,2) NOT NULL DEFAULT 2.00
);

CREATE TABLE VEHICLE_ACCESSORY (
    VIN          VARCHAR(17),
    Accessory_ID INT,
    PRIMARY KEY (VIN, Accessory_ID),
    FOREIGN KEY (VIN)          REFERENCES VEHICLE(VIN),
    FOREIGN KEY (Accessory_ID) REFERENCES ACCESSORY(Accessory_ID)
);

CREATE TABLE BOOKING (
    Booking_ID        INT           PRIMARY KEY,
    VIN               VARCHAR(17),
    Client_ID         INT,
    Showroom_No       INT,
    Booking_Date      DATE          NOT NULL,
    Cancellation_Date DATE,
    Advance_Amt       DECIMAL(12,2),
    Remaining_Amt     DECIMAL(12,2),
    Booking_Status    VARCHAR(20)   CHECK (Booking_Status IN ('Confirmed','Pending','Delivered','Cancelled')),
    FOREIGN KEY (VIN)         REFERENCES VEHICLE(VIN),
    FOREIGN KEY (Client_ID)   REFERENCES CLIENT(Client_ID),
    FOREIGN KEY (Showroom_No) REFERENCES SHOWROOM(Showroom_No)
);

-- =============================================
-- PART 3b: INSERT DATA
-- =============================================

INSERT INTO COLOR VALUES
('Pearl White',    4.00), ('Silky Silver',   0.00), ('Graphite Grey',  2.00),
('Phoenix Red',    6.00), ('Midnight Black', 4.00), ('Ocean Blue',     3.00),
('Sunset Orange',  5.00), ('Forest Green',   2.00), ('Royal Purple',   3.00),
('Desert Beige',   1.00);

INSERT INTO SHOWROOM (Showroom_No, SR_Name, Owner_FN, Owner_LN, Owner_CNIC, Reg_Date, City, SR_Address, Phone_No) VALUES
(1,  'Suzuki I-8',         'Ahmad',  'Khan',    '61101-1111111-1', '2015-03-10', 'Islamabad',  'Plot 12, I-8 Markaz, Islamabad',       '051-1111111'),
(2,  'Suzuki Gulberg',     'Bilal',  'Akhtar',  '35201-2222222-2', '2016-07-22', 'Lahore',     '45 Main Gulberg, Lahore',              '042-2222222'),
(3,  'Suzuki DHA Karachi', 'Kamran', 'Mirza',   '42101-3333333-3', '2017-01-15', 'Karachi',    'DHA Phase 5, Karachi',                 '021-3333333'),
(4,  'Suzuki Saddar',      'Usman',  'Butt',    '37201-4444444-4', '2018-05-10', 'Rawalpindi', 'Saddar Bazaar, Rawalpindi',            '051-4444444'),
(5,  'Suzuki Hayatabad',   'Fahad',  'Yousaf',  '17301-5555555-5', '2019-02-18', 'Peshawar',   'Hayatabad Phase 3, Peshawar',          '091-5555555'),
(6,  'Suzuki Satellite',   'Tariq',  'Mahmood', '21201-6666666-6', '2020-08-05', 'Multan',     'Satellite Town, Multan',               '061-6666666'),
(7,  'Suzuki Cantt',       'Imran',  'Siddiqui','38401-7777777-7', '2020-11-20', 'Faisalabad', 'Cantt Area, Faisalabad',               '041-7777777'),
(8,  'Suzuki Model Town',  'Zahid',  'Hussain', '35302-8888888-8', '2021-03-14', 'Lahore',     'Model Town Extension, Lahore',         '042-8888888'),
(9,  'Suzuki Quetta',      'Nasir',  'Baloch',  '50101-9999999-9', '2021-06-25', 'Quetta',     'Jinnah Road, Quetta',                  '081-9999999'),
(10, 'Suzuki Sukkur',      'Farhan', 'Shaikh',  '45501-1010101-1', '2022-01-30', 'Sukkur',     'Station Road, Sukkur',                 '071-1010101');

INSERT INTO CLIENT (Client_ID, Email, Phone_Number, Street, City, ZIP) VALUES
(1,  'taimoor@fast.com',    '0311-1111111', 'Street 5, G-9',          'Islamabad',  '44000'),
(2,  'mustafa@lse.com',     '0322-2222222', 'Street 10, Gulberg',      'Lahore',     '54000'),
(3,  'sara@gmail.com',      '0333-3333333', 'Street 3, DHA',           'Karachi',    '75500'),
(4,  'hassan@yahoo.com',    '0344-4444444', 'Street 7, F-11',          'Islamabad',  '44000'),
(5,  'ali@hotmail.com',     '0355-5555555', 'Street 2, Model Town',    'Lahore',     '54700'),
(6,  'zara@gmail.com',      '0366-6666666', 'Street 9, Hayatabad',     'Peshawar',   '25000'),
(7,  'omar@yahoo.com',      '0377-7777777', 'Street 1, Cantt',         'Rawalpindi', '46000'),
(8,  'hina@fast.com',       '0388-8888888', 'Street 4, Clifton',       'Karachi',    '75600'),
(9,  'raza@lse.com',        '0399-9999999', 'Street 6, Johar Town',    'Lahore',     '54782'),
(10, 'nadia@gmail.com',     '0300-1010101', 'Street 8, Satellite',     'Multan',     '60000'),
(11, 'indus@biz.com',       '0301-1111111', '34 Industrial Area',      'Karachi',    '74200'),
(12, 'pakwheels@corp.com',  '0302-2222222', '12 Commerce Centre',      'Lahore',     '54000'),
(13, 'atlas@motors.com',    '0303-3333333', '56 Blue Area',            'Islamabad',  '44000'),
(14, 'metro@auto.com',      '0304-4444444', '78 M.A. Jinnah Road',     'Karachi',    '74400'),
(15, 'topline@trade.com',   '0305-5555555', '90 Gulberg III',          'Lahore',     '54660'),
(16, 'masood@motors.com',   '0306-6666666', '23 Hayatabad',            'Peshawar',   '25000'),
(17, 'premier@auto.com',    '0307-7777777', '11 Saddar',               'Rawalpindi', '46000'),
(18, 'alkhair@trading.com', '0308-8888888', '45 Satellite Town',       'Multan',     '60000'),
(19, 'sitara@parts.com',    '0309-9999999', '67 Cantt',                'Faisalabad', '38000'),
(20, 'crown@motors.com',    '0300-2020202', '89 Sukkur Road',          'Sukkur',     '65200');

INSERT INTO CUSTOMER (Client_ID, CNIC, First_Name, Last_Name) VALUES
(1,  '61101-1111111-1', 'Taimoor', 'Shaukat'),
(2,  '35201-2222222-2', 'Mustafa', 'Shaukat'),
(3,  '42101-3333333-3', 'Sara',    'Ahmed'),
(4,  '61101-4444444-4', 'Hassan',  'Raza'),
(5,  '35202-5555555-5', 'Ali',     'Malik'),
(6,  '17301-6666666-6', 'Zara',    'Khan'),
(7,  '37201-7777777-7', 'Omar',    'Qureshi'),
(8,  '42201-8888888-8', 'Hina',    'Baig'),
(9,  '35201-9999999-9', 'Raza',    'Hussain'),
(10, '32101-1010101-1', 'Nadia',   'Siddiqui');

INSERT INTO SUPPLIER (Client_ID, NTN_No, Company_Name, Company_Address) VALUES
(11, '1234567-1', 'Indus Tyres Ltd',   '34 Industrial Area, Karachi'),
(12, '2345678-2', 'PakWheels Corp',    '12 Commerce Centre, Lahore'),
(13, '3456789-3', 'Atlas Motors',      '56 Blue Area, Islamabad'),
(14, '4567890-4', 'Metro Auto Parts',  '78 M.A. Jinnah Road, Karachi'),
(15, '5678901-5', 'Topline Trading',   '90 Gulberg III, Lahore'),
(16, '6789012-6', 'Masood Motors',     '23 Hayatabad, Peshawar'),
(17, '7890123-7', 'Premier Auto',      '11 Saddar, Rawalpindi'),
(18, '8901234-8', 'Al Khair Trading',  '45 Satellite Town, Multan'),
(19, '9012345-9', 'Sitara Parts',      '67 Cantt, Faisalabad'),
(20, '0123456-0', 'Crown Motors',      '89 Sukkur Road, Sukkur');

INSERT INTO VEHICLE (VIN, Model_Name, Variant, Manufacture_Year, Launch_Date, Base_Price, Seats, Doors, Tyres) VALUES
('C01', 'Swift',       'Manual',    2023, '2023-01-15', 4500000.00, 5, 4, 4),
('C02', 'Alto',        'Automatic', 2022, '2022-06-01', 2800000.00, 5, 4, 4),
('C03', 'WagonR',      'Automatic', 2023, '2023-03-20', 3200000.00, 5, 4, 4),
('C04', 'Cultus',      'Manual',    2021, '2021-09-10', 3000000.00, 5, 4, 4),
('C05', 'Ciaz',        'Automatic', 2022, '2022-11-05', 5200000.00, 5, 4, 4),
('C06', 'Baleno',      'Manual',    2023, '2023-05-12', 4800000.00, 5, 4, 4),
('C07', 'Ignis',       'Automatic', 2021, '2021-07-22', 4100000.00, 5, 4, 4),
('C08', 'Celerio',     'Manual',    2020, '2020-04-18', 2600000.00, 5, 4, 4),
('C09', 'S-Presso',    'Automatic', 2022, '2022-08-30', 2900000.00, 5, 4, 4),
('C10', 'Ertiga',      'Automatic', 2021, '2021-12-01', 5500000.00, 7, 4, 4),
('T01', 'Carry',       'Manual',    2022, '2022-02-14', 3800000.00, 2, 2, 4),
('T02', 'Super Carry', 'Manual',    2023, '2023-04-01', 4200000.00, 2, 2, 4),
('T03', 'Mega Carry',  'Manual',    2021, '2021-06-15', 4500000.00, 3, 2, 4),
('T04', 'Carry Pro',   'Automatic', 2022, '2022-10-10', 5000000.00, 3, 2, 4),
('T05', 'Titan',       'Manual',    2020, '2020-08-20', 6200000.00, 2, 2, 6),
('T06', 'HeavyHaul',   'Manual',    2021, '2021-03-05', 7500000.00, 2, 2, 6),
('T07', 'FreightMax',  'Automatic', 2022, '2022-07-25', 8000000.00, 2, 2, 6),
('T08', 'MiniLoad',    'Manual',    2023, '2023-02-18', 3500000.00, 2, 2, 4),
('T09', 'CompactHaul', 'Manual',    2020, '2020-11-12', 4800000.00, 3, 2, 4),
('T10', 'MaxFreight',  'Automatic', 2021, '2021-09-28', 9000000.00, 2, 2, 8),
('M01', 'GS150',       'Manual',    2023, '2023-01-10',  380000.00, 2, NULL, 2),
('M02', 'GD110S',      'Manual',    2022, '2022-03-15',  280000.00, 2, NULL, 2),
('M03', 'GR150',       'Manual',    2021, '2021-05-20',  420000.00, 2, NULL, 2),
('M04', 'Raider150',   'Manual',    2023, '2023-06-01',  350000.00, 2, NULL, 2),
('M05', 'Hayabusa',    'Manual',    2022, '2022-09-10', 2500000.00, 2, NULL, 2),
('M06', 'V-Strom',     'Manual',    2021, '2021-11-25', 1800000.00, 2, NULL, 2),
('M07', 'Burgman',     'Automatic', 2023, '2023-04-05',  950000.00, 2, NULL, 2),
('M08', 'Access125',   'Automatic', 2020, '2020-07-18',  320000.00, 2, NULL, 2),
('M09', 'Gixxer',      'Manual',    2022, '2022-10-30',  680000.00, 2, NULL, 2),
('M10', 'Intruder150', 'Manual',    2021, '2021-08-14',  520000.00, 2, NULL, 2);

INSERT INTO CAR (VIN, Body_Type) VALUES
('C01', 'Hatchback'), ('C02', 'Hatchback'), ('C03', 'Hatchback'), ('C04', 'Hatchback'),
('C05', 'Sedan'), ('C06', 'Hatchback'), ('C07', 'Hatchback'), ('C08', 'Hatchback'),
('C09', 'Hatchback'), ('C10', 'Hatchback');

INSERT INTO TRUCK (VIN, Has_Chassis, Loading_Capacity) VALUES
('T01', 1,  1000.00), ('T02', 1,  1500.00), ('T03', 0,  2000.00), ('T04', 1,  2500.00),
('T05', 1,  5000.00), ('T06', 1,  8000.00), ('T07', 0,  7000.00), ('T08', 1,   800.00),
('T09', 1,  3000.00), ('T10', 0, 12000.00);

INSERT INTO MOTORCYCLE (VIN, Has_Stability_Control) VALUES
('M01', 0), ('M02', 0), ('M03', 1), ('M04', 0), ('M05', 1),
('M06', 1), ('M07', 0), ('M08', 0), ('M09', 1), ('M10', 0);

INSERT INTO ACCESSORY (Accessory_ID, Accessory_Name, Price_Incr_Percent) VALUES
(1,  'Premium Speakers',  2.00), (2,  'Music System',      2.00), (3,  'Navigation System', 2.00),
(4,  'Reverse Camera',    2.00), (5,  'Sunroof',           2.00), (6,  'Leather Seats',     2.00),
(7,  'Alloy Wheels',      2.00), (8,  'Bluetooth System',  2.00), (9,  'Parking Sensors',   2.00),
(10, 'Dashcam',           2.00);

INSERT INTO VEHICLE_ACCESSORY (VIN, Accessory_ID) VALUES
('C01', 1), ('C01', 3), ('C02', 2), ('C03', 3), ('C04', 9),
('C05', 1), ('C05', 2), ('C05', 3), ('C06', 4), ('C10', 5);

INSERT INTO BOOKING (Booking_ID, VIN, Client_ID, Showroom_No, Booking_Date, Cancellation_Date, Advance_Amt, Remaining_Amt, Booking_Status) VALUES
(101, 'C01', 1,    1,    '2024-03-10', NULL,         500000,  4000000, 'Confirmed'),
(102, 'C02', 2,    2,    '2023-06-15', NULL,         300000,  2500000, 'Confirmed'),
(103, 'C03', 3,    3,    '2024-01-05', NULL,         350000,  2850000, 'Confirmed'),
(104, 'C04', 4,    1,    '2023-12-01', NULL,         350000,  2650000, 'Delivered'),
(105, 'C05', 5,    4,    '2024-02-14', NULL,         520000,  4680000, 'Pending'),
(106, 'C06', 6,    5,    '2024-04-20', NULL,         480000,  4320000, 'Confirmed'),
(107, 'C07', 7,    6,    '2023-09-11', NULL,         410000,  3690000, 'Delivered'),
(108, 'M01', 8,    NULL, '2024-03-22', NULL,          38000,   342000, 'Confirmed'),
(109, 'T01', 11,   9,    '2024-01-01', NULL,         760000,  3040000, 'Delivered'),
(110, 'T02', 12,   10,   '2024-02-28', NULL,         840000,  3360000, 'Confirmed'),
(111, 'C10', 13,   7,    '2024-03-15', NULL,         550000,  4950000, 'Confirmed'),
(112, 'M05', 14,   8,    '2023-11-10', NULL,         250000,  2250000, 'Delivered'),
(113, 'C08', 15,   2,    '2024-01-25', '2024-02-01', 260000,        0, 'Cancelled'),
(114, 'T03', 16,   3,    '2023-08-05', '2023-09-01', 450000,        0, 'Cancelled'),
(115, 'M03', 17,   4,    '2024-04-10', NULL,          42000,   378000, 'Pending');

-- =============================================
-- SECTION 4a: SIMPLE QUERIES
-- =============================================

-- Q1: Total vehicles manufactured by Suzuki
SELECT COUNT(*) AS Total_Vehicles FROM VEHICLE;

-- Q2: Most expensive Suzuki car
SELECT V.VIN, V.Model_Name, V.Base_Price
FROM VEHICLE V
INNER JOIN CAR C ON V.VIN = C.VIN
WHERE V.Base_Price = (SELECT MAX(V2.Base_Price) FROM VEHICLE V2 INNER JOIN CAR C2 ON V2.VIN = C2.VIN);

-- Q3: All automatic cars
SELECT V.Model_Name, V.Variant, C.Body_Type
FROM VEHICLE V
INNER JOIN CAR C ON V.VIN = C.VIN
WHERE V.Variant = 'Automatic';

-- Q4: Vehicles with 4 tyres
SELECT COUNT(*) AS Vehicles_With_4_Tyres FROM VEHICLE WHERE Tyres = 4;

-- Q5: Oldest model car
SELECT V.Model_Name, V.Manufacture_Year
FROM VEHICLE V
INNER JOIN CAR C ON V.VIN = C.VIN
WHERE V.Manufacture_Year = (SELECT MIN(V2.Manufacture_Year) FROM VEHICLE V2 INNER JOIN CAR C2 ON V2.VIN = C2.VIN);

-- Q6: Insert new customer
INSERT INTO CLIENT (Client_ID, Email, Phone_Number, Street, City, ZIP)
VALUES (100, 'alex@email.com', NULL, 'House 123, Street 234, Xyz Colony', 'Xyz', NULL);
INSERT INTO CUSTOMER (Client_ID, CNIC, First_Name, Last_Name)
VALUES (100, '1234', 'Alex', 'Brown');

-- Q8: Delete a specified vehicle (M10)
DELETE FROM BOOKING     WHERE VIN = 'M10';
DELETE FROM MOTORCYCLE  WHERE VIN = 'M10';
DELETE FROM VEHICLE     WHERE VIN = 'M10';

-- Q9: Update price of Swift (Increase 10%)
UPDATE VEHICLE SET Base_Price = Base_Price * 1.10 WHERE Model_Name = 'Swift';

-- Q10: Cancel a supplier booking
UPDATE BOOKING
SET Booking_Status = 'Cancelled', Cancellation_Date = GETDATE(), Remaining_Amt = 0
WHERE Booking_ID = (
    SELECT TOP 1 B.Booking_ID FROM BOOKING B
    INNER JOIN SUPPLIER S ON B.Client_ID = S.Client_ID
    WHERE B.Booking_Status = 'Confirmed'
    ORDER BY B.Booking_ID
);

-- =============================================
-- SECTION 4b: COMPLEX QUERIES
-- =============================================

-- Q1: Sales of cars in March
SELECT B.Booking_ID, V.Model_Name, C.Body_Type, B.Booking_Date
FROM BOOKING B
INNER JOIN VEHICLE V ON B.VIN = V.VIN
INNER JOIN CAR C ON V.VIN = C.VIN
WHERE MONTH(B.Booking_Date) = 3;

-- Q2: Vehicles available in Suzuki I-8
SELECT V.Model_Name, V.Variant, S.SR_Name, B.Booking_Status
FROM VEHICLE V
INNER JOIN BOOKING B ON V.VIN = B.VIN
INNER JOIN SHOWROOM S ON B.Showroom_No = S.Showroom_No
WHERE S.SR_Name = 'Suzuki I-8';

-- Q3: Number of models supplied by Supplier 11
SELECT COUNT(DISTINCT V.Model_Name) AS Models_Supplied
FROM VEHICLE V
INNER JOIN BOOKING B ON V.VIN = B.VIN
INNER JOIN SUPPLIER S ON B.Client_ID = S.Client_ID
WHERE S.Client_ID = 11;

-- Q4: Supplier with the highest number of sales
SELECT S.Company_Name, COUNT(B.Booking_ID) AS Total_Sales
FROM SUPPLIER S
INNER JOIN BOOKING B ON S.Client_ID = B.Client_ID
WHERE B.Booking_Status = 'Delivered'
GROUP BY S.Company_Name
HAVING COUNT(B.Booking_ID) >= ALL (
    SELECT COUNT(B2.Booking_ID) FROM BOOKING B2
    INNER JOIN SUPPLIER S2 ON B2.Client_ID = S2.Client_ID
    WHERE B2.Booking_Status = 'Delivered'
    GROUP BY B2.Client_ID
);

-- Q5: Showroom with highest number of vehicles
SELECT S.SR_Name, COUNT(B.VIN) AS Total_Vehicles
FROM SHOWROOM S
INNER JOIN BOOKING B ON S.Showroom_No = B.Showroom_No
GROUP BY S.SR_Name
HAVING COUNT(B.VIN) >= ALL (SELECT COUNT(B2.VIN) FROM BOOKING B2 GROUP BY B2.Showroom_No);

-- Q6: All booked cars
SELECT V.Model_Name, C.Body_Type, B.Booking_Status, B.Booking_Date
FROM BOOKING B
INNER JOIN VEHICLE V ON B.VIN = V.VIN
INNER JOIN CAR C ON V.VIN = C.VIN
WHERE B.Booking_Status IN ('Confirmed','Pending','Delivered');

-- Q7: Total booking amount for cars only
SELECT SUM(B.Advance_Amt + B.Remaining_Amt) AS Total_Booking_Amount
FROM BOOKING B INNER JOIN CAR C ON B.VIN = C.VIN;

-- Q8: Customers who pick cars from showroom
SELECT CU.First_Name, CU.Last_Name, S.SR_Name, V.Model_Name
FROM CUSTOMER CU
INNER JOIN BOOKING B ON CU.Client_ID = B.Client_ID
INNER JOIN SHOWROOM S ON B.Showroom_No = S.Showroom_No
INNER JOIN VEHICLE V ON B.VIN = V.VIN
WHERE B.Booking_Status = 'Delivered';

-- Q9: Supplier with the most cancellations
SELECT S.Company_Name, COUNT(B.Booking_ID) AS Total_Cancellations
FROM SUPPLIER S
INNER JOIN BOOKING B ON S.Client_ID = B.Client_ID
WHERE B.Booking_Status = 'Cancelled'
GROUP BY S.Company_Name
HAVING COUNT(B.Booking_ID) >= ALL (
    SELECT COUNT(B2.Booking_ID) FROM BOOKING B2
    INNER JOIN SUPPLIER S2 ON B2.Client_ID = S2.Client_ID
    WHERE B2.Booking_Status = 'Cancelled'
    GROUP BY B2.Client_ID
);

-- Q10: Sales of vehicles in Islamabad
SELECT B.Booking_ID, V.Model_Name, S.SR_Name, S.City, B.Booking_Status
FROM BOOKING B
INNER JOIN VEHICLE V ON B.VIN = V.VIN
INNER JOIN SHOWROOM S ON B.Showroom_No = S.Showroom_No
WHERE S.City = 'Islamabad';

-- =============================================
-- SECTION 5: STUDENT DESIGNED QUERIES
-- =============================================

-- SQ1: High-Value Customers (Nested Subquery)
SELECT CU.First_Name, CU.Last_Name, (B.Advance_Amt + B.Remaining_Amt) AS Total_Spent
FROM CUSTOMER CU
INNER JOIN BOOKING B ON CU.Client_ID = B.Client_ID
WHERE (B.Advance_Amt + B.Remaining_Amt) > (SELECT AVG(Advance_Amt + Remaining_Amt) FROM BOOKING);

-- SQ2: Dead Stock - Vehicles Never Booked (EXCEPT Operator)
SELECT VIN, Model_Name, Base_Price FROM VEHICLE
EXCEPT
SELECT V.VIN, V.Model_Name, V.Base_Price FROM VEHICLE V INNER JOIN BOOKING B ON V.VIN = B.VIN;

-- SQ3: Unreliable Suppliers (EXISTS Operator)
SELECT DISTINCT S.Company_Name, CL.Email, CL.Phone_Number
FROM SUPPLIER S
INNER JOIN CLIENT CL ON S.Client_ID = CL.Client_ID
WHERE EXISTS (
    SELECT 1 FROM BOOKING B WHERE B.Client_ID = S.Client_ID AND B.Booking_Status = 'Cancelled'
);

-- SQ4: Full Showroom Inventory Audit (LEFT JOIN)
SELECT S.SR_Name, S.City, ISNULL(V.Model_Name, 'No Vehicle') AS Vehicle, ISNULL(B.Booking_Status,'No Booking') AS Status
FROM SHOWROOM S
LEFT JOIN BOOKING B ON S.Showroom_No = B.Showroom_No
LEFT JOIN VEHICLE V ON B.VIN = V.VIN;

-- SQ5: Above-Average Delivering Showrooms (Nested Aggregate Subquery)
SELECT S.SR_Name, S.City, COUNT(B.Booking_ID) AS Deliveries
FROM SHOWROOM S
INNER JOIN BOOKING B ON S.Showroom_No = B.Showroom_No
WHERE B.Booking_Status = 'Delivered'
GROUP BY S.SR_Name, S.City
HAVING COUNT(B.Booking_ID) > (
    SELECT AVG(CAST(D AS FLOAT)) FROM (SELECT COUNT(Booking_ID) AS D FROM BOOKING WHERE Booking_Status = 'Delivered' GROUP BY Showroom_No) AS T
);

-- =============================================
-- SECTION 6: SCHEMA EVOLUTION (Electric Vehicles)
-- =============================================

CREATE TABLE ELECTRIC_VEHICLE (
    VIN           VARCHAR(17)   PRIMARY KEY,
    Battery_Cap   DECIMAL(10,2) NOT NULL,
    Charging_Time DECIMAL(5,2)  NOT NULL,
    Driving_Range INT           NOT NULL,
    FOREIGN KEY (VIN) REFERENCES VEHICLE(VIN) ON DELETE CASCADE
);

INSERT INTO ELECTRIC_VEHICLE (VIN, Battery_Cap, Charging_Time, Driving_Range) VALUES
('C03',  55.00,  5.50, 350), ('C05',  75.00,  6.50, 450), ('C06',  60.00,  5.00, 380),
('C09',  40.00,  4.00, 280), ('C10',  85.00,  7.00, 500), ('M07',  12.00,  3.00, 120),
('M08',  10.00,  2.50, 100), ('T04', 120.00,  8.00, 300), ('T07', 200.00, 10.00, 600),
('M05',  15.00,  3.50, 150);

-- =============================================
-- SECTION 7: SCHEMA MODIFICATION TASKS
-- =============================================

-- Task 1: Add Website column to SHOWROOM
ALTER TABLE SHOWROOM ADD Website VARCHAR(100);

-- Task 2: Expand Booking_Status character limit
ALTER TABLE BOOKING ALTER COLUMN Booking_Status VARCHAR(50);

-- Task 3: Drop standalone table (COLOR)
DROP TABLE COLOR;

-- Task 4: Drop dependent tables (Child then Parent)
DROP TABLE VEHICLE_ACCESSORY;
DROP TABLE ACCESSORY;