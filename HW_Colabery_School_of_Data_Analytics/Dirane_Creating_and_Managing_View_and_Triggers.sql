/*
Name: Ngala Dirane Ngiri
Lesson: Creating and Managing View and Triggers
Date: 04/09/2018
*/
 --a) Dept_triggers - add identity column (1000, 1) 
 CREATE TABLE [dbo].[Dept_trigger]( 
								[DeptID] [int] PRIMARY KEY IDENTITY (1000, 1) NOT NULL,
								[DeptName] [varchar](50) NULL 
								)
 --b) Emp_triggers - add identity column (1000, 1) 
 CREATE TABLE [dbo].[Emp_Triggers] (
								  [EmpID] [int] PRIMARY KEY IDENTITY (1000, 1) NOT NULL, 
								  [EmpName] [varchar](50) NULL, 
								  [DeptID] [int] NULL 
								  )
  
 --c) Emphistory
  CREATE TABLE EmpHistory ( 
						  empid INT NULL, 
						  deptid INT NULL, 
						  isactive INT NULL 
						  ) 
  GO

--2) Trigger
 --a) Build a trigger on the emp table after insert that adds a record into the emp_History 
 --table and marks IsActive column to 1 
 CREATE TRIGGER trgAfterInsert 
 ON [dbo].[Emp_Triggers] 
 FOR INSERT AS 
 DECLARE @EmpID INT; 
 DECLARE @DeptID INT ; 
 DECLARE @isactive VARCHAR(100); 
 SELECT @EmpID=i.EmpID FROM inserted i; 
 SELECT @DeptID=i.DeptID FROM inserted i; 
 SET @isactive= 1 
 INSERT INTO EmpHistory (EmpID,deptid, isactive) 
 VALUES(@empid,@deptid,@isactive); 
PRINT 'AFTER INSERT trigger fired.'
 GO

 --b) Build a trigger on the emp table after an update of the empname or deptid column 
 -- It updates the subsequent empname and/ or deptid in the emp_history table
CREATE TRIGGER dbo.trg_Updt_empnme 
ON [dbo].[emp]
AFTER UPDATE 
AS
IF UPDATE(deptid)
BEGIN
UPDATE [dbo].[Emphistory]
SET [dbo].[Emphistory].[DeptID] = i.[DeptID]
FROM [dbo].[Emphistory] 
JOIN inserted AS i
ON i.[DeptID] = [dbo].[Emphistory].[DeptID] 
JOIN deleted AS d
ON i.[DeptID] = d.[DeptID]
AND ( i.[DeptID] <> d.[DeptID]
OR d.[DeptID] IS NULL
) ;
END ; 
GO
  --c) Build a trigger on the emp table after delete that marks the isactive status = 0 in the emp_History table
CREATE TRIGGER trgAfterDelete ON [dbo].[emp_triggers] 
AFTER DELETE
AS
DECLARE @empid INT;
DECLARE @deptid INT;
DECLARE @isactive INT;

SELECT @empid=d.empid FROM deleted d;

SET   @isactive = 0


 INSERT INTO [dbo].[emphistory](empid, deptid, isactive)
SELECT empid, deptid, 0 FROM deleted ;

PRINT 'AFTER DELETE TRIGGER fired.'

DELETE 
FROM emp_triggers
WHERE empid = 1002

 --3) Run the script - Result should show 10 records in the emp history table all with an active status of 0 
