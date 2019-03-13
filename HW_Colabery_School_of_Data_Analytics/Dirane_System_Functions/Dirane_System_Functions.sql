/*Name: Ngala Dirane Ngiri
Lesson: System Functions
Date: 07/08/2018
*/
--Create 2 statement using each of the following functions.
--a.	LEN
SELECT LEN('SQLServer Functions');
SELECT LEN(CustName) 
	FROM dbo.Customer

--b.	LEFT
SELECT LEFT('SQL Dirane', 3) AS leftString;
SELECT LEFT(CustName, 5) AS leftString
	FROM Customer;

--c.	RIGHT
SELECT RIGHT('SQL Dirane', 3) AS rightString;
SELECT RIGHT(CustName, 5) AS rightString
	FROM Customer;

--d.	SUBSTRING
SELECT SUBSTRING('SQL lIVE', 1, 3) AS PartOfString;
SELECT SUBSTRING(CustName, 1, 5) AS PartOfString
FROM Customer;

--e.	CHARINDEX
SELECT CHARINDEX('t', 'Customer') AS MatchPosition;
SELECT CHARINDEX('A', CustName) AS MatchPosition
	FROM Customer;

--f.	LTRIM
SELECT LTRIM('     SQL Dirane') AS LeftTrimmedString;
SELECT LTRIM(   CustName) AS LeftTrimmedString
	FROM Customer;

--g.	RTRIM
SELECT RTRIM('     SQL Dirane') AS rightTrimmedString;
SELECT RTRIM(   CustName) AS rightTrimmedString
	FROM Customer;

--h.	DATEDIFF
SELECT DATEDIFF(year, '2017/08/25', '2011/08/25') AS DateDiff;
SELECT DATEDIFF(month, '2017/08/25', '2011/08/25') AS DateDiff;

--i.	DATEPART
SELECT DATEPART(year, '2017/08/25') AS DatePartInt;
SELECT DATEPART(month, EntryDate) AS DatePartInt
	FROM Customer;

--j.	DATEADD
SELECT DATEADD(year, 1, '2017/08/25') AS DateAdd;
SELECT DATEADD(month, 2, EntryDate) AS DateAdd
	FROM Customer;

--k.	CAST AND CONVERT
SELECT CAST(25.65 AS int);
SELECT CAST('2017-08-25' AS datetime);

SELECT CONVERT(int, 25.65);
SELECT CONVERT(varchar, 25.65);

--l.	ISDATE
SELECT ISDATE(EntryDate) as anything 
	FROM Customer;
SELECT ISDATE('Hello world!');

--m.	ISNULL
SELECT ISNULL(NULL, 'Colaberry.com');
SELECT ISNULL(NULL, 500);

--n.	ISNUMERIC
SELECT ISNUMERIC(4567);
SELECT ISNUMERIC('Hello world!');

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Loan]') AND type in (N'U'))
DROP TABLE [dbo].[Loan]

