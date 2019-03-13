/*
Name:	Ngala Dirane
Lesson:	SQL Review
Date:	07/09/2018
*/
--1.	What does the acronym T-SQL stand for?
Transact - Structured Query Language

--2.	What keyword in a SQL query do you use to extract data from a database table?
SELECT

--3.	What keyword in a SQL query do you use to modify data from a database table?
UPDATE

--4.	What keyword in a SQL query do you use to add data from a database table?
INSERT INTO

--5.	What is the difference between the following joins?
--a.	Left Join
Returns ALL the values from the left table, along with MATCHED values from the right table.
Returns Null for the right table if there are no matches.

--b.	Inner Join
Returns all records from two tables where the join condition is met.

--c.	Right Join
Returns ALL the values from the right table, along with MACTCHED values from the left table.
Returns Null for the left table if there are no matches

--6.	What is the difference between a table and a view?
A table is a preliminary storage for storing data and information in RDMS.
A table is a collection of related data entries and it consists of columns and rows.

While

A view is a virtual table whose contents are defined b a query.
Unless indexed, a view does not exists as a stored se of data values in a database.

--7.	What is the difference between a temporary and variable table?
Temporary tables can be changed after creation using DDL statements while 
Table variables does not support DDL statements such as ALTER, CREATE, DROP, etc.

Temporary tables are not allowed in User Defined Functions while
Table variables can be used in User Deifined Functions

Temporary tables are stored in tempdb database of SQL server. While,
Table variables are stored in both the memory and the disk in the tempdb

There are two types of temporary tables. Local temporary tables which are only
available for the executing session and Global temporary tables which are available
until the last session is terminated. While
Table variables can be declared in batch or stored procedure and can not be dropped 
explicitly, are dropped automatically once the batch is finished.

/*Example 1.0:
TableA	TableB
Field1	Field1
1		2
2		5
3		7
4		6
4		3
5		3
6		9

      Write SQL queries below based on table layout in Example 1.0.
8.	Display data from TableA where the values are identical in TableB.*/
SELECT A.Field1
FROM TableA A
INNER JOIN TableB B
ON A.Field1 = B.TableB


--9.	Display data from TableA where the values are not available in TableB.
SELECT A.Field1
FROM TableA A
RIGHT OUTER JOIN TableB
ON A.Field1 = B.Field1	
				

--10.	Display data from TableB where the values are not available in TableA.
SELECT B.Field1
FROM TableA B
RIGHT OUTER JOIN TableA A
ON B.Field1 = A.Field1

--11.	Display unique values from TableA.
SELECT DISTINCT *
FROM TableA

12.	Display the total number of records, per unique value, in TableA.
SELECT DISTINCT COUNT(*) AS NumOfRecords
FROM TableA

--13.	Display the unique value from TableB where it occurs more than once.
SELECT COUNT(*) AS CountMoreThanOnce, Field1
FROM TableB
GROUP BY Field1
HAVING COUNT(*)>1

--14.	Display the greatest value from TableB.
SELECT MAX(Field1)
FROM TableB

--15.	Display the smallest value from TableA.
SELECT MIN(Field1)
FROM TableA

/*Example 1.0 complete. Next page will be used to test your abilities with data manipulation.
16.	Write a SQL statement to create a variable called Variable1 that can handle the value such as 
“Welcome to planet earth”.*/
DECLARE @Variable1 TEXT
SET @Variable1 = 'Welcome to planet earth'; 
GO

/*17.	Write a SQL statement that constructs a table called Table1 with the following fields:
a.	Field1 – this field stores numbers such as 1, 2, 3 etc.
b.	Field2 – this field stores the date and time.
c.	Field3 – this field stores the text up to 500 characters.*/
CREATE TABLE [dbo].[Table1] (
			Field1 INT,
			Field2 DATETIME,
			Field3 VARCHAR(500)
			)

