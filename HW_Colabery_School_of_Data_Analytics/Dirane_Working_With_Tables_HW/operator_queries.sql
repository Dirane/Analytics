/*
Write two statements for each of the following operators using the emp
and dept tables. Be sure to include AND &amp; OR statements as well.
OPERATORS:
= (equals)
<> (not equal to)
> (greater than)
< (less than)
in
not in
LIKE
between
not LIKE
*/

USE [july_14_online]
GO
--Using less than = operator for emp table
SELECT [empid]
      ,[empname]
  FROM [dbo].[emp]
  WHERE [empid] = 3

--Using less than = operator for dept table
SELECT [deptid]
      ,[deptname]
  FROM [dbo].[dept]
  WHERE [deptid] = 6

  --Using the <> (not equal to) and the AND operato on emp table
  SELECT [empid]
		,[empname]
	FROM [dbo].[emp]
	WHERE [empname] <> 'Alex' AND [empname] <> 'Ali'

--Using the <> (not equal to) and the AND operato on emp table
  SELECT [deptid]
		,[deptname]
	FROM [dbo].[dept]
	WHERE [deptname] <> 'Design' AND [deptname] <> 'Testing'

--Using less than (<), greater than (>) with the OR operator for emp table
SELECT [empid]
      ,[empname]
  FROM [dbo].[emp]
  WHERE [empid] < 5 OR [empid]>5
 --Using less than (<), greater than (>) with the OR operator for dept table
 SELECT [deptid]
      ,[deptname]
  FROM [dbo].[dept]
  WHERE [deptid] < 5 OR [deptid]>5

--Using the in operator on emp table
SELECT [empid]
	  ,[empname]
  FROM [dbo].[emp]
  WHERE [empid] IN (7,8,9)

--Using the in operator on dept table
SELECT [deptid]
	  ,[deptname]
  FROM [dbo].[dept]
  WHERE [deptname] IN ('Human Resource','Finance','Management')

--Using the not in operator on emp table
SELECT [empid]
	  ,[deptid]
  FROM [dbo].[emp]
  WHERE [deptid] NOT IN (1,2,3,4,5)

--Using the not in operator on dept table
SELECT [deptid]
	  ,[deptname]
  FROM [dbo].[dept]
  WHERE [deptid] NOT IN (1,2,3,4,5)

--Using the LIKE Operator on emp table
SELECT [empid]
	  ,[empname]
  FROM [dbo].[emp]
  WHERE [empname] LIKE '%Jo%'

--Using the LIKE Operator on dept table
SELECT [deptid]
	  ,[deptname]
  FROM [dbo].[dept]
  WHERE [deptname] LIKE '%Hu%' OR [deptname] LIKE '%ing%'

--Using the keyword BETWEEN on the emp table
SELECT [empid]
	  ,[empname]
  FROM [dbo].[emp]
  WHERE [deptid] BETWEEN 5 AND 8

--Usint the BETWEEN Operator on the dept table
SELECT [deptid]
	  ,[deptname]
  FROM [dbo].[dept]
  WHERE [deptname] BETWEEN 'Design' AND 'Management'

--Using the NOT LIKE operator on emp table
SELECT [empid]
	  ,[empname]
	  ,[deptid]
  FROM [dbo].[emp]
  WHERE [empname] NOT LIKE 'A%'

--Using the NOT LIKE operator on dept table
SELECT [deptid]
	  ,[deptname]
  FROM [dbo].[dept]
  WHERE [deptid] NOT LIKE '%ing'


  /*I.	CREATE the following 2 tables – 
a.	Create the players Table using Right Click – New Table
b.	Create the coaches Table using a CREATE Table Statement
*/
CREATE TABLE [dbo].[Players](
	[PlayerID] [int] NULL,
	[Position] [varchar](50) NULL,
	[JerseyNumber] [int] NULL,
	[StartDate] [datetime] NULL
	)
CREATE TABLE Coaches (
					  CoacheID int null,
					  CoacheName varchar(50) null,
					  CoachType varchar(50) null,
					  StartDate datetime null
					  )

/*
USE the following Statements to enter 1 record into the Players & Coaches Table
*/ 
INSERT INTO [dbo].[Players]
VALUES (1,'Running Back',22,'1/1/2012')

INSERT INTO	[dbo].[Coaches] 
VALUES (1,'John Starks','Running Back Coach','1/1/2012')

--INSERT  10 More Records into each table and answer the following Questions.  
INSERT INTO [dbo].[Players]
VALUES (2,'Running Back',20,'1/1/2017'),
		(3,'Running Back',10,'1/1/2018'),
		(4,'Running Back',16,'1/1/2017'),
		(5,'Running Back',01,'1/1/2018'),
		(6,'Running Back',25,'1/1/2015'),
		(7,'Running Back',05,'1/1/2013'),
		(8,'Running Back',22,'1/1/2011'),
		(9,'Running Back',11,'1/1/2017'),
		(10,'Running Back',20,'1/1/2014')

INSERT INTO	[dbo].[Coaches] 
VALUES (2,'Jonathan Smith','Quater Back Coach','1/1/2014'),
		(3,'Paul Alice','Running Back Coach','1/1/2015'),
		(4,'Fred Stus','Quater Back Coach','1/1/2016'),
		(5,'Dirane Stars','Running Back Coach','1/1/2017'),
		(6,'Ino Afayi', 'Quater Back Coach','1/1/2018'),
		(7,'Margret Tasha','Running Back Coach','1/1/2013'),
		(8,'Nelson Sky','Quater Back Coach','1/1/2010'),
		(9,'Peter Sons','Running Back Coach','1/1/2015'),
		(10,'Clark Marie','Quater Back Coach','1/1/2018')

--Retrieve All Players with Jersey numbers in the 20’s
SELECT *
  FROM Players
  WHERE JerseyNumber = 20

--Retrieve All Coaches with CoachID less than 5
SELECT *
  FROM Coaches
  WHERE CoacheID < 5

--Retrieve All players who joined the team this year.
SELECT *
  FROM Players
  WHERE StartDate ='1/1/2018'

--Retrieve All coaches who joined the team last year.
SELECT * 
  FROM Coaches
  WHERE startDate = '1/1/2017'

--Retrieve All players with PlayerID greater than 5
SELECT *
  FROM Players
  WHERE PlayerID > 5

--Retrieve All running backs
SELECT *
  FROM Players
  WHERE Position = 'Running Back'

--Retrieve All Quarter Back Coaches
SELECT * 
  FROM Coaches
  WHERE CoachType = 'Quater Back Coach'

--  Create a player backup table (player_backup) using the SELECT INTO statement
SELECT * INTO Player_Backup
FROM Players
  --Create a coach backup table (coach_backup) using the SELECT INTO statement
SELECT * INTO Coach_Backup
  FROM Coaches


