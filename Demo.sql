use ACME_DB;
use ACME_DB_SQLonAir;
/******************************************************************************************
 ******************************************************************************************
 *********
 *********  ORIGINAL Data Model
 *********
 ******************************************************************************************
 ******************************************************************************************/

-- A Simple Query
SELECT * FROM ShoppingCart WHERE SubTotal < 20;

UPDATE Product set UnitPrice=50.00 WHERE Name='Product B'

SELECT * FROM [product];
SELECT * FROM [customer];
SELECT * FROM [ShoppingCart];
SELECT * FROM [CartItem];


-- FINAL PRODUCTS
SELECT Name, UnitPrice, UnitsInShoppingCarts, TotalInShoppingCarts FROM data.product ORDER BY Name;

-- FINAL CUSTOMERs
SELECT Name, PhoneNumber, EmailAddress, TaxRate, TotalSales, IsWhale FROM data.[customer]  order by Name;

-- CART ITEMs
SELECT CartNumber, CustomerName, CustomerPhoneNumber, CustomerEmailAddress,
	Quantity, ProductName, SubTotal FROM data.[CartItem] ci order by CartNumber, ProductName;

-- CARTs
SELECT CartNumber, CartDate, CustomerName, CustomerPhoneNumber, CustomerEmailAddress, 
		SubTotal, TaxRate, Tax, Total FROM data.[ShoppingCart] sc ORDER BY CartNumber


/******************************************************************************************
 ******************************************************************************************
 *********
 *********  Asking Simple Questions (List of Carts, List of Cart Items)
 *********
 ******************************************************************************************
 ******************************************************************************************/

-- Using JOIN's in SQL
WITH allcarts AS (
	SELECT top 1000 o.CartNumber, o.CartDate, c.Name, c.PhoneNumber, c.EmailAddress, sum(oli.quantity * p.UnitPrice) as SubTotal
	FROM [ShoppingCart] o 
		left join Customer c on o.Customer = c.CustomerId
		left join CartItem oli on o.ShoppingCartId = oli.ShoppingCart
		left join Product p on oli.Product = p.ProductId
	GROUP BY o.ShoppingCartId, o.CartDate, o.Customer, o.CartNumber, c.Name, c.PhoneNumber, c.EmailAddress, o.ShoppingCartId, c.CustomerId
	ORDER BY o.CartNumber
) SELECT * FROM allcarts 
WHERE SubTotal < 20

GO
THROW 51000, 'Stopping execution.  Following scripts should be run individually.', 0;

SELECT ProductId, Name, UnitPrice FROM dbo.[product] order by Name;
SELECT CustomerId, Name, PhoneNumber, emailAddress, TaxRate FROM dbo.[customer] order by Name;
SELECT ShoppingCartId, CartNumber, CartDate, Customer FROM dbo.[ShoppingCart] order by CartNumber;
SELECT ShoppingCart, Product, Quantity FROM dbo.[CartItem] order by ShoppingCart;

/******************************************************************************************
 ******************************************************************************************
 *********
 *********  DETAILED QUERIES
 *********
 ******************************************************************************************
 ******************************************************************************************/


SELECT * FROM calc.[product];
SELECT * FROM calc.[customer];
SELECT * FROM calc.[ShoppingCart];
SELECT * FROM calc.[CartItem];



SELECT * FROM data.[product];
SELECT * FROM data.[customer];
SELECT * FROM data.[ShoppingCart];
SELECT * FROM data.[CartItem];



/******************************************************************************************
 ******************************************************************************************
 *********
 *********  Asking Simple Questions (List of Carts, List of Cart Items)
 *********
 ******************************************************************************************
 ******************************************************************************************/

GO

