/*Name: Ngala Dirane Ngiri
Lesson: Combining Data from Multiple sources
Date: 22/09/2018*/

USE july_14_online

INSERT INTO Stg_Emp 
VALUES (1,'John Doe'),
		(2,'Jane Doe'),
		(3,'Sally Mae')

INSERT INTO Emp_list
VALUES (1,'John Doe'),
		(2,'Jane Doe'),
		(5,'Peggy Sue')

--Company's new Employees

SELECT s.EmpID, s.EmpName
FROM Stg_Emp s 
WHERE NOT EXISTS (
					SELECT * 
					FROM Emp_List e 
					INNER JOIN Stg_Emp 
					ON s.EmpID=e.EmpID
					)

--Company's former employee
SELECT e.EmpId, e.EmpName
FROM Emp_list e
WHERE NOT EXISTS (
					SELECT * 
					FROM Stg_Emp s
					INNER JOIN Emp_list 
					ON e.EmpID=s.EmpId
					)
--Use AdventureWorks Database to complete the following questions.
USE AdventureWorks2016
--1.How many Sales Orders (Headers) used Vista credit cards in October 2002
SELECT h.SalesOrderID, h.[CreditCardID], s.[CardType] 
FROM [Sales].[SalesOrderHeader] h 
INNER JOIN [Sales].[CreditCard] s 
ON s.CreditCardID = h.CreditCardID 
WHERE [CardType] = 'Vista' AND s.ModifiedDate BETWEEN '2002-10-01' AND '2002-10-31'


--2 Store the answer to Q1. in a variable.	
DECLARE @SalesOrderCreditCard TABLE 
								(
								SalesOrderID INT,
								CreditCardID INT,
								CardType VARCHAR(50)
								)
INSERT INTO @SalesOrderCreditCard
SELECT h.SalesOrderID, h.[CreditCardID], s.[CardType] 
FROM [Sales].[SalesOrderHeader] h 
INNER JOIN [Sales].[CreditCard] s 
ON s.CreditCardID = h.CreditCardID 
WHERE [CardType] = 'Vista' AND s.ModifiedDate BETWEEN '2002-10-01' AND '2002-10-31'

/*3.Create a UDF that accepts start date and end date. The function will return
the number of Sales Orders (Using Vista credit cards) that took place between 
the start date and end date entered by the user.*/

GO
CREATE FUNCTION dbo.Fx_NumOfSales 
( @Startdate datetime, @EndDate datetime ) 
RETURNS int 
AS 
BEGIN
DECLARE @Fx_NumOfSales 
AS int 
SET @Fx_NumOfSales = ( SELECT COUNT (*) 
AS CountOfSales 
FROM [Sales].[SalesOrderHeader] h 
JOIN [Sales].[CreditCard] s 
ON s.CreditCardID = h.CreditCardID 
WHERE [CardType] = 'Vista' AND s.ModifiedDate BETWEEN @Startdate AND @EndDate ) 
RETURN @Fx_NumOfSales 
END
GO
/*4.Using the SalesOrderHeader table - Find out how much Revenue (TotalDue) was brought
 in by the North American Territory Group from 2002 through 2004*/

 SELECT h.[TotalDue] 
 FROM [Sales].[SalesOrderHeader] h 
 INNER JOIN [Sales].[SalesTerritory] s 
 ON h.[TerritoryID] = s.TerritoryID 
 WHERE h.TerritoryID IN (1,2,3,4,5,6) AND h.[OrderDate] BETWEEN YEAR(2002) AND YEAR(2004)

--5.What is the Sales Tax Rate, StateProvinceCode and CountryRegionCode for Texas?
SELECT s.[TaxRate], s.[StateProvinceID], t.[CountryRegionCode] 
FROM [Sales].[SalesTaxRate] s 
JOIN [Sales].[SalesTerritory] t 
ON s.[ModifiedDate] = t.[ModifiedDate] 
WHERE s.[Name] Like 'Texas%'
GO
--6.Store the information from Q5 in a variable.
DECLARE @SalesTaxtRateProvinceCountryCode TABLE 
								(
								SalesOrderID INT,
								CreditCardID INT,
								CardType VARCHAR(50)
								)
INSERT INTO @SalesTaxtRateProvinceCountryCode 
SELECT s.[TaxRate], s.[StateProvinceID], t.[CountryRegionCode] 
FROM [Sales].[SalesTaxRate] s 
JOIN [Sales].[SalesTerritory] t 
ON s.[ModifiedDate] = t.[ModifiedDate] 
WHERE s.[Name] Like 'Texas%'

/*7.Create a UDF that accepts the State Province and returns the associated
Sales Tax Rate, StateProvinceCode and CountryRegionCode.*/
GO
 CREATE FUNCTION Fx_AssociatedSalesTaxRate ( @StateProvinceID int ) 
 RETURNS TABLE 
 AS 
 RETURN ( SELECT s.[TaxRate], s.[StateProvinceID], t.[CountryRegionCode] 
 FROM [Sales].[SalesTaxRate] s 
 JOIN [Sales].[SalesTerritory] t 
 ON s.[ModifiedDate] = t.[ModifiedDate] 
 WHERE s.[StateProvinceID] = @StateProvinceID ) 
 GO

/*8.Show a list of Product Colors. For each Color show how many SalesDetails there are 
and the Total SalesAmount (UnitPrice * OrderQty). Only show Colors with a
Total SalesAmount more than $50,000 and eliminate the products that do not have
a color.*/
SELECT DISTINCT(p.color) 
AS Color, COUNT(s.SalesOrderID) 
AS OrderID, SUM(s.[UnitPrice]*s.OrderQty) 
AS TotalSalesAmt 
FROM [Sales].[SalesOrderDetail] S 
JOIN [Production].[Product] p 
ON s.[ProductID] = p.[ProductID] 
WHERE p.Color IS NOT NULL 
GROUP BY (p.color) 
HAVING SUM(s.[UnitPrice]*s.OrderQty) > 50000

/*Create a join using 4 tables in AdventureWorks database.  
Explain what the join is doing and post it to the Google Group.*/
SELECT he.BusinessEntityID Employee,
		em.Rate Wages,
		eh.startdate startdate,
		hd.[Name] Dept
	FROM [HumanResources].[Employee] he
	INNER JOIN [HumanResources].[EmployeePayHistory] em
	ON he.BusinessEntityID = em.BusinessEntityID
	INNER JOIN [HumanResources].[EmployeeDepartmentHistory] eh
	ON he.BusinessEntityID = eh.BusinessEntityID
	INNER JOIN [HumanResources].[Department] hd
	ON eh.DepartmentID = hd.DepartmentID 
	AND hd.[Name] = 'Engineering'