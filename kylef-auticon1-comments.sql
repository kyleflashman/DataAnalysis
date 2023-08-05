/*
auticon SQL training -- solutions template (for curriculum v3.1, jmj 220104)

for problems from

    SQL Practice Problems
and More SQL Practice Problems

 by Sylvia Moestl Vasilik

INSTRUCTIONS

Save this file with a name like "FirstName LastName Solutions.sql"
(replacing "FirstName LastName" with your own name), and record your
solutions in here.

Before starting, record your name here, and the date when you began work on
the SQL course:

             Name: Kyle Flashman
Date/time started: 4/13/2022

Below, the file is divided into weeks, and each week is divided into
problems.  Please put your solution to each problem underneath the comment
that lists the problem number. We've included templates for the first
problems (#3-4) so you can see how we want them placed between the comments.

Note that all problem numbers from "More SQL Practice Problems" are prefixed
with "m", e.g., "m40", in this file. This is so we know at a glance which
problem you're solving. Please use this convention when asking for help.

Please leave all of our divider comments and USE statements intact and
unchanged. You're welcome to insert comments of your own in between, as long
as they aren't likely to be confused with our dividers.

Enjoy the course, and let us know if you have questions!
*/

/* COMMENTS from Jordan
 * Answers matched key perfectly on 44 problems and up-to-permutation on 6
 * more. Comments are tagged with "XXX" below. A few problems are tagged
 * with "FIXME", and it would be a good idea to go back and fix those.
 */


/**************************************************** MODULE 1 *******/
SELECT @@GLOBAL.sql_mode;
SELECT @@SESSION.sql_mode;
SET SESSION sql_mode = sys.list_add(@@session.sql_mode, 'ONLY_FULL_GROUP_BY');
USE `auticon_sql_problems`;

-- -- 1. Which shippers do we have? -- --
SELECT *
FROM shippers;

-- -- 2. Certain fields from categories -- --
SELECT CategoryName, Description
FROM categories;

-- -- 3. Sales Representatives -- --
SELECT FirstName, LastName, HireDate
FROM employees
WHERE Title = 'Sales Representative';
-- -- 4. Sales Representatives in the United States -- --
SELECT FirstName, LastName, HireDate
FROM employees
WHERE Title = 'Sales Representative' AND Country = 'USA';
-- -- 5. Orders placed by specific EmployeeID -- --
SELECT OrderID, OrderDate
FROM orders
WHERE EmployeeID = 5;
-- -- 6. Suppliers and ContactTitles -- --
SELECT SupplierID, ContactName, ContactTitle
FROM Suppliers
WHERE NOT ContactTitle = 'Marketing Manager';
-- -- 8. Orders shipping to France or Belgium -- --
SELECT OrderID, CustomerID, ShipCountry
FROM Orders
WHERE ShipCountry = 'France' OR ShipCountry = 'Belgium';
-- -- 9. Orders shipping to any country in Latin America -- --
SELECT OrderID, CustomerID, ShipCountry
FROM Orders
WHERE ShipCountry IN ('Brazil', 'Mexico', 'Argentina', 'Venezuela');
-- -- 7. Products with "queso" in ProductName -- --
Select ProductID, ProductName
FROM products
WHERE ProductName LIKE "%Queso%";
-- -- 10. Employees, in order of age -- --
SELECT FirstName, LastName, Title, BirthDate
FROM Employees
ORDER BY BirthDate;
-- -- 13. OrderDetails amount per line item -- --
SELECT OrderID, ProductID, UnitPrice, Quantity, UnitPrice*Quantity AS TotalPrice
FROM OrderDetails
ORDER BY OrderID, ProductID;
-- -- 11. Showing only the Date with a DateTime field -- --
SELECT FirstName, LastName, Title, DATE(BirthDate) AS DateOnlyBirthDate
FROM Employees
ORDER BY BirthDate;
-- -- 12. Employees full name -- --
SELECT FirstName, LastName, CONCAT(FirstName, ' ', LastName) AS FullName
FROM Employees;
-- -- 14. How many customers? -- --
SELECT COUNT(CustomerID) AS TotalCustomers
FROM Customers;
-- -- 15. When was the first order? -- --
SELECT MIN(OrderDate) AS FirstOrder
FROM orders;
-- -- 16. Countries where there are customers -- --
SELECT DISTINCT Country
FROM Customers
ORDER BY Country;
-- -- 17. Contact titles for customers -- --
SELECT ContactTitle, COUNT(ContactTitle) AS TotalContactTitle
FROM Customers
GROUP BY ContactTitle
ORDER BY TotalContactTitle DESC, ContactTitle;
-- -- 21. Total customers per country/city -- --
SELECT Country, City, COUNT(City) AS TotalCustomers
FROM Customers
GROUP BY Country, City
ORDER BY TotalCustomers DESC;
-- -- 22. Products that need reordering -- --
SELECT ProductID, ProductName, UnitsInStock, ReorderLevel
FROM products
WHERE UnitsInStock < ReorderLevel
ORDER BY ProductID;
-- -- 23. Products that need reordering, continued -- --
SELECT ProductID, ProductName, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
FROM products
WHERE UnitsInStock + UnitsOnOrder <= ReorderLevel AND Discontinued = 0;
-- -- 24. Customer list by region -- --
SELECT CustomerID, CompanyName, Region
FROM customers
ORDER BY 
CASE WHEN Region IS NULL THEN 1 ELSE 0 END,
Region, CustomerID; 
-- -- 36. Orders with many line items -- --
SELECT OrderID, COUNT(Quantity) AS TotalOrderDetails
FROM orderdetails
GROUP BY OrderID
ORDER BY TotalOrderDetails DESC
LIMIT 10;
-- -- 25. High freight charges -- --
SELECT ShipCountry, AVG(Freight) AS AverageFreight
FROM orders
GROUP BY ShipCountry
ORDER BY AverageFreight DESC
LIMIT 3;
-- -- 26. High freight charges—2015 -- --
SELECT ShipCountry, AVG(Freight) AS AverageFreight
FROM orders
WHERE YEAR(OrderDate) = 2015
GROUP BY ShipCountry
ORDER BY AverageFreight DESC
LIMIT 3;
-- -- 27. High freight charges with BETWEEN -- --
Select
	ShipCountry
	,freight
    ,OrderDate
    ,OrderID
