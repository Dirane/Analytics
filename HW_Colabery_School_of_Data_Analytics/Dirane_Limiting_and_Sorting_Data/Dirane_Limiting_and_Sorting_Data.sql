/*Name: Ngala Dirane Ngiri
Lesson: Limiting and Sorting Data Lab
Date: 04/08/2018
*/

--2.	 Run the following script to populate the table 
INSERT INTO dbo.Menu
SELECT		'Big Mac','Hamburger',1.25,3.24,1015,5000,15853
union
SELECT		'Quarter Pounder / Cheese','Hamburger',1.15,3.24,1000,4589,16095
union
SELECT		'Half Pounder / Cheese','Hamburger',1.35,3.50,500,3500,12589
union
SELECT		'Whopper','Hamburger',1.55,3.99,989,4253,13000
union
SELECT		'Kobe Cheeseburger','Hamburger',2.25,5.25,350,1500,5000
union
SELECT		'Grilled Stuffed Burrito','Burrito',.75,5.00,2000,7528,17896
union
SELECT		'Bean Burrito','Burrito',.50,1.00,1750,7000,18853
union
SELECT		'7 layer Burrito','Burrito',.78,2.50,350,1000,2563
union
SELECT		'Dorrito Burrito','Burrito',.85,1.50,600,2052,9857
union
SELECT		'Turkey and Cheese Sub','Sub Sandwich',1.75,5.50,1115,7878,16853
union
SELECT		'Philly Cheese Steak Sub','Sub Sandwich',2.50,6.00,726,2785,8000
union
SELECT		'Tuna Sub','Sub Sandwich',1.25,4.50,825,3214,13523
union
SELECT		'Meatball Sub','Sub Sandwich',1.95,6.50,987,4023,15287
union
SELECT		'Italian Sub','Sub Sandwich',2.25,7.00,625,1253,11111
union
SELECT		'3 Cheese Sub','Sub Sandwich',.25,6.00,815,3000,11853

/*
3.	Before we starting updating and deleting, we want to do everything
 on a backup copy of the table.  Create a dbo.menu_backup using the 
 SELECT INTO Statement. 
*/
SELECT * INTO dbo.menu_backup
	FROM dbO.Menu

--4.	The 3 Cheese Sub is now made with 4 Cheeses.  The new name will be 4 Cheese Sub
UPDATE dbo.menu_backup
	SET ItemName = '4 Cheese Sub'
	WHERE ItemName = '3 Cheese Sub'
	
--5.	Italian Sub Monthly Sales were reported incorrectly.  There were really 1353 Sales.
UPDATE dbo.menu_backup
	SET MonthlySales = 1353
	WHERE ItemName = 'Italian Sub'
	select * from dbo.menu_backup
--6.	The Whopper increased it’s price to $4.25
UPDATE dbo.menu_backup
	SET Price = 4.25
	WHERE ItemName = 'Whopper'

--7.	It now cost $2.75 to make the 7 layer Burrito
UPDATE dbo.menu_backup
	SET CostToMake = 2.75
	WHERE ItemName = '7layer Burrito'

--8.	The prices of tortillas have gone up.  All Burrito prices should increase 10%
UPDATE dbo.menu_backup
	SET Price = Price + (10/100)
	WHERE ItemType = 'Burrito'
		
--9.	All products that bring in  < $1.00 profit per purchase need to be deleted
DELETE FROM dbo.menu_backup
WHERE Price - CostToMake < 1.00

/*10.	We will be discontinuing any products that didn’t clear $10,000 
in YearlySales Profit. (delete)*/
DELETE FROM dbo.menu_backup
WHERE YearlySales < 10000

/*11.	We just found out all the previous changes were incorrect. 
 Truncate the dbo.menu_backup table.*/
 TRUNCATE TABLE dbo.menu_backup

--3.	Retrieve  all Burritos and sort by Price
SELECT * 
	FROM dbo.Menu
	WHERE ItemType = 'Burrito'
	ORDER BY Price 
	
--4.	Retrieve all items that Cost more than $1.00 to make and sort by WeeklySales
SELECT * 
	FROM dbo.Menu
	WHERE CostToMake > 1.00
	ORDER BY WeeklySales 

--5.	What’s the sum of total profit by ItemType
SELECT ItemType, SUM(Price - CostToMake) AS Profit
	FROM dbo.Menu
	GROUP BY ItemType
/*6.	Retrieve Total Weekly Sales by ItemType of only items with more than 3000 
weekly Sales.  Sort by Total Weekly Sales descending.*/
SELECT SUM(WeeklySales) As totalWeeklySales
	FROM dbo.Menu
	WHERE WeeklySales > 3000
	ORDER BY totalWeeklySales DESC;
	
--7.	Find out the profit made Weekly, Monthly and Yearly on Big Mac’s
SELECT (Price - CostToMake) *WeeklySales AS WeeklyProfit,
	(Price - CostToMake) *MonthlySales AS MonthlyProfit,
	(Price - CostToMake) *YearlySales AS YearlyProfit
	FROM dbo.Menu
	WHERE ItemName = 'Big Mac'

--8.	Retrieve the ItemType has more than $20,000 in Monthly Sales
SELECT TOP 1 ItemType
	FROM dbo.Menu
	WHERE (Price - CostToMake) * MonthlySales > 20000
	
--9.	Retrieve the ItemType that had the best Profit from MonthlySales
 
SELECT TOP 1 ItemType, 
	SUM((Price - CostToMake) * MonthlySales) AS BestMonthlyProfit 
	FROM dbo.Menu 
	GROUP BY ItemType
	ORDER BY BestMonthlyProfit