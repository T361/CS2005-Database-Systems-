-- ==========================================
-- Part 1: Table Creation
-- ==========================================

CREATE TABLE Users(
    UserID INT PRIMARY KEY,
    UserName VARCHAR(50),
    City VARCHAR(50)
);

CREATE TABLE Sellers(
    SellerID INT PRIMARY KEY,
    SellerName VARCHAR(50),
    City VARCHAR(50)
);

CREATE TABLE Items(
    ItemID INT PRIMARY KEY,
    ItemName VARCHAR(50),
    Price DECIMAL(10,2),
    SellerID INT
);

CREATE TABLE Purchases(
    PurchaseID INT PRIMARY KEY,
    UserID INT,
    ItemID INT,
    Quantity INT,
    PurchaseDate DATE
);

-- ==========================================
-- Part 2: Insert Sample Data
-- ==========================================

INSERT INTO Users VALUES
(1,'Ali','Peshawar'),
(2,'Sara','Lahore'),
(3,'Usman','Karachi'),
(4,'Hina','Islamabad'),
(5,'Bilal','Multan'),
(6,'Zara','Quetta'),
(7,'Hamza','Peshawar'),
(8,'Ayesha','Lahore');

INSERT INTO Sellers VALUES
(1,'TechStore','Lahore'),
(2,'HomeShop','Islamabad'),
(3,'GadgetWorld','Karachi'),
(4,'FurnitureHub','Multan'),
(5,'DigitalMarket','Peshawar'),
(6,'SmartTech','Quetta'),
(7,'LaptopCenter','Lahore'),
(8,'OfficeNeeds','Islamabad');

INSERT INTO Items VALUES
(101,'Laptop',120000,1),
(102,'Mouse',1500,1),
(103,'Chair',8000,2),
(104,'Table',12000,2),
(105,'Keyboard',3000,3),
(106,'Monitor',25000,3),
(107,'Printer',20000,4),
(108,'Headphones',5000,5);

INSERT INTO Purchases VALUES
(1,1,101,1,'2025-02-01'),
(2,2,102,2,'2025-02-02'),
(3,3,103,1,'2025-02-05'),
(4,1,104,1,'2025-02-07'),
(5,4,105,1,'2025-02-10'),
(6,5,106,1,'2025-02-11'),
(7,6,107,1,'2025-02-12'),
(8,7,108,2,'2025-02-13');

-- ==========================================
-- Part 3: Insert Own Details
-- ==========================================

-- Insert one custom record into each table.
INSERT INTO Users VALUES (9, 'Ahmed', 'Islamabad');
INSERT INTO Sellers VALUES (9, 'TechGalaxy', 'Islamabad');
INSERT INTO Items VALUES (109, 'Smartwatch', 15000, 9);
INSERT INTO Purchases VALUES (9, 9, 109, 1, '2025-02-24');

-- ==========================================
-- Part 4: Queries
-- ==========================================

-- 1. Retrieve users and the items they have purchased.
SELECT U.UserName, I.ItemName 
FROM Users U
JOIN Purchases P ON U.UserID = P.UserID
JOIN Items I ON P.ItemID = I.ItemID;

-- 2. Display item names and their corresponding seller names.
SELECT I.ItemName, S.SellerName 
FROM Items I
JOIN Sellers S ON I.SellerID = S.SellerID;

-- 3. Find the total quantity sold for each item.
SELECT I.ItemName, SUM(P.Quantity) AS TotalQuantitySold
FROM Items I
JOIN Purchases P ON I.ItemID = P.ItemID
GROUP BY I.ItemName;

-- 4. Calculate the average price of items sold by each seller.
SELECT S.SellerName, AVG(I.Price) AS AverageItemPrice
FROM Sellers S
JOIN Items I ON S.SellerID = I.SellerID
GROUP BY S.SellerName;

-- 5. Display items whose names contain the word "Table" using LIKE.
SELECT * FROM Items 
WHERE ItemName LIKE '%Table%';

-- 6. Retrieve all users and their purchases (including zero purchases) using a LEFT JOIN.
SELECT U.UserName, I.ItemName, P.Quantity, P.PurchaseDate
FROM Users U
LEFT JOIN Purchases P ON U.UserID = P.UserID
LEFT JOIN Items I ON P.ItemID = I.ItemID;

-- 7. Display the total purchase quantity for each user.
SELECT U.UserName, COALESCE(SUM(P.Quantity), 0) AS TotalPurchaseQuantity
FROM Users U
LEFT JOIN Purchases P ON U.UserID = P.UserID
GROUP BY U.UserName;

-- 8. Find items where the total quantity sold exceeds 2 units using HAVING.
SELECT I.ItemName, SUM(P.Quantity) AS TotalQuantity
FROM Items I
JOIN Purchases P ON I.ItemID = P.ItemID
GROUP BY I.ItemName
HAVING SUM(P.Quantity) > 2;

-- 9. Retrieve the top 3 most purchased items based on quantity sold using TOP 3.
SELECT TOP 3 I.ItemName, SUM(P.Quantity) AS TotalQuantitySold
FROM Items I
JOIN Purchases P ON I.ItemID = P.ItemID
GROUP BY I.ItemName
ORDER BY TotalQuantitySold DESC;

-- 10. Generate all combinations of users and sellers using CROSS JOIN.
SELECT U.UserName, S.SellerName 
FROM Users U
CROSS JOIN Sellers S;

-- 11. Display a detailed purchase report including calculated total price (Price * Quantity).
SELECT 
    U.UserName, 
    I.ItemName, 
    S.SellerName, 
    P.Quantity, 
    (I.Price * P.Quantity) AS TotalPrice
FROM Purchases P
JOIN Users U ON P.UserID = U.UserID
JOIN Items I ON P.ItemID = I.ItemID
JOIN Sellers S ON I.SellerID = S.SellerID;

-- 12. Identify sellers who have sold items to more than one distinct user using COUNT(DISTINCT).
SELECT S.SellerName
FROM Sellers S
JOIN Items I ON S.SellerID = I.SellerID
JOIN Purchases P ON I.ItemID = P.ItemID
GROUP BY S.SellerName
HAVING COUNT(DISTINCT P.UserID) > 1;