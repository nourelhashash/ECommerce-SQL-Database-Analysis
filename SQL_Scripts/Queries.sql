USE ECommerce;

-- Show all orders for 'Hashash' including date, status, and total cost
-- Joins Customers, Orders, and OrderItems and calculates total per order
SELECT c.CustomerName, o.OrderID, o.OrderDate, o.Status, SUM(oi.Quantity * oi.PriceAtTimeOfOrder) AS TotalOrderCost
FROM Customers c, Orders o, OrderItems oi
WHERE  c.CustomerID = o.CustomerID and o.OrderID = oi.OrderID
	   and c.CustomerName = 'Hashash'
GROUP BY c.CustomerName, o.OrderID, o.OrderDate, o.Status
ORDER BY o.OrderDate DESC;

-- Get top 3 best-selling products by quantity
-- Joins Products and OrderItems, sums quantity, orders descending, limits to top 3
SELECT TOP(3) p.ProductID, p.ProductName, SUM(oi.Quantity) AS TotalUnitsSold
FROM Products p
JOIN OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalUnitsSold DESC;

-- List products with stock quantity less than 10
-- Joins Products and Inventory, filters by StockQuantity < 10
SELECT p.ProductID, p.ProductName, i.StockQuantity
FROM Products p
JOIN Inventory i ON p.ProductID = i.ProductID
WHERE i.StockQuantity < 10

-- List orders that are not shipped yet
-- Uses LEFT JOIN between Orders and Shipments, filters NULL shipment and unshipped status
SELECT o.OrderID, o.OrderDate, o.Status
FROM Orders o
LEFT JOIN Shipments s ON o.OrderID = s.OrderID
WHERE s.ShipmentID IS NULL AND o.Status IN('Pending', 'Processing')

-- Calculate total revenue per product category
-- Joins Categories, Products, OrderItems; multiplies quantity by price at time of order
SELECT c.CategoryName, SUM(oi.PriceAtTimeOfOrder * oi.Quantity) AS TOTALREVENUEPERCATEGORY 
FROM Products p, OrderItems oi, Categories c
WHERE p.ProductID = oi.ProductID AND p.CategoryID = c.CategoryID
GROUP BY c.CategoryName

-- Find customers registered more than 6 months ago who didn’t order in the last 6 months
-- Uses NOT EXISTS to check for no recent orders
SELECT c.CustomerID, c.CustomerName
FROM Customers c
WHERE c.RegistrationDate < DATEADD(MONTH, -6, GETDATE())
	AND NOT EXISTS(
		SELECT 1
		FROM Orders o
		WHERE c.CustomerID = o.CustomerID
			AND o.OrderDate >= DATEADD(MONTH, -6, GETDATE())
		)

-- Mark order 70 as delivered
-- Simple update on Orders table
UPDATE Orders
SET Status = 'Delivered'
WHERE OrderID = 70

-- Simulate product purchase: decrease stock of ProductID 5 by 2
-- Updates Inventory table
UPDATE Inventory
SET StockQuantity = StockQuantity - 2
WHERE ProductID = 5


-- Show all products supplied by 'Tech Vision Ltd'
-- Joins Products and Suppliers and filters by supplier name
SELECT p.ProductName, s.SupplierName
FROM Products p, Suppliers s
WHERE p.SupplierID = s.SupplierID
	AND s.SupplierName = 'Tech Vision Ltd'


-- Delete all cancelled orders and related order items
-- First deletes from OrderItems, then from Orders
DELETE FROM OrderItems 
WHERE OrderID IN(
	SELECT OrderID FROM Orders WHERE Status='Cancelled'
)

DELETE FROM Orders WHERE Status='Cancelled'