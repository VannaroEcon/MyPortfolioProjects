/*

Covid 19 Data Exploration 

*/



Use PortfolioProject
Go


--------------------------------------------------------------------------------------

-- Check the table

Select *
From dbo.covid19_deaths
Where continent is not null 
order by 3,4



--------------------------------------------------------------------------------------

-- Standardize the Date Format

-- Convert date from yyyy-MM-dd hh:mm:ss to yyyy-MM-dd
ALTER TABLE covid19_deaths
Add date_converted Date;

Update covid19_deaths
SET date_converted = CONVERT(Date, date)

-- Drop column 'date'
ALTER TABLE covid19_deaths
DROP COLUMN date



--------------------------------------------------------------------------------------

-- Calculate daily total cases, new cases and deaths for each country

Select Location, date_converted, total_cases, new_cases, total_deaths, population
From dbo.covid19_deaths
Where continent is not null 
order by 1,2


--------------------------------------------------------------------------------------

-- Calculate the percentate of death over the number of people contracted Covid

Select Location, date_converted, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From dbo.covid19_deaths
Where location like '%states%'
and continent is not null 
order by 1, 2


--------------------------------------------------------------------------------------

-- Total Cases vs Population (percentage of infectedpopulation)

Select Location, date_converted, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From dbo.covid19_deaths
order by 1,2



--------------------------------------------------------------------------------------

-- Countries with Highest Infection Rate

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From dbo.covid19_deaths
Group by Location, Population
order by PercentPopulationInfected desc



--------------------------------------------------------------------------------------

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From dbo.covid19_deaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc

