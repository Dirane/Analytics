/*Name: Ngala Dirane Ngiri
Lesson: Developing and Implementing Stored Procedure
Date: 01/09/2018*/

/*1.	Name: CREATE PROCEDURE proc_TerritorySalesByYear
a.	Parameter: OrderYear
(Passing Value)
b.	Display the Total sales by territory for the Year Parameter
(The following is for the results set, which will be created in your statement in order to
 pass your parameter to receive the total sales by each territory)
 */

 GO
CREATE PROCEDURE proc_TerritorySalesByYear
	@OrderYear INT
AS
BEGIN
SET NOCOUNT ON
	SELECT  OrderDate, SUM(TotalDue) AS TotalSales
		FROM Sales.SalesOrderHeader S
		INNER JOIN Sales.SalesTerritory T
		ON S.TerritoryID = T.TerritoryID
		WHERE YEAR(S.OrderDate) = @OrderYear
		GROUP BY S.OrderDate	
END
EXEC proc_TerritorySalesByYear 2012

/*2.	Name: CREATE PROCEDURE proc_SalesByTerritory
a.	Parameter: Territory Name
(Passing Value)
b.	Results set: Display Total sales by Year for the Territory Name Parameter
(The following is for the results set, which will be created in your statement in 
order to pass your parameter to receive the total sales by each year)*/
GO

CREATE PROC proc_SalesByTerritory
	@TerritoryName VARCHAR(50)
AS
BEGIN
SET NOCOUNT ON
	SELECT T.[Name], SUM(TotalDue) AS TotalSales
		FROM Sales.SalesOrderHeader S
		INNER JOIN Sales.SalesTerritory T
		ON S.TerritoryID = T.TerritoryID
		WHERE T.[Name] = @TerritoryName
		GROUP BY T.[Name]	
END
EXEC proc_SalesByTerritory Central

/*3.	 Name: CREATE PROCEDURE proc_TerritoryTop5Sales_ByProduct
a.	Parameter: Territory Name
(Passing Value)
b.	Results set: Top 5 Products by year
(The following is for the results set, which will be created in your statement 
in order to pass in Territory Name to receive the Top 5 Products sold (Sum of Line Total) by each Year)*/
GO
CREATE PROC proc_TerritoryTop5SalesByProduct
@TerritoryName VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Year INT
	SET @Year = (SELECT TOP 1 YEAR(OrderDate)
					FROM Sales.SalesOrderHeader)
	CREATE TABLE #Products (TerName VARCHAR(50), ProdName VARCHAR(50), TotalSales MONEY, [Year] INT)
	INSERT INTO		#Products (TerName, ProdName, TotalSales, [Year])
	SELECT			t.[Name], p.[Name], SUM(TotalDue) TotalSales, YEAR(OrderDate) AS YR
	FROM			Sales.SalesOrderHeader s
	LEFT OUTER JOIN Sales.SalesTerritory t
	ON s.TerritoryID = t.TerritoryID
	LEFT OUTER JOIN Sales.SalesOrderDetail d
	ON s.SalesOrderID = d.SalesOrderID
	LEFT OUTER JOIN Production.Product p
	ON d.ProductID = p.ProductID
	WHERE t.Name = @TerritoryName
	GROUP BY YEAR(OrderDate), t.[Name], p.[Name]
	ORDER BY YEAR(OrderDate), SUM(TotalDue) DESC

	CREATE TABLE #YearTop5Products (TerName VARCHAR(50), ProdName VARCHAR(50), TotalSales MONEY, [Year] INT)
	WHILE	@Year IS NOT NULL
	BEGIN

	INSERT INTO		#YearTop5Products (TerName, ProdName, TotalSales, [Year])
	SELECT			TOP 5 TerName, ProdName, TotalSales, [Year]
	FROM			#Products
	WHERE			[Year] = @Year
	ORDER BY		[Year] DESC, TotalSales DESC

	DELETE FROM #Products
	WHERE		[Year] = @Year

	SET @Year = (
					SELECT TOP 1 [Year]
					FROM		#Products
				)
	END

	SELECT *
	FROM #YearTop5Products
	ORDER BY [Year]
END

/*
4.	 Stored Procedure with Output Parameters 
     a. Add a MgrID column to your emp table.
     b. Populate it accordingly using the integer data type and same number of characters as the empID       column
     c.  Build a SP that passes in empID and returns an output parameter of the mgrID - (Create the SP
	  and verify it works correctly) (Keep in mind that the mgrID will also be an individual’s 
	  empID., since managers are also employees)
     d.  (Start a New Query and separate it from the previous Stored Procedure) Declare an empid 
	 int and manager_name Varchar(50) variable
     e.  Hard code your new empid variable and Pass it into your new SP to return the mgrid 
(Use an actual empid in the variable location to test and Pass it into your new SP to return the mgrID)
     f.  Capture that mgrid in a variable and use that mgrid variable to determine the Managers name
(Create another statement which locates the Manager’s Name by using mgrID)
     e.  Print the Managers name
*/
GO
CREATE PROCEDURE proc_findMgrID
        @empID INT,
        @mgrID INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON;
       
                SELECT  @mgrID
                FROM    emp
                WHERE   empID = @empID
       
END
 
DECLARE @emp INT = 4
DECLARE @manager_name VARCHAR(50)
 
DECLARE @managerID INT
EXEC proc_findMgrID @emp,@mgrID=@managerID OUTPUT
 
SELECT  empName
FROM    emp
WHERE   empID = @managerID
 
--1. Display data from TableA where the values are identical in TableB.
CREATE TABLE TableA (id INT)
CREATE TABLE TableB (id INT)
 
 
CREATE PROCEDURE proc_findIdentical
       
AS
BEGIN
        SET NOCOUNT ON;
       
        SELECT  *
        FROM    TableA
        WHERE   id IN (SELECT * FROM TableB)
END
       
EXEC proc_findIdentical
 
 
 
 
--2. Display data from TableA where the values are not available in TableB.
CREATE PROCEDURE proc_findNotInB
       
AS
BEGIN
        SET NOCOUNT ON;
        SELECT  *
        FROM    TableA
        WHERE   id NOT IN (SELECT * FROM TableB)
END
       
EXEC proc_findNotInB
--3. Display data from TableB where the values are not available in TableA.
CREATE PROCEDURE proc_findNotInA
       
AS
BEGIN
        SET NOCOUNT ON;
        SELECT *
        FROM TableB
        WHERE id NOT IN (SELECT * FROM TableA)
END
       
EXEC proc_findNotInA
GO

--LAB II
--1. Display data from TableA where the values are identical in TableB.
SELECT * 
FROM [dbo].[TableA] A
INNER JOIN [dbo].[TableB] B
ON A.[Field1] = B.[Field1] 
--2. Display data from TableA where the values are not available in TableB.
SELECT *
FROM [dbo].[TableA] A
LEFT OUTER JOIN [dbo].[TableB] B
ON A.[Field1] = B.[Field1]
WHERE  A.[Field1] != B.[Field1]
--3. Display data from TableB where the values are not available in TableA.
SELECT *
FROM [dbo].[TableA] B
RIGHT OUTER JOIN [dbo].[TableB] A
ON B.[Field1] = A.[Field1]
WHERE  B.[Field1] != A.[Field1]

/*4.	Create a Stored Procedure that passes in the SalesOrderID as a parameter. 
This stored procedure will return the SalesOrderID, the Date of the transaction 
and a count of how many times the item was purchased.*/
GO
CREATE PROCEDURE proc_findProductInfo
        @SalesHeader INT,
        @SalesHeaderOut INT OUTPUT,
        @OrderDate DATETIME OUTPUT,
        @NumItems INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON;
       
SET     @SalesHeaderOut = @SalesHeader
 
SET @OrderDate = (SELECT OrderDate FROM sALES.SalesOrderHeader WHERE SalesOrderID = @SalesHeader)
 
SET @NumItems = (
        SELECT                  SUM(d.OrderQty)
        FROM                    Sales.SalesOrderHeader s                 
        LEFT OUTER JOIN Person.StateProvince t
        ON                              s.TerritoryID = t.TerritoryID
        LEFT OUTER JOIN Sales.SalesOrderDetail d
        ON                              s.SalesOrderID = d.SalesOrderID
        LEFT OUTER JOIN Production.Product p
        ON                              d.ProductID = p.ProductID
        WHERE                   S.SalesOrderID = @SalesHeader
        GROUP BY                s.SalesOrderID )
 
END
 
 
 