From Orders
Where
OrderDate between '2015-01-01' and '2015-12-31'
AND ShipCountry IN ('Sweden', 'France')
Order By freight desc;
-- Insert your answer in a comment here, telling us WHICH order,
-- WHEN, and for HOW MUCH freight:
/* OrderID = 10806
When = 2015-12-31 11:00:00
Freight = 2000 */
-- -- 35. Month-end orders -- --
SELECT EmployeeID, OrderID, OrderDate
FROM orders
WHERE DATE(OrderDate) = LAST_DAY(OrderDate)
ORDER BY EmployeeID, OrderID;
-- -- 41. Late orders -- --
SELECT OrderID, OrderDate, RequiredDate, ShippedDate
FROM orders
WHERE RequiredDate <= ShippedDate
ORDER BY OrderID;

USE auticon_more_sql_problems;

-- -- m1. Cost changes for each product -- --
SELECT ProductID, COUNT(ProductID)
FROM productcosthistory
GROUP BY ProductID
ORDER BY ProductID;
-- -- m2. Customers with total orders placed -- --
SELECT CustomerID, COUNT(CustomerID) AS TotalOrders
FROM salesorderheader
GROUP BY CustomerID
ORDER BY TotalOrders DESC, CustomerID;
-- -- m5. Product cost on a specific date -- --
SELECT ProductID, StandardCost
FROM 
	(SELECT 
    ProductID, MIN(EndDate) AS EndDate
    FROM productcosthistory
	WHERE Date(EndDate) >= 2012-04-15 OR Date(ModifiedDate) >= 2012-04-15
	GROUP BY ProductID) minDate
INNER JOIN 
	productcosthistory pch
USING (ProductID, EndDate);

-- -- m6. Product cost on a specific date, part 2 -- --
SELECT ProductID, StandardCost
FROM productcosthistory
WHERE '2014-04-15' <= IFNULL(EndDate, DATE('2022-04-15'))
ORDER BY ProductID;
-- -- m7. Product List Price: how many price changes? -- --
SELECT
	DATE_FORMAT(StartDate, '%Y/%m') AS ProductListPriceMonth,
	COUNT(ProductID)
FROM ProductListPriceHistory
GROUP BY ProductListPriceMonth;
-- -- m9. Current list price of every product -- --
SELECT ProductID, ListPrice
FROM productlistpricehistory
WHERE EndDate IS NULL
ORDER BY ProductID;
/**************************************************** MODULE 2 *******/
USE auticon_sql_problems;
-- -- 18. Products with associated supplier names -- --
SELECT p.ProductID, p.ProductName, s.CompanyName AS Supplier
FROM Products p
JOIN Suppliers s 
ON s.SupplierID = p.SupplierID
ORDER BY p.ProductID;
-- -- 19. Orders and the Shipper that was used -- --
SELECT o.OrderID, Date(o.OrderDate) AS OrderDate, s.CompanyName as Shipper
FROM orders o
JOIN shippers s 
ON s.ShipperID = o.ShipVia
WHERE o.OrderID < 10270
ORDER BY o.OrderID;
-- -- 20. Categories, and the total products in each category -- --
SELECT c.CategoryName AS CategoryName, Count(p.ProductName) AS TotalProducts
FROM categories c 
JOIN products p 
ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID
ORDER BY TotalProducts DESC;
-- -- 42. Late orders -- which employees? -- --
SELECT e.EmployeeID, e.LastName, COUNT(o.OrderID) AS TotalLateOrders
FROM employees e
JOIN orders o 
ON e.EmployeeID = o.EmployeeID
WHERE o.RequiredDate <= o.ShippedDate
GROUP BY o.EmployeeID
ORDER BY TotalLateOrders DESC;

USE auticon_more_sql_problems;

-- -- m3. Products with first and last order date -- --
SELECT sod.ProductID, MIN(OrderDate), MAX(OrderDate) 
FROM salesorderdetail sod
JOIN salesorderheader soh
ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY sod.ProductID
ORDER BY sod.ProductID;

USE auticon_sql_problems;

-- -- 28. High freight charges -- last year -- --
SELECT ShipCountry, AVG(Freight) AS AverageFreight
FROM Orders
WHERE OrderDate > DATE_ADD((SELECT MAX(OrderDate) FROM Orders), Interval - 1 year)
GROUP BY ShipCountry
ORDER BY AverageFreight DESC
LIMIT 3;

USE auticon_more_sql_problems;

-- -- m10. Products without a list price history -- --
SELECT ProductID, ProductName
FROM Product
WHERE ListPrice = 0;

USE auticon_sql_problems;

-- -- 56. Customers with multiple orders in 5 day period -- --
SELECT io.CustomerID AS CustomerID, io.OrderID AS InitialOrderID, 
io.OrderDate AS InitialOrderDate,
no.OrderID AS NextOrderID,
no.OrderDate AS NextOrderDate,
ABS(DATEDIFF(io.OrderDate, no.OrderDate)) AS DaysBetweenOrders
FROM orders io
JOIN orders no
ON io.CustomerID = no.CustomerID
WHERE io.OrderDate < no.OrderDate
AND ABS(DATEDIFF(io.OrderDate, no.OrderDate)) < 6
ORDER BY io.CustomerID, io.OrderDate;

-- -- 29. Employee/Order Detail report -- --
SELECT e.EmployeeID, e.LastName, o.OrderID, p.ProductName, od.Quantity
FROM employees e
JOIN orders o
ON e.EmployeeID = o.EmployeeID
JOIN orderdetails od
ON o.OrderID = od.OrderID
JOIN products p
ON od.ProductID = p.ProductID
ORDER BY od.OrderID, od.ProductID;

USE auticon_more_sql_problems;

-- -- m4. Products with first and last order date, including name -- --
SELECT p.ProductID, p.ProductName, 
MIN(soh.OrderDate) AS FirstOrder, MAX(soh.OrderDate) AS LastOrder
FROM product p
JOIN salesorderdetail sod
ON p.ProductID = sod.ProductID
JOIN salesorderheader soh
ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY p.ProductID
ORDER BY p.ProductID;

