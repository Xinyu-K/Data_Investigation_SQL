SET datestyle to DMY;

CREATE TEMPORARY TABLE Data (rowID text, orderID text, orderDate date, shipDate date,
	 shipMode varchar(14), customerID text, customerName text, segment varchar(11),
	 city text, state text, country text, postal int, market varchar(6), region text,
	 productID text, category varchar(15), subcategory text, productName text,
	 sales numeric(10,4), quantity integer, discount numeric(10,2), 
	 profit numeric(10,4), shippingCost numeric(10,2), priority varchar(8));

\COPY Data FROM /Users/hellen/Desktop/superstore.csv WITH header csv encoding 'ISO-8859-1'


INSERT INTO Country
(
	SELECT DISTINCT country, market
	FROM Data
);

INSERT INTO Customer
(
	SELECT DISTINCT customerID, customerName, segment
	FROM Data
);

INSERT INTO OrderSummary
(
	SELECT DISTINCT orderID, customerID, orderDate, country, priority
	FROM Data
);

INSERT INTO Product
(
	SELECT DISTINCT productID, category, subcategory
	FROM Data
);


INSERT INTO SalesRecord
(
	SELECT DISTINCT orderID, productID, sales, quantity, discount, profit
	FROM Data
);

INSERT INTO Shipment
(
	SELECT DISTINCT orderID, productID, shipDate, shipMode, shippingCost
	From Data
);

DROP TABLE Data;






