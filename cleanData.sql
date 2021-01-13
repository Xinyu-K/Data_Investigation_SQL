SET datestyle to DMY;

CREATE TEMPORARY TABLE Data (rowID text, orderID text, orderDate date, shipDate date,
	 shipMode varchar(14), customerID text, customerName text, segment varchar(11),
	 city text, state text, country text, postal int, market varchar(6), region text,
	 productID text, category varchar(15), subcategory text, productName text,
	 sales numeric(10,4), quantity integer, discount numeric(10,2), 
	 profit numeric(10,4), shippingCost numeric(10,2), priority varchar(8));

\COPY Data FROM /Users/hellen/Desktop/superstore_dataset2011-2015.csv WITH header csv encoding 'ISO-8859-1'

DELETE FROM Data d1 
WHERE EXISTS
(
	SELECT * 
	FROM Data d2 
	WHERE d1.orderID = d2.orderID and d1.rowID != d2.rowID and
		(d1.customerID != d2.customerID or d1.productID = d2.productID
		or d1.orderDate != d2.orderDate or d1.priority != d1.priority
		or d1.orderDate != d2.orderDate)
);

DELETE FROM Data
WHERE not (customerID ~ '^[A-Z]{2}-\d{5}$');

UPDATE Data d1
SET subcategory = 'Binders'
WHERE EXISTS
(
	SELECT *
	FROM Data d2
	WHERE d1.productID = d2.productID and 
		d1.subcategory != 'Binders' and d2.subcategory = 'Binders'
);

UPDATE Data
SET market = 'EU', region = 'Central'
WHERE country = 'Austria';

UPDATE Data
SET market = 'EMEA', region = 'EMEA'
WHERE country = 'Mongolia';

\COPY Data TO /Users/hellen/Desktop/superstore.csv WITH header csv encoding 'ISO-8859-1'

DROP TABLE Data;