-- -- m15. Orders for products that were unavailable -- --
SELECT p.ProductID, DATE(soh.OrderDate) AS OrderDate, 
	p.ProductName, SUM(sod.OrderQty) AS Qty,
	Date(SellStartDate) AS SellStartDate, Date(SellEndDate) AS SellEndDate
FROM product p
JOIN salesorderdetail sod
ON p.ProductID = sod.ProductID
JOIN salesorderheader soh
ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY ProductID, sod.SalesOrderID
HAVING OrderDate < SellStartDate OR OrderDate > SellEndDate
ORDER BY ProductID, OrderDate;

-- m16. Orders for products that were unavailable: details -- --
SELECT p.ProductID, DATE(soh.OrderDate) AS OrderDate, 
p.ProductName, SUM(sod.OrderQty) AS Qty,
Date(SellStartDate) AS SellStartDate, Date(SellEndDate) AS SellEndDate,
CASE WHEN OrderDate < SellStartDate THEN 'Sold before start date'
WHEN OrderDate > SellEndDate THEN 'Sold after end date'
END AS ProblemType
FROM product p
JOIN salesorderdetail sod
ON p.ProductID = sod.ProductID
JOIN salesorderheader soh
ON sod.SalesOrderID = soh.SalesOrderID
WHERE OrderDate < SellStartDate OR OrderDate > SellEndDate
GROUP BY ProductID, sod.SalesOrderID
ORDER BY ProductID, OrderDate;

-- -- m21. Fix this SQL! Number 2 -- --
Select 
	Customer.CustomerID
	,CONCAT(Customer.FirstName, ' ', Customer.LastName) as CustomerName
	,OrderDate
	,SalesOrderHeader.SalesOrderID
	,SalesOrderDetail.ProductID
	,Product.ProductName
	,LineTotal
From SalesOrderDetail
Join Product
on Product.ProductID = SalesOrderDetail.ProductID
Join SalesOrderHeader
on SalesOrderHeader .SalesOrderID = SalesOrderDetail.SalesOrderID
Join Customer
on Customer.CustomerID = SalesOrderHeader.CustomerID
Order by
CustomerID
,OrderDate
Limit 100;
-- -- m14. Products with list price discrepancies -- --
SELECT p.ProductID AS ProductID, 
	p.ProductName AS ProductName, 
	p.ListPrice AS Prod_ListPrice,
	plph.ListPrice AS PriceHist_LatestListPrice,
	p.ListPrice - plph.ListPrice AS Diff
FROM product p
JOIN productlistpricehistory plph
ON p.ProductID = plph.ProductID
WHERE plph.EndDate IS NULL
AND p.ListPrice != plph.ListPrice
ORDER BY ProductID;

USE auticon_sql_problems;

-- -- 31. Customers with no orders for EmployeeID 4 -- --
SELECT CustomerID
FROM customers
WHERE CustomerID NOT IN (SELECT CustomerID
						FROM orders
						WHERE EmployeeID = 4);

USE auticon_more_sql_problems;

-- -- m8. Product List Price: months with no price changes? -- --
SELECT c.CalendarMonth AS CalendarMonth, COUNT(p.ProductID) AS TotalRows
FROM calendar c
LEFT JOIN productlistpricehistory p
ON DATE(c.CalendarDate) = DATE(p.StartDate)
WHERE c.calendarDate >= (SELECT MIN(StartDate) FROM productlistpricehistory)
AND c.calendarDate <= (SELECT MAX(StartDate) FROM productlistpricehistory)
GROUP BY c.CalendarMonth;
-- -- m10. Products without a list price history -- --
SELECT p.ProductID AS ProductID, p.ProductName AS ProductName
FROM product p
LEFT JOIN productlistpricehistory plph
ON p.ProductID = plph.ProductID
WHERE plph.ListPrice IS NULL
ORDER BY p.ProductID;

-- -- m13. Products with first and last order date, incl name and subcat -- --
SELECT p.ProductID AS ProductID, p.ProductName, sc.ProductSubCategoryName, 
MIN(DATE(soh.OrderDate)) AS FirstOrder, MAX(DATE(soh.OrderDate)) AS LastOrder
FROM product p
LEFT JOIN salesorderdetail sod
ON p.ProductID = sod.ProductID
LEFT JOIN salesorderheader soh
ON sod.SalesOrderID = soh.SalesOrderID
LEFT JOIN productsubcategory sc
ON p.ProductSubcategoryID = sc.ProductSubcategoryID
GROUP BY p.ProductID
ORDER BY p.ProductName;

-- -- m18. Fix this SQL! Number 1 -- --
-- Explain in a comment, below, what the problem is with the given query:
/*
 * Color should not be in quotes
 */

USE auticon_sql_problems;

-- -- 30. Customers with no orders -- --
SELECT c.CustomerID AS CustomersCustomerID, o.CustomerID AS OrdersCustomerID
FROM customers c
LEFT JOIN orders o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;

-- -- 32. High-value customers -- --
SELECT c.CustomerID, c.CompanyName, o.OrderID, 
SUM(od.UnitPrice*od.Quantity) AS TotalOrderAmount
FROM customers c
JOIN orders o
ON c.CustomerID = o.CustomerID
JOIN orderdetails od
ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 2016 
GROUP BY o.OrderID
HAVING SUM(od.UnitPrice*od.Quantity) > 10000
ORDER BY TotalOrderAmount DESC;

-- -- 33. High-value customers—total orders -- --
SELECT c.CustomerID, c.CompanyName, 
SUM(od.UnitPrice*od.Quantity) AS TotalOrderAmount
FROM customers c
JOIN orders o
ON c.CustomerID = o.CustomerID
JOIN orderdetails od
ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 2016 
GROUP BY c.CustomerID
HAVING SUM(od.UnitPrice*od.Quantity) > 15000
ORDER BY TotalOrderAmount DESC;

-- -- 38. Orders -- accidental double-entry -- --
SELECT OrderID
FROM orderdetails
GROUP BY OrderID, Quantity
HAVING Quantity > 59 AND COUNT(OrderID) > 1
ORDER BY OrderID;

-- -- 39. Orders -- accidental double-entry details -- --
SELECT *
FROM orderdetails
WHERE OrderID IN (SELECT OrderID
FROM orderdetails
GROUP BY OrderID, Quantity
HAVING Quantity > 59 AND COUNT(OrderID) > 1
ORDER BY OrderID);