/*18.	Write a SQL statement that adds the following records to Table1:
Field1	Field2	Field3
34	1/19/2012 08:00 AM	Mars Saturn
65	2/15/2012 10:30 AM	Big Bright Sun
89	3/31/2012 09:15 PM	Red Hot Mercury*/
INSERT INTO [Table1]
VALUES(34,'1/19/2012 08:00','Mars Saturn'),
	  (65,'2/15/2012 10:30','Big Bright Sun'),
	  (89,'3/31/2012 09:15','Red Hot Mercury')

/*19.	Write a SQL statement to change the value for Field3 in Table1 to the value stored in Variable1 
(From question 16), on the record that is 34.*/
DECLARE @Variable1 TEXT
UPDATE [dbo].[Table1]
SET [Field3] = @Variable1
WHERE [Field1] = 34

--20.	Write a SQL statement for record 89 to return the total number of characters for Field3.
SELECT LEN([Field3])
FROM [Table1]
WHERE [Field1] = 89

--21.	Write a SQL statement for record 65 to return the first occurrence of a space in Field3.
SELECT CHARINDEX(' ', [Field3]) 
FROM [dbo].[Table1] 
WHERE [Field1] = 65

--22.	Write a SQL statement for record 65 to return the value “Bright” from Field3.
SELECT SUBSTRING([Field3], 5, 6) 
FROM [dbo].[Table1] 
WHERE [Field1] = 65

--23.	Write a SQL statement for record 34 to return the day from the Field2.
SELECT DATEPART(DD, [Field2]) 
FROM [dbo].[Table1] 
WHERE [Field1] = 34

--24.	Write a SQL statement for record 34 to return the first day of the month from the Field2.
SELECT DATEADD(MM, DATEDIFF(MM,0, [Field2]), 0) 
FROM [dbo].[Table1] 
WHERE [Field1] = 34

--25.	Write a SQL statement for record 34 to return the previous end of the month from the Field2.
SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,[Field2]),0)) 
FROM [dbo].[Table1] 
WHERE [Field1] = 34

--26.	Write a SQL statement for record 34 to return the day of the week from the Field2.
SELECT DATENAME(DW, [Field2]) AS WEEKDAY 
FROM [dbo].[Table1] 
WHERE [Field1] = 34

--27.	Write a SQL statement for record 34 to return the date as CCYYMMDD from the Field2.
SELECT CONVERT(char(8), [Field2], 112) 
FROM [dbo].[Table1] 
WHERE [Field1] = 34

--28.	Write a SQL statement to add a new column, Field4 (data type can be of any preference), to Table1.
ALTER TABLE [dbo].[Table1] 
ADD Field4 varchar(50)
--29.	Write a SQL statement to remove record 65 from Table1.
DELETE [dbo].[Table1] WHERE [Field1] = 65
--30.	Write a SQL statement to wipe out all records in Table1.
DELETE [dbo].[Table1]
31.	Write a SQL statement to remove Table1.
DROP TABLE [dbo].Table1
/*32.  Create a sql statement that returns the TerritoryName,  SalesPerson (LastName Only) ship method, credit card type 
(If no credit card, it should say cash), OrderDate and TotalDue for ALL Transactions  in the NorthWest Territory.*/  
USE [AdventureWorks2016]
SELECT  
       st.Name Territoryname,
       pp.LastName SalesPerson,
       ps.Name ShipMethod,
       CASE WHEN sc.CardType='Distinguish' THEN 'Cash' ELSE sc.CardType END AS CreditCardType,
       soh.OrderDate,
       soh.TotalDue
FROM    Sales.SalesOrderHeader soh
INNER JOIN    Person.Person pp 
ON      soh.SalesPersonID=pp.BusinessEntityID
INNER JOIN    Purchasing.ShipMethod ps 
ON      ps.ShipMethodID=soh.ShipMethodID
INNER JOIN    Sales.CreditCard sc 
ON      sc.CreditCardID=soh.CreditCardID
INNER JOIN    Sales.SalesTerritory st 
ON      st.TerritoryID=soh.TerritoryID
WHERE st.Name = 'Northwest'