DECLARE @OrderNum INT, @Date DATETIME, @Qty INT
EXEC proc_findProductInfo 63936, @SalesHeaderOut=@OrderNum OUTPUT,
        @OrderDate=@Date OUTPUT,
        @NumItems=@Qty OUTPUT
 
SELECT @OrderNum, @date, @Qty
/*5. 	Create a Stored Procedure that passes in the SalesOrderID as a parameter. 
This stored procedure will return the SalesOrderID, Date of the transaction, shipping date, City and State.*/
GO
CREATE PROCEDURE proc_findProductInfo2
        @SalesOrderID int,
        @SalesOrderOut int OUTPUT,
        @OrderDate datetime OUTPUT,
        @ShipDate int OUTPUT,
        @CityState varchar(100) OUTPUT
AS
BEGIN
        SET NOCOUNT ON;
       
SET     @SalesOrderOut = @SalesOrderID
 
SET @OrderDate = (SELECT OrderDate FROM sALES.SalesOrderHeader )
 
SET @CityState = (
        SELECT                  City
        FROM                    Sales.SalesOrderHeader s         
        LEFT OUTER JOIN Person.Address a
        ON                              s.ShipToAddressID = a.AddressID
        LEFT OUTER JOIN Person.StateProvince st
		ON st.StateProvinceID = a.StateProvinceID
        WHERE SalesOrderID = @SalesOrderID
        )
 
END
 
 
 
DECLARE @OrderNum int, @Date datetime, @Qty int
EXEC proc_findProductInfo 63936, @SalesHeaderOut=@OrderNum OUTPUT,
        @OrderDate=@Date OUTPUT,
        @NumItems=@Qty OUTPUT
 
SELECT @OrderNum, @date, @Qty

/*6. 	Create a stored procedure that passes in the Territory Name as a parameter. This stored procedure will return 
the Territory Group, CountryRegionCode, Count of SalesHeaders in 2001, and the Count of SalesDetails in 2001*/
GO
CREATE PROC pro_TerGCountryRCountOrder
@TerritoryName VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON
	SELECT C.[Group], C.CountryRegionCode,  COUNT(A.SalesOrderID), COUNT(B.SalesOrderID)
	FROM[Sales].[SalesOrderHeader]           A
	INNER JOIN [Sales].[SalesOrderDetail]    B
	ON A.SalesOrderID=B.SalesOrderID
	INNER JOIN [Sales].[SalesTerritory]   C
	ON C.[TerritoryID]=A.TerritoryID
	WHERE DATEPART(YY,A.OrderDate) IN (2012) AND C.[Name] = @TerritoryName
	GROUP BY C.[Group], C.CountryRegionCode
END

EXEC pro_TerGCountryRCountOrder Northwest
/*7. 	Create a stored procedure that passes in the Product name as a parameter. This stored procedure will return the lowest
 price in History, Highest Price in History, difference between the two prices, Count of SalesDetails and the Sum of LineTotal.
 */ 
 GO
CREATE PROC proc_LowHighPriceDiff
 @ProductName VARCHAR(50)

AS
BEGIN
	SET NOCOUNT ON;
	SELECT [Name], MIN(A.ListPrice) AS LowPrice, MAX(A.ListPrice) AS HighPrice, (MAX(A.ListPrice) - MIN(A.ListPrice)) As DiffLowHigh
	FROM Production.ProductListPriceHistory A
	INNER JOIN Production.Product B
	ON  A.ProductID = B.ProductID
	WHERE [Name] = @ProductName
	GROUP BY [Name]
END
GO
EXEC proc_LowHighPriceDiff Chain
/*8.   Create a SP that passes in the OrderYear as a parameter. This stored procedure will return
 the Count of the SalesHeaders and SalesDetails for the OrderYear parameter.*/
  GO
CREATE PROC proc_SalesOrderCount
 @OrderYear INT

AS
BEGIN
	SET NOCOUNT ON;
 SELECT COUNT(B.SalesOrderID) AS SalesOrderIDCount, COUNT(A.SalesOrderDetailID) AS SalesOrderDetailIDCount
 FROM Sales.SalesOrderDetail A
 INNER JOIN Sales.SalesOrderHeader B 
 ON B.SalesOrderID = A.SalesOrderID
 WHERE YEAR(OrderDate) = @OrderYear
END
GO
EXEC proc_SalesOrderCount 2012