-- -- 40. Orders -- accidental double-entry details, derived table -- --
Select
OrderDetails.OrderID
,ProductID
,UnitPrice
,Quantity
,Discount
FROM OrderDetails
JOIN (
Select Distinct(OrderID)
From OrderDetails
Where Quantity >= 60
Group By OrderID, Quantity
Having Count(*) > 1
) PotentialProblemOrders
USING (OrderID)
Order by OrderID, Quantity;

USE auticon_more_sql_problems;

-- -- m12. Products with multiple current list price records -- --
SELECT ProductID
FROM ProductListPriceHistory
WHERE EndDate IS NULL
GROUP BY ProductID
HAVING COUNT(ProductID) > 1
ORDER BY ProductID;

USE auticon_sql_problems;

-- -- 20. Categories, and the total products in each category -- --
SELECT cat.CategoryName, COUNT(p.ProductID) AS TotalProducts
FROM categories cat
JOIN products p 
ON cat.CategoryID = p.CategoryID
GROUP BY cat.CategoryID
ORDER BY TotalProducts DESC;

-- -- 22. Products that need reordering -- --
SELECT ProductID, ProductName, UnitsInStock, ReorderLevel
FROM products
WHERE UnitsInStock <= ReorderLevel
ORDER BY ProductID;

-- -- 52. Countries with suppliers or customers -- --
SELECT Country FROM Customers
UNION
SELECT Country FROM Suppliers
ORDER BY Country;

-- -- Curriculum spreadsheet row 90, SQL cloning a table from the DB -- --
CREATE TABLE shippers_clone (
    `ShipperID` int NOT NULL auto_increment,
    `CompanyName` varchar(40),
    `Phone` varchar(24),
    PRIMARY KEY (`ShipperID`)
    );

INSERT INTO shippers_clone (ShipperID,
    CompanyName,
    Phone)
    
    SELECT ShipperID, CompanyName, Phone
    FROM shippers;

DROP TABLE shippers_clone;
/* Mosh's method does not copy the characteristics of each variable
into the new table (such as primary key and auto increment) */

-- -- 35. redux: Month-end orders -- --
SELECT EmployeeID, OrderID, OrderDate
FROM orders
WHERE DATE(OrderDate) = LAST_DAY(OrderDate)
ORDER BY EmployeeID, OrderID;
-- -- 37. Orders -- Random assortment -- --
SELECT OrderID
FROM orders
ORDER BY RAND()
LIMIT 10;
/**************************************************** MODULE 3 *******/

-- -- 43. Late orders vs total orders -- --
WITH emporders AS (
    SELECT e.EmployeeID, e.LastName, COUNT(OrderID) AS LateOrders
    FROM employees e
    JOIN orders o
    USING (EmployeeID)
    WHERE o.RequiredDate <= o.ShippedDate
    GROUP BY EmployeeID
    )
SELECT EmployeeID, LastName, COUNT(o2.OrderID) AS AllOrders, LateOrders
FROM emporders
JOIN orders o2
USING(EmployeeID)
GROUP BY EmployeeID
ORDER BY EmployeeID;

-- -- 44. Late orders vs total orders -- missing employee -- --
WITH emplate AS (
    SELECT e.EmployeeID, COUNT(OrderID) AS LateOrders
    FROM employees e
    JOIN orders o
    ON e.EmployeeID = o.EmployeeID
    WHERE o.RequiredDate <= o.ShippedDate
    GROUP BY EmployeeID
    ), emporder AS (
    SELECT e2.EmployeeID, e2.LastName, COUNT(o2.OrderID) AS TotalOrders
    FROM employees e2
    JOIN orders o2
    ON e2.EmployeeID = o2.EmployeeID
    GROUP BY o2.EmployeeID
    )
SELECT eo.EmployeeID, eo.LastName, eo.TotalOrders, el.LateOrders
FROM emporder eo
LEFT JOIN emplate el
ON eo.EmployeeID = el.EmployeeID
ORDER BY EmployeeID;

-- -- 45. Late orders vs total orders -- fix null -- --
WITH emplate AS (
    SELECT e.EmployeeID, COUNT(OrderID) AS LateOrders
    FROM employees e
    JOIN orders o
    ON e.EmployeeID = o.EmployeeID
    WHERE o.RequiredDate <= o.ShippedDate
    GROUP BY EmployeeID
    ), emporder AS (
    SELECT e2.EmployeeID, e2.LastName, COUNT(o2.OrderID) AS TotalOrders
    FROM employees e2
    JOIN orders o2
    ON e2.EmployeeID = o2.EmployeeID
    GROUP BY o2.EmployeeID
    )
SELECT eo.EmployeeID, eo.LastName, eo.TotalOrders, 
IFNULL(el.LateOrders, 0) AS LateOrders
FROM emporder eo
LEFT JOIN emplate el
ON eo.EmployeeID = el.EmployeeID
ORDER BY EmployeeID;

-- -- 46. Late vs total -- percentage -- --
WITH emplate AS (
    SELECT e.EmployeeID, COUNT(OrderID) AS LateOrders
    FROM employees e
    JOIN orders o
    ON e.EmployeeID = o.EmployeeID
    WHERE o.RequiredDate <= o.ShippedDate
    GROUP BY EmployeeID
    ), emporder AS (
    SELECT e2.EmployeeID, e2.LastName, COUNT(o2.OrderID) AS TotalOrders
    FROM employees e2
    JOIN orders o2
    ON e2.EmployeeID = o2.EmployeeID
    GROUP BY o2.EmployeeID
    )
SELECT eo.EmployeeID, eo.LastName, eo.TotalOrders, 
IFNULL(el.LateOrders, 0) AS LateOrders, 
IFNULL(LateOrders/TotalOrders, 0) AS PercentLateOrders
FROM emporder eo
LEFT JOIN emplate el
ON eo.EmployeeID = el.EmployeeID
ORDER BY EmployeeID;

-- -- 47. Late vs total -- fix decimal -- --
WITH emplate AS (
    SELECT e.EmployeeID, COUNT(OrderID) AS LateOrders
    FROM employees e
    JOIN orders o
    ON e.EmployeeID = o.EmployeeID
    WHERE o.RequiredDate <= o.ShippedDate
    GROUP BY EmployeeID
    ), emporder AS (
    SELECT e2.EmployeeID, e2.LastName, COUNT(o2.OrderID) AS TotalOrders
    FROM employees e2
    JOIN orders o2
    ON e2.EmployeeID = o2.EmployeeID
    GROUP BY o2.EmployeeID
    )
