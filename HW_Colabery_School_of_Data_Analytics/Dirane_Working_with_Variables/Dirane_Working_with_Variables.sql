/*Name: Ngala Dirane Ngiri
Lesson: Working with Variables
Date: 09/08/2018*/


--1. Created dbo.Flights Table
USE [july_14_online]
GO

CREATE TABLE [dbo].[Flights](
	[FlightID] [int] IDENTITY(100,1) NOT NULL,
	[FlightDateTime] [datetime] NULL,
	[FlightDepartureCity] [varchar](50) NULL,
	[FlightDestinationCity] [varchar](50) NULL,
	[Ontime] [int] NULL,
 CONSTRAINT [PK_dbo.Flights] PRIMARY KEY CLUSTERED 
(
	[FlightID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--2.	 Run the following script to Insert Data into the table.
INSERT	INTO dbo.Flights (FlightDateTime, FlightDepartureCity, FlightDestinationCity, Ontime)
SELECT '1/1/2012','Dallas-Texas','L.A.',1  UNION
SELECT '1/2/2012','Austin-Texas','New York',1  UNION
SELECT '1/3/2012','Houston-Texas','New Jersy',0  UNION
SELECT '1/4/2012','San Antonio-Texas','Mesquite',1  UNION
SELECT '1/5/2012','Lewisville-Texas','Albany',0  UNION
SELECT '1/6/2012','Orlando-Florida','Atlanta',1  UNION
SELECT '1/7/2012','Chicago-Illinois','Oklahoma City',1  UNION
SELECT '1/8/2012','New Orleans-Louisiana','Memphis',0  UNION
SELECT '1/9/2012','Miami-Florida','Charlotte',1  UNION
SELECT '1/10/2012','Sacramento-California','San Francisco',1

--3.	Create and set a Variable equal to the number of Flights that were late.
DECLARE @LateFlights INT
SELECT @LateFlights = COUNT(FlightID) FROM dbo.Flights WHERE Ontime = 0


/*4.	Multiply that amount by the amount lost per late flight ($1,029)
 and store the amount in another variable.*/
DECLARE @AmountLost MONEY = 1029,
		@TotalAmountLost MONEY
SET @TotalAmountLost = @LateFlights * @AmountLost


/*5.	Take the total amount lost (#4) and subtract it from Total profit ($45,000)
 and store that number in a variable.*/
DECLARE @TotalProfit MONEY = 45000,
		@AmountLeft MONEY
SET @AmountLeft = @TotalProfit - @TotalAmountLost


--6.	Find out the Earliest FlightDate and add 10 years to it and store it in a variable.
DECLARE @EarliestFlightDate DATETIME
SELECT @EarliestFlightDate = MIN(FlightDateTime) FROM dbo.Flights 
SET @EarliestFlightdate = DATEADD(year, 10, @EarliestFlightDate)


--7.	Find out the day of the week for the Latest FlightDate and store it in a variable.
DECLARE @DayOfWeek DATETIME,
		@Day INT
SELECT @DayOfWeek = MAX(FlightDateTime) FROM dbo.Flights
SET @Day = DAY(@DayOfWeek)


/*8.	Create a table variable with Departure City and State 
in 2 different columns along with Flight Destination City and Ontime.*/
DECLARE @NewFlightsTable TABLE (
								DepartureCity VARCHAR(50), State VARCHAR(50), 
								FlightDestinationCity VARCHAR(50), Ontime DATETIME
								)
SELECT * FROM @NewFlightsTable

/*9.	Create a Table Variable storing all info from the dbo.Flights table of
 flights that were on time.*/
 DECLARE @FlightsOntime TABLE (
								FlightID INT, FlightDate DATETIME, 
								FlightDepartureCity VARCHAR(50),
								FlightDestinationCity VARCHAR(50),
								Ontime int
								)
INSERT INTO @FlightsOntime
SELECT * FROM dbo.FlightS WHERE Ontime = 1
 

/*10.	Create a Table Variable storing all info from the dbo.
Flights table of non Texas Flights.Run the following Script*/
DECLARE @NonTexasFlights TABLE (
								FlightID INT, FlightDate DATETIME, 
								FlightDepartureCity VARCHAR(50),
								FlightDestinationCity VARCHAR(50),
								Ontime int
								)
INSERT INTO @NonTexasFlights
SELECT * FROM dbo.FlightS WHERE  FlightDepartureCity NOT LIKE '%Texas'


CREATE TABLE [dbo].[HospitalStaff](
	[EmpID] [int] IDENTITY(1000,1) NOT NULL,
	[NameJob] [varchar](50) NULL,
	[HireDate] [datetime] NULL,
	[Location] [varchar](150) NULL,
 CONSTRAINT [PK_HospitalStaff] PRIMARY KEY CLUSTERED 
(
	[EmpID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

INSERT INTO [dbo].[HospitalStaff] ([NameJob],[HireDate],[Location])
SELECT		'Dr. Johnson_Doctor'	,'1/1/2012',	'Dallas-Texas' UNION
SELECT		'Nurse Jackie_Nurse'	,'10/15/2011',	'Mesquite-Texas' UNION
SELECT		'Anne_Nurse Assistant'	,'11/1/2010',	'Denton-Texas' UNION
SELECT		'Dr. Jackson_Doctor'	,'4/2/2008',	'Irving-Texas' UNION
SELECT		'Jamie_Nurse'			,'2/15/2005',	'San Francisco-California' UNION
SELECT		'Aesha_Nurse Assistant'	,'6/30/2003',	'Oakland-California' UNION
SELECT		'Dr. Ali_Doctor'		,'7/4/1999',	'L.A.-California' UNION
SELECT		'Evelyn_Nurse'			,'1/7/2007',	'Fresno-California' UNION
SELECT		'James Worthy_Nurse Assistant'	,'1/1/2012',	'Orlando-Florida' UNION
SELECT		'Anand_Doctor'			,'3/1/2012',	'Miami-Florida'


SELECT		*
FROM		dbo.HospitalStaff

/*11.	Create a Variable to store how many employees have been 
employed with the company for more than 3 years.*/
DECLARE @employees INT
SELECT @employees = COUNT(EmpID) 
		FROM dbo.HospitalStaff 
		WHERE DATEDIFF(year,HireDate, GETDATE()) > 3
--PRINT @employees

--12.	Create and populate a Variable to store the number of all employees from Texas
DECLARE @employeesFromTexas INT
SELECT @employeesFromTexas = COUNT(EmpID) 
		FROM dbo.HospitalStaff 
		WHERE Location LIKE '%Texas'
--PRINT @employeesFromTexas

--13.	Create and populate a Variable to store the number of Doctor’s from Texas
DECLARE @DoctorsFromTexas INT
SELECT @DoctorsFromTexas = COUNT(EmpID) 
		FROM dbo.HospitalStaff 
		WHERE NameJob LIKE '%Doctor' AND Location LIKE '%Texas'
PRINT @DoctorsFromTexas

/*14.	Create a table variable using data in the dbo.HospitalStaff 
table with the following 4 columns
a.	Name – Located in the NameJob Column : Everything before the _
b.	Job – Located in the NameJob Column : Everything after the _
c.	HireDate
d.	City – Located in the Location Column : Everything before the –
e.	State – Located in the Location Column : Everyting after the –
*/
DECLARE @NewHospitalStaffTable TABLE (
										Name VARCHAR(50),
										Job VARCHAR(50),
										HireDate DATETIME,
										City VARCHAR(50),
										State VARCHAR(50)
									)
INSERT INTO @NewHospitalStaffTable
SELECT 'Aesha','Nurse Assistant', '6/30/2003', 'Oakland', 'California' UNION
SELECT 'Anand', 'Doctor', '03/01/2012', 'Mami', 'Florida' UNION
SELECT 'Anne', 'Nurse Assistant', ' 11/01/2010', 'Dention', 'Texas' UNION
SELECT 'Dr.Ali', 'Doctor', '07/04/1999', 'L.A', 'California' UNION
SELECT 'Dr.Jackson', 'Doctor', '04/02/2008', 'Inving', 'Texas' UNION
SELECT 'Dr.Johnson', 'Doctor', '01/01/2012', 'Dallas', 'Texas' UNION
SELECT 'Evelyn', 'Nurse', '01/07/2007', 'Fresno', 'California' UNION
SELECT 'James Worthy', 'Nurse Assistant', '01/01/2012', 'Orlando', 'Florida' UNION
SELECT 'Jamie', 'Nurse', '02/15/2005', 'San Fransisco', 'California' UNION
SELECT 'Nurse Jackie', 'Nurse', '10/15/2011', 'Mesquite', 'Texas'
--SELECT * FROM @NewHospitalStaffTable

/*
15.	Create a Table Variable using data in the dbo.HospitalStaff 
table with the following 4 columns
a.	NameJob
b.	DateYear – The Year of the HireDate
c.	DateMonth – The Month of the HireDate
d.	DateDay – The Day of the HireDate 
*/
DECLARE @HospitalStaffDate TABLE (
									NameJob VARCHAR(50),
									DateYear INT,
									DateMonth INT,
									DateDay INT
								)
INSERT INTO @HospitalStaffDate
SELECT NameJob, YEAR(HireDate), MONTH(HireDate), Day(HireDate) 
	FROM dbo.HospitalStaff
--SELECT * from @HospitalStaffDate


