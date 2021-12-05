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
-- Delete Unused Columns
ALTER TABLE [dbo].[tokyo_prefecture]
DROP COLUMN [Region], [Layout], [Transaction-price(Unit price m^2)], [Land shape], [Frontage], 
[Total floor area(m^2)], [Frontage road：Direction], [Frontage road：Classification], 
[Frontage road：Breadth(m)], [Transactional factors], [Purpose of Use]

ALTER TABLE [dbo].[saitama_prefecture]
DROP COLUMN [Region], [Layout], [Transaction-price(Unit price m^2)], [Land shape], [Frontage], 
[Total floor area(m^2)], [Frontage road：Direction], [Frontage road：Classification], 
[Frontage road：Breadth(m)], [Transactional factors], [Purpose of Use];


--------------------------------------------------------------------------------------
-- Combine the two databases
Create Table [tokyo_saitama_prefectures]
Select * from (
Select * From [dbo].[tokyo_prefecture]
union
Select * From [dbo].[saitama_prefecture]);


--------------------------------------------------------------------------------------
-- We only consider 3 types of real estates: Residential Land(Land Only), Residential Land(Land and Building), Pre-owned Condominiums, etc.
-- and remove rows where the type is either agriculture or forest land





