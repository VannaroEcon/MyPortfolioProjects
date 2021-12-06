/*

Real Estate Data Exploration

*/


USE PortfolioProject
GO



------------------------------------------------------------------------------------

-- The highest real estate prices

-- By type, city and prefecture

Select Type, Prefecture, City, MAX([Transaction-price(total)]) as HighestPrice
From dbo.tokyo_saitama_prefectures
Group by Type, City, Prefecture
order by 2, 3, 1


-- By type and prefecture

Select Type, Prefecture, MAX([Transaction-price(total)]) as HighestPrice
From dbo.tokyo_saitama_prefectures
Group by Type, Prefecture
order by 2, 1



------------------------------------------------------------------------------------

-- Average real estate price by type and prefecture

Select Type, Prefecture, cast(AVG([Transaction-price(total)]) as int) as AveragePrice
From dbo.tokyo_saitama_prefectures
Group by Type, Prefecture
order by 2, 1