CREATE TABLE [dbo].[Loan](
	[LoanNumber] [int] IDENTITY(1000,1) NOT NULL,
	[CustomerFname] [varchar](50) NULL,
	[CustomerLname] [varchar](50) NULL,
	[PropertyAddress] [varchar](150) NULL,
	[City] [varchar](150) NULL,
	[State] [varchar](50) NULL,
	[BankruptcyAttorneyName] [varchar](50) NULL,
	[UPB] MONEY NULL,
	[LoanDate] [Datetime] NULL
 CONSTRAINT [PK_Loan] PRIMARY KEY CLUSTERED 
(
	[LoanNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

TRUNCATE TABLE dbo.Loan

INSERT INTO [dbo].[Loan]
           ([CustomerFname]
           ,[CustomerLname]
           ,[PropertyAddress]
           ,[City]
           ,[State]
           ,[BankruptcyAttorneyName]
		   ,[UPB]
		   ,[LoanDate])
SELECT	'Mr. Anand','Dasari','1212 Main St.','Plano','TX','Jerry',85000,'1/1/2012' UNION
SELECT	'Mr. John','Nasari','1215 Joseph St.','Garland','TX','Jerry',95000,'4/2/2012' UNION
SELECT	'Dr. Ali','Muwwakkil','2375 True True St.','Atlanta','GA','Diesel',115000,'5/3/2008' UNION
SELECT	'Mr. John','Brown','11532 Chain St.','SanFrancisco','CA','Mora',350000,'6/13/2004' UNION
SELECT	'Dr. Kishan','Johnson','4625 Miller Rd.','Atlanta','GA','Diesel',225000,'8/9/2002' UNION
SELECT	'Mr. John','Jackson','972 Flower Rd.','Dallas','TX','Jerry',150000,'3/1/2012' UNION
SELECT	'Sr. Ralph','Jenkins','1518 Mission Ridge St.','SanFrancisco','CA','Mora',650000,'12/15/2011' UNION
SELECT	'Dr. John','Howard','102 Washington','Dallas','TX','Jerry',450000,'4/5/2010' UNION
SELECT	'Mrs. Marsha','Tamrie','1301 Solana','SanFrancisco','CA','Mora',750000,'7/1/2000' UNION
SELECT	'Mrs. Alexis','Gibson','1111 Phillips Rd.','Atlanta','GA','Diesel',99000,'6/1/2012' 
        
SELECT * FROM [dbo].[Loan] 

/*7.	Write a SQL query to retrieve loan number, state, city, UPB and todays date for loans 
in the state of TX that have a UPB greater than $100,000 or loans that are in 
 the state of CA or FL that have a UPB greater than or equal to $500,000*/
 SELECT LoanNumber, State, City, UPB, GETDATE() AS todaysDate
	FROM dbo.Loan 
	WHERE (UPB > 100000 AND State = 'TX')
	OR (State IN ('CA', 'FL')
	AND UPB >= 500000)

/*8.	Write a SQL query to retrieve loan number, customer first name, customer last name,
 property address, and bankruptcy attorney name.  I want all the records that have the
  same attorney name to be together, then the customer last name in order from Z-A 
  (ex.Customer last name of Wyatt comes before customer last name of Anderson)*/
SELECT LoanNumber, CustomerFname, CustomerLname, PropertyAddress, BankruptcyAttorneyName
	FROM dbo.Loan
	ORDER BY BankruptcyAttorneyName, CustomerLname DESC

/*9.	Write a sql query to retrieve the loan number, state and city, customer first name 
for loans that are in the states of CA,TX,FL,NV,NM but exclude the following cities
 (Dallas, SanFrancisco, Oakland) and only return loans where customer first name begins
  with John.*/
SELECT LoanNumber, State, City, CustomerFname
	FROM dbo.Loan
	WHERE State IN ('CA', 'TX', 'FL', 'NV', 'NM')
	AND City NOT IN ('Dallas', 'SanFrancisco', 'Oakland') 
	AND CustomerFname LIKE '%John%'
	   
--10.	Find out how many days old each Loan is?
SELECT DATEDIFF(day, LoanDate,  GETDATE())
	FROM dbo.Loan

--11.	Find the State with the highest Avg UPB.

/*SELECT MAX (avg_upb)
	FROM (SELECT State, AVG(UPB) AS avg_upb
		FROM dbo.Loan
		GROUP BY State)*/
	
/*12.	Each Loan has a length of 30 years.  Retrieve
 the LoanNumber, Attorney Name and the anticipated 
 Finish Date of the Loan.*/
SELECT LoanNumber, BankruptcyAttorneyName, DATEADD(year,30, LoanDate) 
	AS anticipatedFinishDate
	FROM dbo.Loan

/*13.	The Title of the Customer is Located
 in the CustomerFname Column.  Separate the title into its own column
  and also retrieve CustomerFname, CustomerLname, City, State and LoanDate
   of Loans that are more than 1 yr old.*/
SELECT CustomerFname, CustomerLname, City, State, LoanDate, LEFT(CustomerFname, 3)
	AS title
	FROM dbo.Loan 
	WHERE DATEDIFF(year, LoanDate, GETDATE()) > 1