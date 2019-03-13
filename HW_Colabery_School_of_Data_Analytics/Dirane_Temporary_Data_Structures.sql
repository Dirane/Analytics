/*Name: Ngala Dirane Ngiri
Lesson: Temporary Data Structures
Date: 17/08/2018
*/
/*1.Create 10 temp tables using Adventureworks Database.  
2.	Create the same 10 tables as CTE’s.
3.	Create the same 10 tables as Table Variables.
Once you create a query, you will store it in all 3 Temporary Data Structures.
You can pick the AdventureWorks tables but they must match the following formats:*/

USE [AdventureWorks2016]
GO
--Query 1  - Must use the LIKE and BETWEEN operators
--Using temp tables
SELECT [Name], [ReasonType], [ModifiedDate]
INTO #SubSalesReason
FROM [Sales].[SalesReason]
WHERE  [ReasonType] LIKE '%Marketing' AND [Name] BETWEEN 'Magazine Advertisement' AND 'Television  Advertisement'

--Using CTE's
WITH SubSalesReason_CTE ([Name_cte], [ReasonType_cte], [ModifiedDate_cte] )
AS
(
SELECT [Name], [ReasonType], [ModifiedDate]
FROM [Sales].[SalesReason]
WHERE  [ReasonType] LIKE '%Marketing' AND [Name] BETWEEN 'Magazine Advertisement' AND 'Television  Advertisement'
)
SELECT [Name_cte], [ReasonType_cte], [ModifiedDate_cte]
FROM SubSalesReason_CTE

--Using table variable
DECLARE @SubSalesReason TABLE (
								[Name] VARCHAR(100),
								[ReasonType] VARCHAR(50), 
								[ModifiedDate] DATETIME
								)
		INSERT INTO @SubSalesReason
		SELECT [Name], [ReasonType], [ModifiedDate]
		FROM [Sales].[SalesReason]
		WHERE  [ReasonType] LIKE '%Marketing' AND [Name] BETWEEN 'Magazine Advertisement' AND 'Television  Advertisement'

--Query 2 – Must use the IN and NOT IN operators
--Using temp tables
SELECT [Name], [CountryRegionCode],[Group]
INTO #SubSalesTerritory
FROM [Sales].[SalesTerritory]
WHERE [Name] IN ('Northwest','Southwest','France') AND [CountryRegionCode] NOT IN ('FR')

--Using CTE's
WITH SubSalesTerritory_CTE ([Name_cte], [CountryRegionCode_cte],[Group_cte])
AS 
(
SELECT [Name], [CountryRegionCode],[Group]
FROM [Sales].[SalesTerritory]
WHERE [Name] IN ('Northwest','Southwest','France') AND [CountryRegionCode] NOT IN ('FR')
)
SELECT [Name_cte], [CountryRegionCode_cte],[Group_cte]
FROM SubSalesTerritory_CTE

--Using table variables
DECLARE @SubSalesTerritory_tblV TABLE (
										 [Name] VARCHAR(50), 
										 [CountryRegionCode] VARCHAR(10),
										 [Group] VARCHAR(50)
										 )
			INSERT INTO @SubSalesTerritory_tblV
			SELECT [Name], [CountryRegionCode],[Group]
			FROM [Sales].[SalesTerritory]
			WHERE [Name] IN ('Northwest','Southwest','France') AND [CountryRegionCode] NOT IN ('FR')