INSERT INTO dbo.emp_triggers
SELECT 'Ali',1000
INSERT INTO dbo.emp_triggers
SELECT 'Buba',1000
INSERT INTO dbo.emp_triggers
SELECT 'Cat',1001
INSERT INTO dbo.emp_triggers
SELECT 'Doggy',1001
INSERT INTO dbo.emp_triggers
SELECT 'Elephant',1002
INSERT INTO dbo.emp_triggers
SELECT 'Fish',1002
INSERT INTO dbo.emp_triggers
SELECT 'George',1003
INSERT INTO dbo.emp_triggers
SELECT 'Mike',1003
INSERT INTO dbo.emp_triggers
SELECT 'Anand',1004
INSERT INTO dbo.emp_triggers
SELECT 'Kishan',1004
DELETE FROM dbo.emp_triggers
GO
--4) Create 5 views - Each view will use 3 tables and have 9 columns with 3 coming from each table
--a) Create a view using 3 Human resources Table (Utilize the where clause)
USE [AdventureWorks2016]
GO
CREATE VIEW Vw_HumanResourcesDetails 
AS 
SELECT h.[BusinessEntityID], e.[JobTitle], s.ShiftID 
FROM [HumanResources].[Employee] e 
LEFT OUTER JOIN [HumanResources].[EmployeeDepartmentHistory] h 
ON h.[BusinessEntityID] = h.BusinessEntityID 
LEFT OUTER JOIN [HumanResources].[Shift] s 
ON h.ShiftID = s.ShiftID 
WHERE h.BusinessEntityID BETWEEN 1 AND 10 
GO

--b) Create a view using 3 person tables (Utilize 3 system functions) 
CREATE VIEW Vw_Persondate 
AS 
SELECT YEAR(a.[ModifiedDate]) AS ModifiedYear, MONTH(c.[ModifiedDate]) AS ModifiedMonth, p.[StateProvinceID] 
FROM [Person].[BusinessEntityContact] c 
LEFT OUTER JOIN [Person].[BusinessEntityAddress] a 
ON a.BusinessEntityID = c.BusinessEntityID 
LEFT JOIN [Person].[Address] p 
ON p.AddressID = a.AddressID 
WHERE DAY(a.[ModifiedDate]) = 17 
GO

--c) Create view using 3 production Tables (Utilize Group By statement) 
CREATE VIEW Vw_ProductionDetails 
AS 
SELECT DISTINCT p.[Color], COUNT(w.[ProductID]) AS CountOfProductID, r.[ActualCost] 
FROM [Production].[Product] p 
LEFT OUTER JOIN [Production].[WorkOrder] w 
ON w.[ProductID] = p.[ProductID] 
LEFT OUTER JOIN [Production].[WorkOrderRouting] r 
ON w.[ProductID] = r.[ProductID] 
GROUP BY p.[Color], r.[ActualCost] 
GO

--d) Create a view using 3 Purchasing Tables (Utilize the having clause) 
CREATE VIEW Vw_PurchasingDetals 
AS 
SELECT v.[BusinessEntityID], SUM(d.[LineTotal]) AS SumOfLineTotal, p.[ProductID] 
FROM [Purchasing].[Vendor] v 
LEFT OUTER JOIN [Purchasing].[ProductVendor] p 
ON v.[BusinessEntityID] = p.[BusinessEntityID] 
LEFT OUTER JOIN [Purchasing].[PurchaseOrderDetail] d 
ON p.[ProductID] = d.[ProductID] 
GROUP BY v.[BusinessEntityID], p.[ProductID] 
HAVING SUM(d.[LineTotal]) > 20000 
GO

--e) Create a view using 3 sales Tables(Utilize the CASE statement)
CREATE VIEW Vw_SalesOderDateTest
AS
SELECT A.SalesOrderID, C.ModifiedDate

FROM Sales.SalesOrderHeader A
LEFT OUTER JOIN Sales.SalesOrderHeader B
ON A.SalesOrderID = B.SalesOrderID
LEFT OUTER JOIN Sales.SalesOrderHeaderSalesReason C
ON B.SalesOrderID = C.SalesOrderID
WHERE A.ModifiedDate =(
						CASE
							WHEN MONTH(A.ModifiedDate) <5 THEN '5 Months off'
							WHEN MONTH(B.ModifiedDate) = MONTH(B.DueDate) THEN 'Same Month'
							WHEN YEAR(C.ModifiedDate) = 2011 THEN 'in year 2011'
							ELSE 'Not applicable'
						END
						)