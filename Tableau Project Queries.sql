/*

Queries for Tableau JP Real Estate Project

*/


USE PortfolioProject
GO


Select * From dbo.tokyo_saitama_prefectures
GO


-- Table 1
-- Real estate price by types in Tokyo and Saitama in 2020

Select Type, Prefecture, MAX([Transaction-price(total)]) as HighestPrice, Year
From dbo.tokyo_saitama_prefectures
where Year = '2020'
Group by Year, Type, Prefecture
order by 2, 1


-- Table 2
-- Average real estate price by type and prefecture over 5-year period

Select Type, Prefecture, Year, cast(AVG([Transaction-price(total)]) as float) as AveragePrice
From dbo.tokyo_saitama_prefectures
Where Year = '2010' OR Year = '2015' OR Year = '2020'
Group by Year, Type, Prefecture
order by 2, 1, 3


-- Table 3
-- Growth rate of average real estate price by type and prefecture over 5-year period

Select Type, Prefecture, Year, cast(AVG([Transaction-price(total)]) as float) as AveragePrice, 100 * (cast(AVG([Transaction-price(total)]) as float) - lag(cast(AVG([Transaction-price(total)]) as float), 1) over (Partition by Prefecture, Type Order by Year)) / lag(cast(AVG([Transaction-price(total)]) as float), 1) over (Partition by Prefecture, Type Order by Year) as GrowthRate
From dbo.tokyo_saitama_prefectures
Where Year = '2010' OR Year = '2015' OR Year = '2020'
Group by Year, Type, Prefecture
order by 2, 1, 3



-- Table 4
-- Number of real estate by type and prefecture

Select Type, Prefecture, COUNT([No]) As Total
From dbo.tokyo_saitama_prefectures
Group by Type, Prefecture
order by 2, 1



-- Table 5

Select Type, Prefecture, City, [NearestStation(min)], [Transaction-price(total)], [Area(m^2)], Quarter, Year
From dbo.tokyo_saitama_prefectures
where Prefecture = 'Tokyo'
order by 3, 1



-- Table 6

Select Type, Prefecture, City, [NearestStation(min)], [Transaction-price(total)], [Area(m^2)], Quarter, Year
From dbo.tokyo_saitama_prefectures
where Prefecture = 'Saitama'
order by 3, 1



-- Table 

Select Type, Prefecture, City, [NearestStation(min)], [Transaction-price(total)], [Area(m^2)], Quarter, Year
From dbo.tokyo_saitama_prefectures
order by 3, 1