--Query 3 – Must use a Group By Statement and 2 aggregates (Temp table should be built using SELECT INTO Statement
--Using temp tables
SELECT [Group], COUNT([Group]) AS numOfGroups, SUM(CostLastYear) AS cost
INTO #SubSalesTerritory2
FROM [Sales].[SalesTerritory]
GROUP BY [Group]
GO
--Using CTE's
WITH SubSalesTerritory2_CTE ([Groupcte], [numOfGroups_cte],[cost_cte])
AS
(
SELECT [Group], COUNT([Group]) AS numOfGroups, SUM(CostLastYear) AS cost
FROM [Sales].[SalesTerritory]
GROUP BY [Group]
)
SELECT [Groupcte], [numOfGroups_cte],[cost_cte]
FROM SubSalesTerritory2_CTE

--Using table variable
DECLARE @SubSalesTerritory2_tblV TABLE (
									[Group] VARCHAR(50),
									[numOfGroups] INT,
									[cost] FLOAT 
									)
		INSERT INTO @SubSalesTerritory2_tblV
		SELECT [Group], COUNT([Group]) AS numOfGroups, SUM(CostLastYear) AS cost
		FROM [Sales].[SalesTerritory]
		GROUP BY [Group]

--Query 4 – Must use the UNION operator
--Using temp tables
SELECT CountryRegionCode
INTO #counryRegionCodes
FROM Sales.SalesTerritory
UNION
SELECT CountryRegionCode
FROM Sales.CountryRegionCurrency
GO
--Using CTE's
WITH countryRegionCodes_CTE (CountryRegionCode_cte)
AS
(
SELECT CountryRegionCode
FROM Sales.SalesTerritory
UNION
SELECT CountryRegionCode
FROM Sales.CountryRegionCurrency
)
SELECT CountryRegionCode_cte
FROM countryRegionCodes_CTE

--Using table variable
DECLARE @countryRegionCodes_tblV TABLE (
										CountryRegionCode VARCHAR(50)
										)
		INSERT INTO @countryRegionCodes_tblV
		SELECT CountryRegionCode
		FROM Sales.SalesTerritory
		UNION
		SELECT CountryRegionCode
		FROM Sales.CountryRegionCurrency

--Query 5 – Must be built using at least one column that is a Primary Key with an Identity Column.
--Using temp tables
CREATE TABLE #tmpWithPKID
	(
	ID INT IDENTITY(1, 1) ,
	tempName VARCHAR(50),
	City VARCHAR(100),
	AccountNum int
	);

--Using CTE'S
WITH tmpWithPKID_CTE  (ID_cte, tempName_cte,City_cte, AccountNum_cte)
AS
(
SELECT ID,tempName,City,AccountNum
FROM #tmpWithPKID
)
SELECT * FROM tmpWithPKID_CTE

--Using table variable
DECLARE @tmpWithPKID TABLE (
							ID INT IDENTITY(1, 1) ,
							tempName VARCHAR(50),
							City VARCHAR(100),
							AccountNum int
							)

--Query 6 – Must be built using a WHERE clause and ORDER BY clause
--Using temp tables
IF OBJECT_ID('tempdb..#VendorPurchase') IS NOT NULL
BEGIN
DROP TABLE #VendorPurchase
END
SELECT BusinessEntityID, AverageLeadTime, StandardPrice
INTO #VendorPurchase
FROM Purchasing.ProductVendor
WHERE AverageLeadTime = 17
ORDER BY StandardPrice

--Using CTE's
WITH VendorPurchase_CTE(BusinessEntityID_cte, AverageLeadTime_cte, StandardPrice_cte)
AS
(
SELECT BusinessEntityID, AverageLeadTime, StandardPrice
FROM Purchasing.ProductVendor
WHERE AverageLeadTime = 17
)
SELECT * FROM VendorPurchase_CTE

--Usint table variable
DECLARE @VendorPurchase_tblV TABLE (
									BusinessEntityID INT,
									AverageLeadTime INT,
									StandardPrice MONEY
								)
			INSERT INTO @VendorPurchase_tblV
			SELECT BusinessEntityID, AverageLeadTime, StandardPrice
			FROM Purchasing.ProductVendor
			WHERE AverageLeadTime = 17
			ORDER BY StandardPrice

--Query 7 – Must be built using a GROUP BY clause and HAVING Clause
--Using temp tables
SELECT SUM(SubTotal) AS sumTotal
INTO #SalesOrderSummary
FROM Sales.SalesOrderHeader
GROUP BY SubTotal
HAVING SubTotal > 5000

--Using CTE's
WITH SalesOrderSummary_CTE (sumTotal_cte)
AS 
(
SELECT SUM(SubTotal) AS sumTotal
FROM Sales.SalesOrderHeader
GROUP BY SubTotal
HAVING SubTotal > 5000
)
SELECT * FROM SalesOrderSummary_CTE

--Using table variable
DECLARE @SalesOrderSummary_tblV TABLE (
										sumTotal MONEY
										)
		INSERT INTO @SalesOrderSummary_tblV
		SELECT SUM(SubTotal) AS sumTotal
		FROM Sales.SalesOrderHeader
		GROUP BY SubTotal
		HAVING SubTotal > 5000


--Query 8 – Must be built using WHERE / GROUP BY / HAVING / ORDER BY clauses
--Using temp tables
IF OBJECT_ID('tempdb..#CustomerAccount') IS NOT NULL
BEGIN
DROP TABLE #CustomerAccount
END

SELECT COUNT(TerritoryID) AS custCnt, AccountNumber
INTO #CustomerAccount
FROM Sales.Customer
GROUP BY AccountNumber
HAVING COUNT(TerritoryID) > 0
ORDER BY COUNT(TerritoryID) DESC

--Using CTE's
WITH CustomerAccount_CTE(custCnt_cte, AccountNumber_cte)
AS
(
SELECT COUNT(TerritoryID) AS custCnt, AccountNumber
FROM Sales.Customer
GROUP BY AccountNumber
HAVING COUNT(TerritoryID) > 0
)
SELECT * FROM  CustomerAccount_CTE

--Using table variable
DECLARE @CustomerAccount_tblV TABLE (
								custCnt INT,
								AccountNumber VARCHAR(50)
								)
		INSERT INTO @CustomerAccount_tblV
		SELECT COUNT(TerritoryID) AS custCnt, AccountNumber
		FROM Sales.Customer
		GROUP BY AccountNumber
		HAVING COUNT(TerritoryID) > 0
		ORDER BY COUNT(TerritoryID) DESC

--Query 9 – Must be built using 3 System Functions
--Using temp tables
SELECT UPPER([Name]) AS Name1, LEN([Name]) AS length1, YEAR(ModifiedDate) AS year1
INTO #PersonCountry
FROM Person.CountryRegion
GO
--Using CTE's
WITH PersonCountry_CTE (Name1_cte,length1_cte,year1_cte)
AS
(
SELECT UPPER([Name]) AS Name1, LEN([Name]) AS length1, YEAR(ModifiedDate) AS year1
FROM Person.CountryRegion
)
SELECT * FROM PersonCountry_CTE


--Using table variable
DECLARE @PersonCountry_tblV TABLE (
							[Name1] VARCHAR(50),
							[length1] INT,
							[year1] INT
							)
		INSERT INTO @PersonCountry_tblV
		SELECT UPPER([Name]) AS Name1, LEN([Name]) AS length1, YEAR(ModifiedDate) AS year1
		FROM Person.CountryRegion

--Query 10 – Must be built using 3 other System Functions
--Using temp tables
SELECT ISDATE(ModifiedDate) as binVal,FLOOR(Bonus) as intBonus, DATEADD(year,1,ModifiedDate) as Mdate
INTO #sysValues
FROM Sales.SalesPerson
GO
--Using CTE's
WITH sysValues_CTE (binVal_cte,intBonus_cte,Mdate_cte)
AS
(
SELECT ISDATE(ModifiedDate) as binVal,FLOOR(Bonus) as intBonus, DATEADD(year,1,ModifiedDate) as Mdate
FROM Sales.SalesPerson
)
SELECT * FROM sysValues_CTE 

--Using table variable
DECLARE @sysValues_tblV TABLE (
								binVal INT,
								floorBonus MONEY,
								Mdate DATETIME
								)
				INSERT INTO @sysValues_tblV
				SELECT ISDATE(ModifiedDate) as binVal,FLOOR(Bonus) as intBonus, DATEADD(year,1,ModifiedDate) as Mdate
				FROM Sales.SalesPerson