-- Using JOIN's in SQL
WITH allcarts AS (
	SELECT top 1000 o.CartNumber, o.CartDate, c.Name, c.PhoneNumber, c.EmailAddress, sum(oli.quantity * p.UnitPrice) as SubTotal
	FROM [ShoppingCart] o 
		left join Customer c on o.Customer = c.CustomerId
		left join CartItem oli on o.ShoppingCartId = oli.ShoppingCart
		left join Product p on oli.Product = p.ProductId
	GROUP BY o.ShoppingCartId, o.CartDate, o.Customer, o.CartNumber, c.Name, c.PhoneNumber, c.EmailAddress, o.ShoppingCartId, c.CustomerId
	ORDER BY o.CartNumber
) SELECT * FROM allcarts 
WHERE SubTotal < 20

GO
THROW 51000, 'Stopping execution.  Following scripts should be run individually.', 0;

-- Same query with Sql On Air!
SELECT * FROM ShoppingCart WHERE SubTotal < 20

SELECT * FROM CartItem
UPDATE data.Product set UnitPrice=50.00 WHERE Name='Product B'
SELECT * FROM CartItem
SELECT * FROM ShoppingCart
SELECT * FROM Customer

SELECT o.CartNumber, c.Name, c.PhoneNumber, c.EmailAddress, Quantity, p.Name, p.UnitPrice, p.UnitPrice * Quantity as SubTotal
FROM CartItem oli 
JOIN [ShoppingCart] o on oli.ShoppingCart = o.ShoppingCartId
JOIN Product p on oli.Product = p.ProductId
JOIN Customer c on o.Customer = c.CustomerId
Order by CartNumber, p.Name;


-- PRODUCTs
SELECT p.Name, p.UnitPrice--, p.TotalInShoppingCarts, p.UnitsInShoppingCarts  
FROM dbo.[product] p order by Name;

-- CUSTOMERs
SELECT c.Name, c.PhoneNumber, c.EmailAddress, c.TaxRate --, c.TotalSales 
FROM dbo.[customer] as c order by Name;

-- CART ITEMs
SELECT CartNumber, CustomerName, CustomerPhoneNumber, CustomerEmailAddress, ProductName, 
	Quantity, SubTotal FROM dbo.[CartItem] ci order by ShoppingCart;

-- CARTs
SELECT CartNumber, CartDate, CustomerName, CustomerPhoneNumber, CustomerEmailAddress, SubTotal, TaxRate, Tax, Total FROM 
dbo.[ShoppingCart] sc 
   WHERE SubTotal < 20
   ORDER BY CartNumber;



/******************************************************************************************
 ******************************************************************************************
 *********
 *********  Asking Questions of SQL On Air
 *********
 ******************************************************************************************
 ******************************************************************************************/



SELECT CustomerId, Name, PhoneNumber, TaxRate, TotalSales FROM data.[customer] WHERE EmailAddress='ej@ssot.me';
SELECT ShoppingCartId, CustomerName, CustomerPhoneNumber, TaxRate, SubTotal, Tax, Total FROM data.[ShoppingCart] WHERE CustomerEmailAddress = 'Ej@ssot.me';

update data.customer set Name='EJ (changed)',PhoneNumber='555-CHA-NGED', TaxRate=.5 WHERE EmailAddress='ej@ssot.me'

SELECT CustomerId, Name, PhoneNumber, TaxRate, TotalSales FROM data.[customer] WHERE EmailAddress='ej@ssot.me';
SELECT ShoppingCartId, CustomerName, CustomerPhoneNumber, TaxRate, SubTotal, Tax, Total FROM data.[ShoppingCart] WHERE CustomerEmailAddress = 'Ej@ssot.me';

SELECT Name, UnitsInShoppingCarts, UnitPrice, TotalInShoppingCarts FROM data.[product] WHERE Name='Product A';
UPDATE data.Product set UnitPrice=2.00 WHERE Name='Product A'
SELECT Name, UnitsInShoppingCarts, UnitPrice, TotalInShoppingCarts FROM data.[product] WHERE Name='Product A';

update data.product set name = replace( name, ' changed', '')
