 /*Name: Ngala Dirane Ngiri
Lesson: User Defined Functions
Date: 12/08/2018
*/
 --Use the HumanResources.Employee Table in the Adventureworks Database 
 /*1.	 Create a UDF that accepts EmployeeID (2012: BusinessEntityID) and 
returns UserLoginID.  The UserLoginID is the last part of the LogID column.
  It’s only the part that comes after the \*/
  -- ============================================= 
  -- Author: Ngala Dirane Ngiri
  -- Create date: 12/08/2018 
  -- Description: Used to get the UserLoginID from the last part of the LoginID column using BusinessEntityId Parameter 
  -- =============================================
  GO
DROP FUNCTION Fx_GetUserLoginID 
  GO
CREATE FUNCTION Fx_GetUserLoginID
				( @BusinessEntityID INT)
								
RETURNS NVARCHAR(50)
AS
BEGIN 
	DECLARE @UserID NVARCHAR(50)
	SET @UserID = (
			SELECT RIGHT(loginID, LEN(LoginID) - CHARINDEX('\', LoginID)) AS UserLoginID
			FROM HumanResources.Employee 
			WHERE BusinessEntityID = @BusinessEntityID
			)
	RETURN @UserID
END
GO
--SELECT dbo.Fx_GetUserLoginID(10)

/*2.	Create a UDF that accepts EmployeeID (2012: BusinessEntityID) and 
returns their age.*/
 -- ============================================= 
  -- Author: Ngala Dirane Ngiri
  -- Create date: 12/08/2018 
  -- Description: Used to get the age of employees using BusinessEntityId Parameter 
  -- =============================================
DROP FUNCTION Fx_GetAge 
GO
CREATE FUNCTION Fx_GetAge
					(@BusinessEntityID INT)
RETURNS INT
AS
BEGIN
	DECLARE @Age INT
	SET @Age= (
		SELECT DATEDIFF(YEAR,BirthDate,GetDate()) AS Age
		FROM HumanResources.Employee
		WHERE BusinessEntityID = @BusinessEntityID
			)
	RETURN @Age
END
GO
--SELECT dbo.Fx_GetAge(1)

--3.	Create a UDF that accepts the Gender and returns the avg VacationHours
 -- ============================================= 
  -- Author: Ngala Dirane Ngiri
  -- Create date: 12/08/2018 
  -- Description: Used to get the average working hours using gender Parameter 
  -- =============================================
DROP FUNCTION Fx_AvgVacationHours
GO
CREATE FUNCTION Fx_AvgVacationHours
				(@Gender CHAR)
RETURNS INT
AS
BEGIN
	DECLARE @AvgVHours INT
	SET @AvgVHours = (
				SELECT AVG(VacationHours) AS AverageVacationHours
				FROM HumanResources.Employee
				WHERE Gender = @Gender
				)
	RETURN @AvgVHours
END
GO
--SELECT dbo.Fx_AvgVacationHours('F')

/*4.	Create a UDF that accepts ManagerID (2012: JobTitle) and returns all of
 that Managers (2012: JobTitle)  Employee Information.
a.	LoginID
b.	Gender
c.	HireDate*/
 -- ============================================= 
  -- Author: Ngala Dirane Ngiri
  -- Create date: 12/08/2018 
  -- Description: Used to get the LoginID, Gender and HireDate using ManagerID(Jobtitle) of an employee
  -- =============================================
DROP FUNCTION Fx_GetEmployeeInformation
GO
CREATE FUNCTION Fx_GetEmployeeInformation
				(@ManagerID VARCHAR(50))
RETURNS TABLE
AS
RETURN
	SELECT LoginID, Gender, HireDate
	FROM HumanResources.Employee
	WHERE JobTitle = @ManagerID
GO
--SELECT * FROM Fx_GetEmployeeInformation('Chief Executive Officer')



