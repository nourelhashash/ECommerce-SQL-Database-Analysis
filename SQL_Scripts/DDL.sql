USE ECommerce;

-- =================================================================
--                      TABLE CREATION
-- =================================================================

CREATE TABLE Customers(
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    RegistrationDate DATE DEFAULT GETDATE(),
    ShippingAddress NVARCHAR(255)
);

CREATE TABLE Categories(
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Suppliers(
    SupplierID INT PRIMARY KEY IDENTITY(1,1),
    SupplierName NVARCHAR(100) NOT NULL UNIQUE,
    ContactPerson NVARCHAR(100),
    PhoneNumber NVARCHAR(20)
);

CREATE TABLE Products(
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    Price DECIMAL(10,2) CHECK(Price > 0),
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    SupplierID INT FOREIGN KEY REFERENCES Suppliers(SupplierID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Inventory(
    ProductID INT PRIMARY KEY FOREIGN KEY REFERENCES Products(ProductID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    StockQuantity INT CHECK(StockQuantity >= 0),
    LastRestockDate DATE
);

CREATE TABLE Orders(
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) CHECK(Status IN('Pending','Processing','Shipped','Delivered','Canceled')),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE OrderItems(
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    Quantity INT CHECK(Quantity > 0),
    PriceAtTimeOfOrder DECIMAL(10,2),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Shipments(
    ShipmentID INT PRIMARY KEY IDENTITY(1,1),
    ShipmentDate DATE,
    TrackingNumber NVARCHAR(50) UNIQUE,
    Carrier NVARCHAR(50),
    OrderID INT UNIQUE FOREIGN KEY REFERENCES Orders(OrderID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

/*
"Relational Schema of E-Commerce Database"
E-Commerce Database Schema Diagram:

Customers           Categories           Suppliers
      ↓                  │                   │
     Orders              └──────┬────────────┘
         ↓                      ↓
     ┌────┬──────────────┬── Products
     ↓    ↓              │       ↓
Shipments  OrderItems ◄──┘   Inventory
*/
