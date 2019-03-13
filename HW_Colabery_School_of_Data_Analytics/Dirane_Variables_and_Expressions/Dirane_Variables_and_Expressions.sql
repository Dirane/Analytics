USE [Prospects]
GO

/****** Object:  Table [dbo].[tbl_stg_Prospects]    Script Date: 10/9/2018 1:08:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_stg_Prospects](
	[Name] [varchar](250) NULL,
	[Title] [varchar](250) NULL,
	[Company] [varchar](250) NULL,
	[Location] [varchar](250) NULL,
	[FirstName] [varchar](250) NULL,
	[LastName] [varchar](250) NULL,
	[Designation] [varchar](250) NULL,
	[Department] [varchar](250) NULL,
	[City] [varchar](250) NULL,
	[State] [varchar](250) NULL
) ON [PRIMARY]
GO


Select * from tbl_stg_Prospects
Truncate table tbl_stg_Prospects
select count(*) from tbl_stg_Prospects