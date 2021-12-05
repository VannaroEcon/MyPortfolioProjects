/*
Data Cleaning in SQL Queries
*/

Use [PortfolioProject]
Go


--------------------------------------------------------------------------------------
-- Check the databases
Select *
From [dbo].[tokyo_prefecture]

Select *
From [dbo].[saitama_prefecture]

--------------------------------------------------------------------------------------
-- Combine the two databases
Select * From [dbo].[tokyo_prefecture]
Union
Select * From [dbo].[saitama_prefecture]


--------------------------------------------------------------------------------------
-- We only consider 3 types of real estates: Residential Land(Land Only), Residential Land(Land and Building), Pre-owned Condominiums, etc.
-- and remove rows where the type is either agriculture or forest land



-- Delete Unused Columns

Select *
From PortfolioProject.dbo.tokyo_prefecture


ALTER TABLE PortfolioProject.dbo.tokyo_prefecture
DROP COLUMN Region, FrontageroadFDirection