SELECT eo.EmployeeID, eo.LastName, eo.TotalOrders, 
IFNULL(el.LateOrders, 0) AS LateOrders, 
IFNULL(ROUND(LateOrders/TotalOrders,2), 0) AS PercentLateOrders
FROM emporder eo
LEFT JOIN emplate el
ON eo.EmployeeID = el.EmployeeID
ORDER BY EmployeeID;

-- -- 48. Customer grouping -- --
WITH total AS (
	SELECT c.CustomerID, c.CompanyName, 
	SUM(od.UnitPrice*od.Quantity) AS TotalOrderAmount
	FROM customers c
	JOIN orders o
	ON c.CustomerID = o.CustomerID
	JOIN orderdetails od
	ON o.OrderID = od.OrderID
	WHERE YEAR(o.OrderDate) = 2016 
	GROUP BY c.CustomerID
	)
SELECT CustomerID, CompanyName, TotalOrderAmount,
    CASE
        WHEN TotalOrderAmount < 1000 THEN 'Low'
        WHEN TotalOrderAmount >= 1000 AND TotalOrderAmount < 5000 THEN 'Medium'
        WHEN TotalOrderAmount >= 5000 AND TotalOrderAmount < 10000 THEN 'High'
        ELSE 'Very High'
    END AS CustomerGroup
FROM total
ORDER BY CustomerID;

-- -- 49. Customer grouping -- fix null -- --
WITH total AS (
	SELECT c.CustomerID, c.CompanyName, 
	SUM(od.UnitPrice*od.Quantity) AS TotalOrderAmount
	FROM customers c
	JOIN orders o
	ON c.CustomerID = o.CustomerID
	JOIN orderdetails od
	ON o.OrderID = od.OrderID
	WHERE YEAR(o.OrderDate) = 2016 
	GROUP BY c.CustomerID
)
SELECT CustomerID, CompanyName, TotalOrderAmount,
    CASE
        WHEN TotalOrderAmount < 1000 THEN 'Low'
        WHEN TotalOrderAmount >= 1000 AND TotalOrderAmount < 5000 THEN 'Medium'
        WHEN TotalOrderAmount >= 5000 AND TotalOrderAmount < 10000 THEN 'High'
        ELSE 'Very High'
    END AS CustomerGroup
FROM total
ORDER BY CustomerID;
-- -- 50. Customer grouping with percentage -- --
WITH total AS (
	SELECT c.CustomerID, c.CompanyName,
	SUM(od.UnitPrice*od.Quantity) AS TotalOrderAmount
	FROM customers c
	JOIN orders o
	ON c.CustomerID = o.CustomerID
	JOIN orderdetails od
	ON o.OrderID = od.OrderID	
	WHERE YEAR(o.OrderDate) = 2016 
	GROUP BY c.CustomerID
)
SELECT CustomerGroup, COUNT(*) AS TotalInGroup,
COUNT(*)/(SELECT COUNT(*) FROM total) AS PercentageInGroup
FROM (SELECT CustomerID, TotalOrderAmount,
    CASE
        WHEN TotalOrderAmount < 1000 THEN 'Low'
        WHEN TotalOrderAmount >= 1000 AND TotalOrderAmount < 5000 THEN 'Medium'
        WHEN TotalOrderAmount >= 5000 AND TotalOrderAmount < 10000 THEN 'High'
        ELSE 'Very High'
    END AS CustomerGroup
    FROM total) AS totalgroups
GROUP BY CustomerGroup
ORDER BY TotalInGroup DESC;

-- -- 51. Customer grouping -- flexible -- --
WITH total AS (
	SELECT c.CustomerID, c.CompanyName,
	SUM(od.UnitPrice*od.Quantity) AS TotalOrderAmount
	FROM customers c
	JOIN orders o
	ON c.CustomerID = o.CustomerID
	JOIN orderdetails od
	ON o.OrderID = od.OrderID
	WHERE YEAR(o.OrderDate) = 2016 
	GROUP BY c.CustomerID
)
SELECT total.CustomerID, total.CompanyName, total.TotalOrderAmount,
cgt.CustomerGroupName
FROM total
JOIN customergroupthresholds cgt
ON TotalOrderAmount BETWEEN cgt.RangeBottom AND cgt.RangeTop
ORDER BY CustomerID;

-- -- 53. Countries with suppliers or customers, v2 -- --
WITH AllCountries AS (
    SELECT Country FROM customers
    UNION
    SELECT Country FROM suppliers
    ORDER BY Country
), s AS (
    SELECT DISTINCT Country FROM suppliers ORDER BY Country
), c AS (
    SELECT DISTINCT Country FROM customers ORDER BY Country
)
SELECT s.Country AS SupplierCountry, c.Country AS CustomerCountry
FROM AllCountries
LEFT JOIN s
USING (Country)
LEFT JOIN c
USING (Country);

USE auticon_more_sql_problems;

-- -- m24. How many cost changes do products generally have? -- --
WITH PriceChanges AS (
    SELECT ProductID, COUNT(StartDate) AS Changes FROM productcosthistory
    GROUP BY ProductID
    )
SELECT Changes AS TotalPriceChanges, COUNT(Changes) AS TotalProducts
FROM PriceChanges
GROUP BY Changes
ORDER BY TotalPriceChanges;

