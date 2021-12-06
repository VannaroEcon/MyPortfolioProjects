/*

Real Estate Data Exploration

*/


USE PortfolioProject
GO



------------------------------------------------------------------------------------

-- The highest real estate prices by each city and prefecture

Select Type, Prefecture, City, MAX([Transaction-price(total)]) as HighestPrice
From dbo.tokyo_saitama_prefectures
Group by Type, City, Prefecture
order by 2, 3, 1



------------------------------------------------------------------------------------

-- The highest real estate prices by each city and prefecture

Select Type, Prefecture, MAX([Transaction-price(total)]) as HighestPrice
From dbo.tokyo_saitama_prefectures
Group by Type, Prefecture
order by 2, 1
