CREATE DATABASE SupermarketDB;
USE SupermarketDB;
CREATE TABLE Suppliers (
    id INT  NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    company_name VARCHAR(150) NOT NULL
);

CREATE TABLE Products (
    id INT  NOT NULL,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    supplier_id INT,
);

CREATE TABLE Sales (
    id INT PRIMARY KEY NOT NULL,
    sale_date DATE NOT NULL,
    total_amount DECIMAL(12, 2) DEFAULT 0.00
);

CREATE TABLE SaleDetails (
    sale_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(12, 2) NOT NULL,
    PRIMARY KEY (sale_id, product_id),
);

CREATE TABLE Purchases (
    id INT PRIMARY KEY NOT NULL,
    supplier_id INT,
    purchase_date DATE NOT NULL,
    total_cost DECIMAL(12, 2) NOT NULL,
);
ALTER TABLE Suppliers 
ADD CONSTRAINT PK_Suppliers PRIMARY KEY (id);

ALTER TABLE Products 
ADD CONSTRAINT PK_Products PRIMARY KEY (id);

ALTER TABLE Sales 
ADD CONSTRAINT PK_Sales PRIMARY KEY (id);

ALTER TABLE SaleDetails 
ADD CONSTRAINT PK_SaleDetails PRIMARY KEY (sale_id, product_id);

ALTER TABLE Purchases 
ADD CONSTRAINT PK_Purchases PRIMARY KEY (id);

ALTER TABLE Products 
ADD CONSTRAINT FK_Products_Suppliers FOREIGN KEY (supplier_id) REFERENCES Suppliers(id);

ALTER TABLE SaleDetails 
ADD CONSTRAINT FK_SaleDetails_Sales FOREIGN KEY (sale_id) REFERENCES Sales(id);

ALTER TABLE SaleDetails 
ADD CONSTRAINT FK_SaleDetails_Products FOREIGN KEY (product_id) REFERENCES Products(id);

ALTER TABLE Purchases 
ADD CONSTRAINT FK_Purchases_Suppliers FOREIGN KEY (supplier_id) REFERENCES Suppliers(id);

ALTER TABLE Products 
ADD CONSTRAINT CHK_Products_Price CHECK (price > 0);

ALTER TABLE Products 
ADD CONSTRAINT CHK_Products_Stock CHECK (stock_quantity >= 0);

ALTER TABLE SaleDetails 
ADD CONSTRAINT CHK_SaleDetails_Quantity CHECK (quantity >= 1);

ALTER TABLE Products 
ADD CONSTRAINT DF_Products_Stock DEFAULT 0 FOR stock_quantity;

ALTER TABLE Products
ADD DISCOUNTS INT DEFAULT 0;