-- -- m25. Size and base ProductNumber for products -- --
--        (not assigned, but #26 depends on it)
WITH pnum AS (
	SELECT ProductNumber, ProductID,
	POSITION('-' IN ProductNumber) AS HyphenLocation
	FROM product
)
SELECT ProductID, ProductNumber, HyphenLocation,
SUBSTRING_INDEX(ProductNumber, '-', 1) AS BaseProductNumber,
CASE WHEN HyphenLocation = 0 THEN NULL
    WHEN HyphenLocation > 0 THEN SUBSTRING_INDEX(ProductNumber, '-', -1) 
    END Size
FROM pnum
WHERE ProductID > 533
ORDER BY ProductID;

-- -- m26. Num of sizes for each base product number -- --
WITH pnum AS (
SELECT ProductID, ProductSubcategoryID, 
	ProductNumber, SUBSTRING_INDEX(ProductNumber, '-', 1) AS BaseProductNumber
FROM product
)	
SELECT BaseProductNumber, COUNT(BaseProductNumber) AS TotalSizes
FROM pnum
JOIN productsubcategory psc
USING (ProductSubcategoryID)
WHERE psc.ProductCategoryID = 3
GROUP BY BaseProductNumber
ORDER BY BaseProductNumber;

-- -- m29. Fix this SQL! Number 3 -- --
with FraudSuspects as (
Select * From Customer Where
CustomerID in (
29401,11194,16490,22698,26583,12166,16036,25110,18172,11997,26731))
Select * 
From (SELECT c.CustomerID, c.FirstName, c.LastName, c.AccountNumber,
c.ModifiedDate
FROM Customer c
LEFT JOIN FraudSuspects 
ON c.CustomerID = FraudSuspects.CustomerID
WHERE FraudSuspects.CustomerID IS NULL
ORDER BY Rand()
LIMIT 100) AS Sample
UNION
Select * 
FROM FraudSuspects;

USE auticon_sql_problems;

-- -- 28. redux: High freight charges—last year -- --
WITH DateInt (d) AS (
SELECT DATE_ADD(MAX(OrderDate), Interval - 1 year)
FROM Orders
)
SELECT ShipCountry, AVG(Freight) AS AverageFreight
FROM Orders
WHERE OrderDate > (SELECT d FROM DateInt)
GROUP BY ShipCountry
ORDER BY AverageFreight DESC
LIMIT 3;

-- -- 39. redux: Orders—accidental double-entry details -- --
WITH OrderCount (oc) AS (
SELECT OrderID
FROM orderdetails
GROUP BY OrderID, Quantity
HAVING Quantity > 59 AND COUNT(OrderID) > 1
ORDER BY OrderID)
SELECT *
FROM orderdetails
WHERE OrderID IN (SELECT oc FROM OrderCount);

-- -- 40. redux: Orders—accidental double-entry details, derived table -- --
WITH ppo AS (
Select Distinct(OrderID)
From OrderDetails
Where Quantity >= 60
Group By OrderID, Quantity
Having Count(*) > 1
)
Select
OrderDetails.OrderID
,ProductID
,UnitPrice
,Quantity
,Discount
FROM OrderDetails
JOIN (SELECT * FROM ppo) PotentialProblemOrders
USING (OrderID)
Order by OrderID, Quantity;

-- -- 41. redux: Late orders -- --
# Cannot be done because there is no subquery in solution

USE auticon_more_sql_problems;

-- -- m8. redux: Product List Price: months with no price changes? -- --
WITH Dates AS (
SELECT MIN(StartDate) AS n,
MAX(StartDate) AS x
FROM productlistpricehistory
)
SELECT c.CalendarMonth AS CalendarMonth, COUNT(p.ProductID) AS TotalRows
FROM calendar c
LEFT JOIN productlistpricehistory p
ON DATE(c.CalendarDate) = DATE(p.StartDate)
WHERE c.calendarDate >= (SELECT n FROM Dates)
AND c.calendarDate <= (SELECT x FROM Dates)
GROUP BY c.CalendarMonth;
-- -- m10. redux: Products without a list price history -- --
# Cannot be done because there is no subquery in original solution

USE auticon_sql_problems;

-- -- 55. First order in each country -- --
WITH sc AS (SELECT ShipCountry, CustomerID, OrderID, DATE(OrderDate) AS OrderDate,
    Row_Number() OVER (PARTITION BY ShipCountry
    ORDER BY ShipCountry, OrderID) RowNumberPerCountry
    FROM Orders)
    SELECT ShipCountry, CustomerID, OrderID, OrderDate
    FROM sc
    WHERE RowNumberPerCountry = 1;

USE auticon_more_sql_problems;

-- -- m19. Raw margin quartile for products -- --
WITH rm AS (
SELECT ProductID, ProductName, StandardCost, ListPrice,
ListPrice - StandardCost AS RawMargin
FROM product
WHERE StandardCost > 0
)
SELECT ProductID, ProductName, StandardCost, ListPrice, RawMargin,
NTILE (4) OVER (ORDER BY RawMargin DESC) AS Quartile
FROM rm
ORDER BY ProductName;

-- -- m23. Duplicate product: details -- --
WITH pdpi AS (
SELECT ROW_NUMBER() OVER (PARTITION BY ProductName ORDER BY ProductID) AS rn,
ProductID, ProductName
FROM product)
SELECT ProductID AS PotentialDuplicateProductID, ProductName
FROM pdpi
WHERE rn = 2;

-- -- m27. How many cost changes has each product really had? -- --
WITH prevsc AS (
	SELECT *,
		LAG(StandardCost) OVER (PARTITION BY ProductID ORDER BY StartDate) PreviousStandardCost
    FROM productcosthistory
)
SELECT ProductID, ProductName, COUNT(*) AS TotalCostChanges
FROM prevsc
JOIN product p 
USING (ProductID)
WHERE PreviousStandardCost <> prevsc.StandardCost OR PreviousStandardCost IS NULL
GROUP BY ProductID
ORDER BY ProductID;

-- -- m28. Which products had the largest increase in cost? -- --
WITH costincrease AS (
SELECT ProductID
, DATE(StartDate) AS CostChangeDate
, StandardCost
, LAG(StandardCost) OVER (PARTITION BY ProductID ORDER BY StartDate) PreviousStandardCost
FROM productcosthistory
)
SELECT *, StandardCost - PreviousStandardCost AS PriceDifference
FROM costincrease
HAVING PriceDifference IS NOT NULL
ORDER BY PriceDifference DESC, ProductID;

-- NOTE: The author's expected query results have negated differences--
--       i.e., cost DECREASES instead of INCREASES. If you do the opposite,
--       these are the results to expect:
/*
ProductID CostChangeDate  StandardCost PreviousStandardCost PriceDifference
792       2013-05-30      1554.9479    1320.6838            234.2641
793       2013-05-30      1554.9479    1320.6838            234.2641
794       2013-05-30      1554.9479    1320.6838            234.2641
795       2013-05-30      1554.9479    1320.6838            234.2641
796       2013-05-30      1554.9479    1320.6838            234.2641
779       2013-05-30      1265.6195    1117.8559            147.7636
780       2013-05-30      1265.6195    1117.8559            147.7636
781       2013-05-30      1265.6195    1117.8559            147.7636
717       2013-05-30       868.6342     722.2568            146.3774
718       2013-05-30       868.6342     722.2568            146.3774
719       2013-05-30       868.6342     722.2568            146.3774
720       2013-05-30       868.6342     722.2568            146.3774
721       2013-05-30       868.6342     722.2568            146.3774
837       2013-05-30       868.6342     722.2568            146.3774
838       2013-05-30       868.6342     722.2568            146.3774
(not all rows shown; there should be 102)
*/


/**************************************************** MODULE 4 *******/
SELECT * FROM ProductListPriceHistory
WHERE ProductID IN (737, 746);
-- -- m30. History table with start/end date overlap -- --
/* FIXME this misses productID #737, and doesn't have the expected
 * TotalRows column. */

WITH ol AS (
SELECT
    ProductID,
    StartDate,
    IFNULL(EndDate, DATE_ADD(StartDate, INTERVAL 1 month)) AS EndDate,
    LAG(EndDate,1) OVER (PARTITION BY ProductID ORDER BY StartDate, EndDate) AS PreviousEndDate
FROM ProductListPriceHistory
),
tr AS (
SELECT CalendarDate, ProductID, COUNT(ProductID) AS TotalRows
FROM ol
JOIN calendar
ON CalendarDate BETWEEN StartDate AND EndDate
GROUP BY ProductID, CalendarDate
)
SELECT *
FROM (SELECT CalendarDate, ProductID
	FROM ol
	JOIN calendar c 
	ON ol.StartDate <= c.CalendarDate AND c.CalendarDate <= ol.PreviousEndDate
	WHERE PreviousEndDate IS NOT NULL AND PreviousEndDate > StartDate) AS Dates
JOIN tr
USING (ProductID, CalendarDate)
ORDER BY ProductID, CalendarDate;

-- -- m31. History table with start/end date overlap (#30) part 2 -- --
-- See m30--

-- -- m32. Running total of orders in last year -- --
WITH count AS (
SELECT DATE_FORMAT(OrderDate, "%Y/%m - %M") AS CalendarMonth
, COUNT(SalesOrderID) AS TotalOrders
FROM salesorderheader
WHERE OrderDate >= DATE_ADD((SELECT MAX(OrderDate) FROM salesorderheader), Interval - 1 year)
GROUP BY CalendarMonth
)
SELECT *
, SUM(TotalOrders) OVER (ORDER BY CalendarMonth) AS RunningTotal
FROM count;

-- -- m33. Total late orders by territory -- --
WITH Lates AS (
SELECT SalesOrderID
, TerritoryID
, TerritoryName
, CountryCode
, DueDate
, ShipDate
, CASE WHEN DueDate < ShipDate THEN 1
ELSE 0
END AS LateOrder
FROM salesterritory
JOIN salesorderheader soh
USING (TerritoryID)
)
SELECT TerritoryID
, TerritoryName
, CountryCode
, COUNT(SalesOrderID) AS TotalOrders
, SUM(LateOrder) AS TotalLateOrders
FROM Lates
GROUP BY TerritoryID
ORDER BY TerritoryID;

-- -- m35. Customer's last purchase--what was the product subcategory? -- --
WITH SubOrders AS (
SELECT CustomerID
, soh.OrderDate
, MAX(soh.OrderDate) OVER (PARTITION BY CustomerID) AS MaxDate
, soh.SalesOrderID
, CONCAT(FirstName, ' ', LastName) AS CustomerName
, sod.LineTotal
, MAX(sod.LineTotal) OVER (PARTITION BY CustomerID, OrderDate) AS MaxTotal
, LAST_VALUE(psc.ProductSubCategoryName) OVER (PARTITION BY CustomerID ORDER BY OrderDate, LineTotal) ProductSubCategoryName
FROM customer
JOIN salesorderheader soh
USING (CustomerID)
JOIN salesorderdetail sod
USING (SalesOrderID)
JOIN  product p
USING (ProductID)
JOIN productsubcategory psc
USING (ProductSubCategoryID)
WHERE CustomerID IN (19500, 19792, 24409, 26785)
)
SELECT CustomerID,
CustomerName,
ProductSubCategoryName
FROM SubOrders
WHERE OrderDate = MaxDate AND LineTotal = MaxTotal;

-- -- m36. Order Processing: time in each stage -- --
WITH eventcte AS (
SELECT SalesOrderID
, te.EventName
, EventDateTime AS TrackingEventDate
, LEAD(EventDateTime) OVER (PARTITION BY SalesOrderID ORDER BY EventDateTime) AS NextTrackingEventDate
FROM ordertracking
JOIN trackingevent te
USING (TrackingEventID)
WHERE SalesOrderID IN (68857, 70531, 70421)
)
SELECT *
, TIMESTAMPDIFF(hour, TrackingEventDate, NextTrackingEventDate) AS HoursInStage
FROM eventcte
ORDER BY SalesOrderID, TrackingEventDate;

-- -- m37. Order Processing: time in each stage, part 2 -- --
WITH eventcte2 AS (
SELECT CASE
    WHEN OnlineOrderFlag = 0 THEN 'Offline'
    ELSE 'Online'
    END AS OnlineOfflineStatus
	, TrackingEventID
	, te.EventName
	, ot.EventDateTime AS TrackingEventDate
	, LEAD(ot.EventDateTime) OVER (PARTITION BY ot.SalesOrderID ORDER BY ot.EventDateTime) AS NextTrackingEventDate
FROM salesorderheader
JOIN ordertracking ot
USING (SalesOrderID)
JOIN trackingevent te
USING (TrackingEventID)
)
SELECT OnlineOfflineStatus
	, EventName
	, AVG(TIMESTAMPDIFF(hour, TrackingEventDate, NextTrackingEventDate)) AS AVerageHourSpentInStage
FROM eventcte2
GROUP BY EventName, OnlineOfflineStatus, TrackingEventID
ORDER BY OnlineOfflineStatus, TrackingEventID;

-- -- m38. Order processing: time in each stage, part 3 -- --
WITH eventcte3 AS (
SELECT CASE
    WHEN OnlineOrderFlag = 0 THEN 'Offline'
    ELSE 'Online'
    END AS OnlineOfflineStatus
, TrackingEventID
, te.EventName
, ot.EventDateTime AS TrackingEventDate
, LEAD(ot.EventDateTime) OVER (PARTITION BY ot.SalesOrderID ORDER BY ot.EventDateTime) AS NextTrackingEventDate
FROM salesorderheader
JOIN ordertracking ot
USING (SalesOrderID)
JOIN trackingevent te
USING (TrackingEventID)
)
SELECT EventName
, AVG(TIMESTAMPDIFF(hour, ec31.TrackingEventDate, ec31.NextTrackingEventDate)) AS OfflineAvgHoursInStage
, AVG(TIMESTAMPDIFF(hour, ec32.TrackingEventDate, ec32.NextTrackingEventDate)) AS OnlineAvgHoursInStage
FROM (SELECT * FROM eventcte3
WHERE OnlineOfflineStatus = 'Offline') AS ec31
JOIN (SELECT * FROM eventcte3
WHERE OnlineOfflineStatus = 'Online') AS ec32
USING (EventName)
GROUP BY EventName, ec31.TrackingEventID
ORDER BY ec31.TrackingEventID;

-- -- m39. Top three product subcategories per customer -- --
WITH SubcatCost AS (
SELECT soh.CustomerID
, CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName
, SUM(sod.LineTotal) AS TotalCost,
psc.ProductSubCategoryName
FROM salesorderheader soh
JOIN salesorderdetail sod
USING (SalesOrderID)
JOIN product p
USING (ProductID)
JOIN customer c
USING (CustomerID)
JOIN productsubcategory psc
USING (ProductSubcategoryID)
WHERE CustomerID IN (13763, 13836, 20331, 21113, 26313)
GROUP BY c.CustomerID, CustomerName, psc.ProductSubCategoryName
), TopSubCats AS (
SELECT CustomerID, CustomerName,
NTH_VALUE(ProductSubCategoryName, 1) OVER (win) AS TopProdSubCat1,
NTH_VALUE(ProductSubCategoryName, 2) OVER (win) AS TopProdSubCat2,
NTH_VALUE(ProductSubCategoryName, 3) OVER (win) AS TopProdSubcat3,
ROW_NUMBER () OVER (PARTITION BY CustomerID ORDER BY TotalCost) AS Seq
FROM SubcatCost
WINDOW win AS (PARTITION BY CustomerID ORDER BY TotalCost DESC)
)
SELECT CustomerID, CustomerName, TopProdSubCat1, TopProdSubCat2, TopProdSubCat3
FROM TopSubCats
WHERE Seq = 1;

-- -- m40. History table with date gaps -- --
WITH dates AS (
SELECT ProductID
, StartDate
, EndDate
, LAG(EndDate,1) OVER (PARTITION BY productID ORDER BY StartDate, EndDate) AS PreviousEndDate
FROM productlistpricehistory
)
SELECT *
FROM (SELECT ProductID, c.CalendarDate
FROM dates
JOIN calendar c
ON c.CalendarDate > dates.PreviousEndDate AND c.CalendarDate < dates.StartDate
WHERE StartDate > DATE_ADD(PreviousEndDate, INTERVAL + 1 day)
AND PreviousEndDate IS NOT NULL) AS gaps;

/*** that's all the book problems ***/

/*** CSV import, row 137 ***/
-- Include your CREATE TABLE query here for a table called 'states' that
-- will contain the data from states.csv:
CREATE SCHEMA states;
USE states;
CREATE TABLE states (
`Rank` int,
State varchar(32),
Pop int,
Growth decimal(4,4),
Pop2018 int,
Pop2010 int,
growthSince decimal(4,4),
Percent decimal(4,4),
Density decimal(8,4)
);


/* Note:
 * To use LOAD DATA in the following query, the variable secure_file_priv must
 * be set to the full path of a directory containing your .csv file, and that
 * directory must exist and be writable by the mysql daemon.
 */
-- Include a LOAD DATA query that would load the data from states.csv
-- into your table (assuming the secure_file_priv variable is set correctly):

LOAD DATA INFILE 'D:\SQL\states.csv'
INTO TABLE states
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '/n'
IGNORE 1 ROWS;
/*** CSV export, row 138 ***/

/* Note:
 * The variable secure_file_priv must be set to '/tmp/mydata',
 * and /tmp/mydata must exist and be writable by the mysql daemon,
 * for the following query to work.
 */
 
USE states;

-- Include the query you used for sorting the table and writing it out to
-- a new CSV file:
SELECT *
FROM states
WHERE State NOT IN ("Puerto Rico", "District of Columbia")
ORDER BY Pop;
/**************************************************** MODULE 5 *******/

/*********************** Row 140 Questions & SQL. ***********************/
/* Answer in comments, except for the SQL you're asked to write.        */
/************************************************************************/

/*
 1. What is a primary key (PK)?  Look it up if you're not sure, but answer in
 *  your own words, don't copy and paste what you read.
 
 Primary Key is the field (or group of fields) that uniquely identifies
 an entry in a table 
 */

/* 2. What data type should BirthDate be? 

Date
*/

/* 3. What data type should Gender be? 

ENUM(8)
*/

/* 4. What do you suspect that AddressType is used for? 
To differentiate between the employees' work address and home address and should be
ENUM(8)
*/

/* 5. What data type should MaritalStatus be? 

ENUM(8)
*/

/* 6. What kind of table is EmployeeAddress? 
Since this table is used to connect the other two tables with the two primary keys, 
this is an association table
*/

/* 7. SQL adding a column for the manager the employee reports to: */
ALTER TABLE Employee
ADD ReportsTo int(16); 


/* 8. SQL adding a column for employee level: */
ALTER TABLE Employee
ADD Level int(16);


/* 9. SQL adding a column for employee photo: */
ALTER TABLE Employee
ADD Photo MEDIUMBLOB;


/*
10. What type should ModifiedDate be?  Pretend that this field doesn't
 *  exist, and express this, too, as an ALTER TABLE.*/
 ALTER TABLE Employee
 ADD ModifiedDate date;
