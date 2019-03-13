/*Name: Ngala Dirane Ngiri
Lesson: Constraints
Date: 01/08/2018
*/
USE [july_14_online]

CREATE TABLE [dbo].[Customer](
	[CustID] [int] NULL,
	[CustName] [varchar](50) NULL,
	[EntryDate] [datetime] NULL
) 

CREATE TABLE [dbo].[SalesReps](
	[RepID] [int] NULL,
	[RepName] [varchar](50) NULL,
	[HireDate] [datetime] NULL
) 

CREATE TABLE [dbo].[Sales](
	[SalesID] [int] NULL,
	[CustID] [int] NULL,
	[RepID] [int] NULL,
	[SalesDate] [datetime] NULL,
	[UnitCount] [int] NULL,
	[VerificationCode] [varchar](50) NULL
) 

--1.	Create Primary Keys on all 3 tables
--Done!

/*2.	All 3 tables should have IDENTITY columns as the PRIMARY KEY’s. 
 They must start at 100 and increment by 2.*/
 --Done!

--3.	Create a Unique Key on dbo.Sales.VerficationCode
ALTER TABLE [dbo].[Sales]
ADD CONSTRAINT uc_VerificationCode
UNIQUE (VerificationCode)

--4.	Create a relationship between the Customer / SalesRep & the Sales Table
--Done!

--5.	No nulls will be allowed in the following tables.columns
--a.	dbo.Sales.SalesDate
--Done!

--b.	dbo.Sales.VerificationCode
--Done!
--6.	The following tables.columns will default to GetDate() if no Date is given.
--a.	Dbo.Customer.EntryDate
--Done!

--b.	Dbo.SalesRep.HireDate
--Done!

--c.	Dbo.Sales.SalesDate
--Done!
--7.	dbo.Sales.UnitCount should not allow NULLS or Zero’s
--Done!

--8.	Run the following script to ensure the Constraints have been added correctly

INSERT INTO dbo.Customer (CustName)
SELECT  'Ali' UNION
SELECT  'Anand' UNION
SELECT  'Alex' UNION
SELECT  'Jack' UNION
SELECT  'Nina' UNION
SELECT  'Joel' UNION
SELECT  'Keon' UNION
SELECT  'James' UNION
SELECT  'Mike' UNION
SELECT  'Sai' UNION
SELECT  'Terry'

INSERT INTO dbo.SalesReps (RepName)
SELECT  'Joseph' UNION
SELECT  'Jermaine' UNION
SELECT  'Marshall' UNION
SELECT  'Marvin' UNION
SELECT  'Mitchell' UNION
SELECT  'Johnson' UNION
SELECT  'Robert' UNION
SELECT  'Rachel' UNION
SELECT  'Rene' UNION
SELECT  'Brandy'UNION
SELECT  'Dirk'

INSERT INTO dbo.Sales (CustID, RepID,UnitCount,VerificationCode)
SELECT	100,120,1,'Ver01' UNION
SELECT	102,118,2,'Ver02' UNION
SELECT	104,116,3,'Ver03' UNION
SELECT	106,114,4,'Ver04' UNION
SELECT	108,112,5,'Ver05' UNION
SELECT	110,110,1,'Ver06' UNION
SELECT	112,108,2,'Ver07' UNION
SELECT	114,106,3,'Ver08' UNION
SELECT	116,104,4,'Ver09' UNION
SELECT	118,102,5,'Ver10' UNION
SELECT	120,100,6,'Ver11'




