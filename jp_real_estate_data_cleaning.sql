/*
Data Cleaning in SQL Queries
*/

Use [PortfolioProject]
Go


--------------------------------------------------------------------------------------
-- Check the tables
Select *
From [dbo].[tokyo_prefecture]

Select *
From [dbo].[saitama_prefecture];


--------------------------------------------------------------------------------------
-- Delete Unused Columns
ALTER TABLE [dbo].[tokyo_prefecture]
DROP COLUMN [Region], [Layout], [Transaction-price(Unit price m^2)], [Land shape], [Frontage], 
[Total floor area(m^2)], [Frontage road：Direction], [Frontage road：Classification], 
[Frontage road：Breadth(m)], [Transactional factors], [Purpose of Use], [Use], [Maximus Building Coverage Ratio(%)],
[Maximus Floor-area Ratio(%)], [Renovation];

ALTER TABLE [dbo].[saitama_prefecture]
DROP COLUMN [Region], [Layout], [Transaction-price(Unit price m^2)], [Land shape], [Frontage], 
[Total floor area(m^2)], [Frontage road：Direction], [Frontage road：Classification], 
[Frontage road：Breadth(m)], [Transactional factors], [Purpose of Use], [Use], [Maximus Building Coverage Ratio(%)],
[Maximus Floor-area Ratio(%)], [Renovation];


--------------------------------------------------------------------------------------
-- We only consider 3 types of real estates: Residential Land(Land Only), Residential Land(Land and Building), Pre-owned Condominiums, etc.
-- and remove rows where the type is either agriculture or forest land

Select [Type] From [dbo].[tokyo_prefecture]
Group by [Type]
Select [Type] From [dbo].[saitama_prefecture]
Group by [Type]

-- Tokyo Prefecture: 467,648 rows => 467,031 (617 rows removed)
Delete From [dbo].[tokyo_prefecture]
where [Type] = 'Agricultural Land' OR [Type] = 'Forest Land';
-- Saitama Prefecture: 238,476 rows => 233,796 (4,680 rows removed)
Delete From [dbo].[saitama_prefecture]
where [Type] = 'Agricultural Land' OR [Type] = 'Forest Land';


--------------------------------------------------------------------------------------
-- Combine tables

-- Fix error on data type conversion: Variable "NearestStation(min)" in [saitama_prefectures] is nvarchar 
-- while float in [tokyo_prefectures].

-- Check the variable
Select [NearestStation(min)] From [dbo].[saitama_prefecture]
Group by [NearestStation(min)]

-- Clean up "NearestStation(min)" variable by changing "30-60minutes" to "30"; "1H-1H30" to "60"; "1H30-2H" to "90", "2H-" to "120"
UPDATE [dbo].[saitama_prefecture] SET [NearestStation(min)] = 30 WHERE [NearestStation(min)] = '30-60minutes';
UPDATE [dbo].[saitama_prefecture] SET [NearestStation(min)] = 60 WHERE [NearestStation(min)] = '1H-1H30';
UPDATE [dbo].[saitama_prefecture] SET [NearestStation(min)] = 90 WHERE [NearestStation(min)] = '1H30-2H';
UPDATE [dbo].[saitama_prefecture] SET [NearestStation(min)] = 120 WHERE [NearestStation(min)] = '2H-';

-- Create a new table
Create Table [tokyo_saitama_prefectures]
(
[No] float,
[Type] nvarchar(255),
[CityCode] float,
[Prefecture] nvarchar(255),
[City] nvarchar(255),
[Area] nvarchar(255),
[NearestStation] nvarchar(255),
[NearestStation(min)] float,
[Transaction-price(total)] float,
[Area(m^2)] float,
[Year of construction] float,
[Building structure] nvarchar(255),
[City Planning] nvarchar(255),
[Transaction period] nvarchar(255)
)

-- Combine and insert values into [tokyo_saitama_prefectures]
Insert Into [dbo].[tokyo_saitama_prefectures]
	Select *
	From [dbo].[tokyo_prefecture]
	UNION ALL
	Select *
	From [dbo].[saitama_prefecture]
GO

Select * 
From [dbo].[tokyo_saitama_prefectures]



--------------------------------------------------------------------------------------
-- Split transaction period into quarter and year
Select [Transaction period] 
From [dbo].[tokyo_saitama_prefectures]


Select 
     left(PARSENAME(REPLACE([Transaction period], ' quarter ', '.'), 2), 1) AS [Quarter]
   , PARSENAME(REPLACE([Transaction period], ' quarter ', '.'), 1) AS [Year]
From [dbo].[tokyo_saitama_prefectures];


ALTER TABLE [dbo].[tokyo_saitama_prefectures]
Add [Quarter] float;

Update [dbo].[tokyo_saitama_prefectures]
SET [Quarter] = left(PARSENAME(REPLACE([Transaction period], ' quarter ', '.'), 2), 1)


ALTER TABLE [dbo].[tokyo_saitama_prefectures]
Add [Year] float;

Update [dbo].[tokyo_saitama_prefectures]
SET [Year] = PARSENAME(REPLACE([Transaction period], ' quarter ', '.'), 1)


Select *
From [dbo].[tokyo_saitama_prefectures]
