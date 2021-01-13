-- CSC343 Group Project
-- Authors: Xinyu Kang and Yunyi Cheng

DROP SCHEMA if exists Superstore cascade;
CREATE SCHEMA Superstore;
SET SEARCH_PATH to Superstore;

-------------------------------------- Domains -----------------------------------------

CREATE DOMAIN OrderID AS TEXT
	NOT NULL
	CONSTRAINT validOrderID
		CHECK (value ~ '^[A-Z]{2}-\d{4}-\d+$');

CREATE DOMAIN CustomerID AS TEXT
	NOT NULL
	CONSTRAINT validCustomerID
		CHECK (value ~ '^[A-Z]{2}-\d{5}$');

CREATE DOMAIN ProductID AS TEXT
	NOT NULL
	CONSTRAINT validProductID
		CHECK (value ~ '\d+$');

CREATE DOMAIN ShipMode AS varchar(14)
	NOT NULL
	CONSTRAINT validShipMode
		CHECK (value IN ('Standard Class', 'Second Class', 'First Class', 'Same Day'));

CREATE DOMAIN Segment AS varchar(11)
	NOT NULL
	CONSTRAINT validSegment
		CHECK (value IN ('Consumer', 'Corporate', 'Home Office'));

CREATE DOMAIN Priority AS varchar(8)
	NOT NULL
	CONSTRAINT validPriority
		CHECK (value IN ('Low', 'Medium', 'High', 'Critical'));

CREATE DOMAIN Category AS varchar(15)
	NOT NULL
	CONSTRAINT validCategory
		CHECK (value IN ('Furniture', 'Office Supplies', 'Technology'));

CREATE DOMAIN Market AS varchar(6)
	NOT NULL
	CONSTRAINT validMarket
	CHECK (value IN ('Africa', 'APAC', 'Canada', 'EMEA', 'EU', 'LATAM', 'US'));

CREATE DOMAIN Discount AS numeric(10,2)
	DEFAULT 0
	CONSTRAINT discountInRange
		CHECK (value >= 0 and value <= 1.0);


-------------------------------------- Tables -----------------------------------------

-- A country in which the order was made.
CREATE TABLE If NOT EXISTS Country(
	-- The name of the country.
	countryName TEXT PRIMARY KEY,
	-- The market to which the country belong.
	market Market);

-- A customer who places order(s).
CREATE TABLE If NOT EXISTS Customer(
	-- The ID of the customer.
	customerID CustomerID PRIMARY KEY,
	-- The name of the customer.
	customerName TEXT NOT NULL,
	-- The segment of the customer 
	-- (whether they are personal consumers, home offices, or corporates).
	segment Segment NOT NULL);

-- A summary of an order.
CREATE TABLE If NOT EXISTS OrderSummary(
	-- The ID of the order.
	orderID OrderID PRIMARY KEY,
	-- The ID of the customer who places this order.
	customerID CustomerID NOT NULL,
	-- The date on which the order is made.
	orderDate DATE NOT NULL,
	-- The country in which the order is placed.
	country TEXT,
	-- The priority of the order 
	-- (whether it is low, medium, high, or critical)
	priority Priority,
	FOREIGN KEY (customerID) REFERENCES Customer
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (country) REFERENCES Country
		ON DELETE CASCADE ON UPDATE CASCADE);

-- A product in the superstore.
CREATE TABLE If NOT EXISTS Product(
	-- The ID of the product.
	productID ProductID primary key,
	-- The category of the product.
	category Category NOT NULL,
	-- The sub-category of the product.
	subcategory TEXT NOT NULL);

-- A record of a selling event.
CREATE TABLE If NOT EXISTS SalesRecord(
	-- The ID of the order.
	orderID OrderID,
	-- The ID of the product sold.
	productID ProductID,
	-- How much the product was sold.
	sales numeric(10,4) NOT NULL,
	-- The quantity of the product sold.
	quantity integer NOT NULL,
	-- The discount applied for this event
	discount Discount,
	-- The profit made by the superstore from this event.
	profit numeric(10,4) NOT NULL,
	PRIMARY KEY (orderID, productID),
	FOREIGN KEY (orderID) REFERENCES OrderSummary
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (productID) REFERENCES Product
		ON DELETE CASCADE ON UPDATE CASCADE);

-- A shipment of product from an order.
CREATE TABLE If NOT EXISTS Shipment(
	-- The ID of the order.
	orderID OrderID,
	-- The ID of the product.
	productID ProductID,
	-- The shipping date of the product
	shipDate DATE NOT NULL,
	-- The mode for this shipment.
	-- (whether it is standard class, second class, first class, or same day.)
	shipMode ShipMode NOT NULL,
	-- The cost of this shipment.
	shippingCost numeric(10,2),
	PRIMARY KEY (orderID, productID),
	FOREIGN KEY (orderID) REFERENCES OrderSummary
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (productID) REFERENCES Product
		ON DELETE CASCADE ON UPDATE CASCADE);




