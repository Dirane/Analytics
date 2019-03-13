/*Name: Ngala Dirane Ngiri
Lesson: Selecting and Grouping Data
Date: 28/07/2018*/


USE [july_14_online]

--1. Create the following table:
CREATE TABLE [dbo].[BBall_Stats](
	[PlayerID] [int] NULL,
	[PlayerName] [varchar](50) NULL,
	[PlayerNum] [int] NULL,
	[PlayerPosition] [varchar](50) NULL,
	[Assist] [int] NULL,
	[Rebounds] [int] NULL,
	[GamesPlayed][int] NULL,
	[Points] [int] NULL,
	[PlayersCoach] [varchar] (50) NULL
) 

--2. Run the following script
INSERT INTO BBall_Stats(PLAYERID, PLAYERNAME,PLAYERNUM,PLAYERPOSITION,ASSIST,REBOUNDS,GAMESPLAYED,POINTS,PLAYERSCOACH)
select 1,'ali',20,'guard',125,80,10,60,'thompson' union
select 2,'james',22,'forward',65,100,10,65,'garret' union
SELECT 3,'ralph',24, 'center',30 ,120,9,70,'samson' union
   SELECT 4,'terry',30,'guard',145,90,9,75,'garret' union
   SELECT 5,'dirk',32,'forward',70,110,10,80,'thompson'union
   SELECT 6,'alex',34,'center',35 ,130,10,90,'garret' union
   SELECT 7,'nina',40,'guard',155 ,100,9,100 ,' samson'union
   SELECT 8,'krystal',42,'forward',75,100,9,95,'thompson' union
   SELECT 9,'bud',44, 'center',40,125,10,90,'thompson' union
   SELECT 10,'tiger',50, 'guard',160,90,10,85,'samson' union
   SELECT 11,'troy',52, 'forward',80,125,10,80,'samson' union
   SELECT 12,'anand',54, 'center',50,145,10,110,'samson' union
   SELECT 13,'kishan',60, 'guard',120,150,9,115,'samson' union
   SELECT 14,'spock',62, 'forward',85,105,8,120,'thompson' union
   SELECT 15,'cory',64, 'center',55,175,10,135,'samson'

 --Find the Number of Players at each Position
 SELECT PlayerPosition, COUNT(PlayerName) AS NumberOfPlayers
 FROM BBall_Stats
 GROUP BY PlayerPosition;

--Find the Number of Players assigned to each Coach
 SELECT PlayersCoach, COUNT(PlayerID) AS NumberOfPlayers
 FROM BBall_Stats
 GROUP BY PlayersCoach;
 
--Find the Most Points scored per game by Position
SELECT MAX(Points) AS most_points
FROM BBall_Stats
GROUP BY PlayerPosition
 
--Find the Number of Rebounds per game by Coach
SELECT COUNT(Rebounds/GamesPlayed) AS Num_of_rebouds
FROM BBall_Stats
GROUP BY PlayersCoach

--Find the Average number of Assist by Coach
SELECT AVG(Assist) AS Num_of_assists
FROM BBall_Stats
GROUP BY PlayersCoach

--Find the Average number of Assist per game by Position
SELECT AVG(Assist/GamesPlayed) AS Num_of_assists
FROM BBall_Stats
GROUP BY PlayerPosition

--Find the Total number of Points by each Player Position.
SELECT COUNT(Points)
FROM BBall_Stats
GROUP BY PlayerPosition


