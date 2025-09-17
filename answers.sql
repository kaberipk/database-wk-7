use salesdb;

-- First, create the denormalized table for practice
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Insert the sample data from your assignment
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Verify the data
SELECT * FROM ProductDetail;

-- Transform to 1NF using UNION ALL
SELECT OrderID, CustomerName, 'Laptop' AS Product 
FROM ProductDetail 
WHERE OrderID = 101
UNION ALL
SELECT OrderID, CustomerName, 'Mouse' AS Product 
FROM ProductDetail 
WHERE OrderID = 101
UNION ALL
SELECT OrderID, CustomerName, 'Tablet' AS Product 
FROM ProductDetail 
WHERE OrderID = 102
UNION ALL
SELECT OrderID, CustomerName, 'Keyboard' AS Product 
FROM ProductDetail 
WHERE OrderID = 102
UNION ALL
SELECT OrderID, CustomerName, 'Mouse' AS Product 
FROM ProductDetail 
WHERE OrderID = 102
UNION ALL
SELECT OrderID, CustomerName, 'Phone' AS Product 
FROM ProductDetail 
WHERE OrderID = 103
ORDER BY OrderID, Product;

-- Table for order-level information (removes partial dependency)
CREATE TABLE Orders_2nf (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL
);

-- Table for product-level information 
CREATE TABLE Order_Details (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Drop tables if they exist (start fresh)
DROP TABLE IF EXISTS Order_Details_2NF;
DROP TABLE IF EXISTS Orders_2NF;

-- Create the original OrderDetails table
CREATE TABLE Order_Detail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product)
);

-- Insert the provided data
INSERT INTO Order_Detail (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Create Orders table for 2NF (CustomerName depends on OrderID)
CREATE TABLE Order2NF (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Create OrderItems table for 2NF (Product and Quantity depend on OrderID, Product)
CREATE TABLE Order_Item (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product)
);

-- Populate Orders table (unique OrderID and CustomerName)
INSERT INTO Order2NF (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM Order_Detail;

-- Populate OrderItems table (OrderID, Product, Quantity)
INSERT INTO OrderItem (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM Order_Detail;

-- View the 2NF tables
SELECT * FROM Orders2NF;
SELECT * FROM OrderItem;
