/*

JP Real Estate Data Exploration

*/


USE PortfolioProject
GO


Select * From dbo.tokyo_saitama_prefectures
Where [NearestStation(min)] is not null
GO


Select Year From dbo.tokyo_saitama_prefectures
Group by Year
order by Year
GO


------------------------------------------------------------------------------------

-- The highest real estate prices in 2020

-- By type, city, prefecture and year

Select Type, Prefecture, City, MAX([Transaction-price(total)]) as HighestPrice, Year
From dbo.tokyo_saitama_prefectures
where Year = '2020'
Group by Year, Type, City, Prefecture
order by 2, 3, 1, 5 asc


-- By type and prefecture

Select Type, Prefecture, MAX([Transaction-price(total)]) as HighestPrice, Year
From dbo.tokyo_saitama_prefectures
where Year = '2020'
Group by Year, Type, Prefecture
order by 2, 1


-- By type and prefecture with Where clause 

Select Type, Prefecture, MAX([Transaction-price(total)]) as HighestPrice, Year
From dbo.tokyo_saitama_prefectures
where Prefecture = 'Tokyo' AND Year = '2020'
Group by Year, Type, Prefecture
order by 1

Select Type, Prefecture, MAX([Transaction-price(total)]) as HighestPrice
From dbo.tokyo_saitama_prefectures
where Prefecture = 'Saitama'AND  Year = '2020'
Group by Year, Type, Prefecture
order by 1


------------------------------------------------------------------------------------

-- Average real estate price by type and prefecture over 5-year period

Select Type, Prefecture, Year, cast(AVG([Transaction-price(total)]) as float) as AveragePrice
From dbo.tokyo_saitama_prefectures
Where Year = '2010' OR Year = '2015' OR Year = '2020'
Group by Year, Type, Prefecture
order by 2, 1, 3



------------------------------------------------------------------------------------

-- Growth rate of average real estate price by type and prefecture over 5-year period

Select Type, Prefecture, Year, cast(AVG([Transaction-price(total)]) as float) as AveragePrice, 100 * (cast(AVG([Transaction-price(total)]) as float) - lag(cast(AVG([Transaction-price(total)]) as float), 1) over (Partition by Prefecture, Type Order by Year)) / lag(cast(AVG([Transaction-price(total)]) as float), 1) over (Partition by Prefecture, Type Order by Year) as GrowthRate
From dbo.tokyo_saitama_prefectures
Where Year = '2010' OR Year = '2015' OR Year = '2020'
Group by Year, Type, Prefecture
order by 2, 1, 3


-- Using CTE

With GrowthRate (Type, Prefecture, Year, AveragePrice)
as
(
Select ts.Type, ts.Prefecture, ts.Year, cast(AVG(ts.[Transaction-price(total)]) as float) as AveragePrice
From dbo.tokyo_saitama_prefectures as ts
Where Year = '2010' OR Year = '2015' OR Year = '2020'
Group by ts.Year, ts.Type, ts.Prefecture
-- order by 2, 1, 3
)
Select *, 100 * (AveragePrice - lag(AveragePrice, 1) over (Partition by Prefecture, Type Order by Year)) / lag(AveragePrice, 1) over (Partition by Prefecture, Type Order by Year) as GrowthRate
From GrowthRate


-- Using Temp table

DROP Table if exists #GrowthRate
Create Table #GrowthRate
(
Type nvarchar(255),
Prefecture nvarchar(255),
Year int,
AveragePrice int
)


Insert into #GrowthRate
Select ts.Type, ts.Prefecture, ts.Year, cast(AVG(ts.[Transaction-price(total)]) as float) as AveragePrice
From dbo.tokyo_saitama_prefectures as ts
Where Year = '2010' OR Year = '2015' OR Year = '2020'
Group by ts.Year, ts.Type, ts.Prefecture

Select *, 100 * (AveragePrice - lag(AveragePrice, 1) over (Partition by Prefecture, Type Order by Year)) / lag(AveragePrice, 1) over (Partition by Prefecture, Type Order by Year) as GrowthRate
From #GrowthRate
GO


-- Creating View to store data for later visualizations

Create View AnnualPriceGrowthRate as
Select Type, Prefecture, Year, cast(AVG([Transaction-price(total)]) as float) as AveragePrice, 100 * (cast(AVG([Transaction-price(total)]) as float) - lag(cast(AVG([Transaction-price(total)]) as float), 1) over (Partition by Prefecture, Type Order by Year)) / lag(cast(AVG([Transaction-price(total)]) as float), 1) over (Partition by Prefecture, Type Order by Year) as GrowthRate
From dbo.tokyo_saitama_prefectures
Where Year = '2010' OR Year = '2015' OR Year = '2020'
Group by Year, Type, Prefecture
-- order by 2, 1, 3

GO



------------------------------------------------------------------------------------

-- Number of real estate by type and prefecture

Select Type, Prefecture, COUNT([No]) As Total
From dbo.tokyo_saitama_prefectures
Group by Type, Prefecture
order by 2, 1
