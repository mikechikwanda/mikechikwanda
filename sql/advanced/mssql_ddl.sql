-- MSSQL DDL

CREATE DATABASE MarketManagement;

USE MarketManagement;

CREATE TABLE Products(
ProductID INT PRIMARY KEY IDENTITY(1,1),
Category NVARCHAR(3) NOT NULL,
Descrition VARCHAR(255),
Weight FLOAT CHECK(Weight > 0),
Price DECIMAL(18,2),
LauchDate DATE
);


-- add quantity column
ALTER TABLE Products ADD Quantity INT CHECK(Quantity >= 0); 

--drop Category column
ALTER TABLE Products DROP COLUMN Category;

-- create Category table
CREATE TABLE Category (
CategoryID INT PRIMARY KEY IDENTITY(1000,1),
[Name] VARCHAR(255) UNIQUE NOT NULL
);

-- add order table
CREATE TABLE Orders (
OrderId INT PRIMARY KEY IDENTITY(2000,1),
OrderDate DATETIME,
CustomerEmail VARCHAR(255) NOT NULL,
);

--add foreign key
ALTER TABLE Products
ADD CategoryID INT UNIQUE NOT NULL;

ALTER TABLE Products
ADD CONSTRAINT FK_Product_Category
FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID);


-- create mapping table to enforce many to many relationship
CREATE TABLE OrderLine (
OrderLineId INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
OrderID INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderID),
Quantity INT NOT NULL CHECK(Quantity >= 1)
);