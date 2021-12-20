/*

Covid 19 Data Exploration 

*/



Use PortfolioProject
Go


--------------------------------------------------------------------------------------

-- Check the tables

Select *
From dbo.covid19_deaths
Where continent is not null 
order by 3,4


Select *
From dbo.covid19_vaccinations
Where continent is not null 
order by 3,4


--------------------------------------------------------------------------------------

-- Standardize the date format for dbo.covid19_deaths

-- Convert date from yyyy-MM-dd hh:mm:ss to yyyy-MM-dd
ALTER TABLE covid19_deaths
Add date_converted Date;

Update covid19_deaths
SET date_converted = CONVERT(Date, date)

-- Drop column 'date'
ALTER TABLE covid19_deaths
DROP COLUMN date



--------------------------------------------------------------------------------------

-- Standardize the date format for dbo.covid19_vaccinations

-- Convert date from yyyy-MM-dd hh:mm:ss to yyyy-MM-dd
ALTER TABLE covid19_vaccinations
Add date_converted Date;

Update covid19_vaccinations
SET date_converted = CONVERT(Date, date)

-- Drop column 'date'
ALTER TABLE covid19_vaccinations
DROP COLUMN date



--------------------------------------------------------------------------------------

-- Calculate daily total cases, new cases and deaths for each country

Select location, date_converted, total_cases, new_cases, total_deaths, population
From dbo.covid19_deaths
Where continent is not null 
order by 1,2


--------------------------------------------------------------------------------------

-- Calculate the percentate of death over the number of people contracted Covid

Select location, date_converted, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From dbo.covid19_deaths
Where location like '%states%'
and continent is not null 
order by 1, 2


--------------------------------------------------------------------------------------

-- Calculate the percentage of infected population (total cases / population)

Select location, date_converted, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From dbo.covid19_deaths
order by 1,2



--------------------------------------------------------------------------------------

-- Find countries with the highest infection rate

Select location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From dbo.covid19_deaths
Group by location, Population
order by PercentPopulationInfected desc



--------------------------------------------------------------------------------------

-- Calculate the death count per population by country

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From dbo.covid19_deaths
Where continent is not null 
Group by location
order by TotalDeathCount desc


--------------------------------------------------------------------------------------

-- Calculate the death count per population by continent

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From dbo.covid19_deaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc



--------------------------------------------------------------------------------------

-- Calculate the total case and deaths around the world

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From dbo.covid19_deaths
where continent is not null 
order by 1,2



--------------------------------------------------------------------------------------

-- Calculate the percentage of population that received at least 1 covid vaccine

Select d.continent, d.location, d.date_converted, d.population, v.new_vaccinations
, SUM(CONVERT(bigint, v.new_vaccinations)) OVER (Partition by d.location Order by d.location, d.date_converted) as RollingPeopleVaccinated
From dbo.covid19_deaths d
Join dbo.covid19_vaccinations v
	On d.location = v.location
	and d.date_converted = v.date_converted
where d.continent is not null 
order by 2,3



--------------------------------------------------------------------------------------

-- Calculate the percentage of people who have been vaccinated 

-- Using CTE

With PopvsVac (Continent, Location, date_converted, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select d.continent, d.location, d.date_converted, d.population, v.new_vaccinations
, SUM(CONVERT(bigint, v.new_vaccinations)) OVER (Partition by d.location Order by d.location, d.date_converted) as RollingPeopleVaccinated
From dbo.covid19_deaths d
Join dbo.covid19_vaccinations v
	On d.location = v.location
	and d.date_converted = v.date_converted
where d.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentagePopulationVaccinated
From PopvsVac


-- Using Temp table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select d.continent, d.location, d.date_converted, d.population, v.new_vaccinations
, SUM(CONVERT(bigint,v.new_vaccinations)) OVER (Partition by d.location Order by d.location, d.date_converted) as RollingPeopleVaccinated
From dbo.covid19_deaths d
Join dbo.covid19_vaccinations v
	On d.location = v.location
	and d.date_converted = v.date_converted
where d.continent is not null 

Select *, (RollingPeopleVaccinated/Population)*100 as PercentagePopulationVaccinated
From #PercentPopulationVaccinated

GO

--------------------------------------------------------------------------------------

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select d.continent, d.location, d.date_converted, d.population, v.new_vaccinations
, SUM(CONVERT(bigint,v.new_vaccinations)) OVER (Partition by d.location Order by d.location, d.date_converted) as RollingPeopleVaccinated
From dbo.covid19_deaths d
Join dbo.covid19_vaccinations v
	On d.location = v.location
	and d.date_converted = v.date_converted
where d.continent is not null 

GO

Select * From PercentPopulationVaccinated



/*

Cambodia Case

*/
--------------------------------------------------------------------------------------

-- Calculate daily total cases, new cases and deaths

Select location, date_converted, total_cases, new_cases, total_deaths, population
From dbo.covid19_deaths
Where Location = 'Cambodia'


--------------------------------------------------------------------------------------

-- Calculate the percentate of death over the number of people contracted Covid

Select location, date_converted, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From dbo.covid19_deaths
Where location = 'Cambodia'
order by 1, 2


--------------------------------------------------------------------------------------

-- Calculate the percentage of infected population (total cases / population)

Select Location, date_converted, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From dbo.covid19_deaths
Where location = 'Cambodia'
order by 1,2



--------------------------------------------------------------------------------------

-- Find the infection rate

Select location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From dbo.covid19_deaths
Where location = 'Cambodia'
Group by location, Population
order by PercentPopulationInfected desc



--------------------------------------------------------------------------------------

-- Calculate the death count per population

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From dbo.covid19_deaths
Where location = 'Cambodia'
and continent is not null 
Group by location
order by TotalDeathCount desc



--------------------------------------------------------------------------------------

-- Calculate the percentage of population that received at least 1 covid vaccine

Select d.continent, d.location, d.date_converted, d.population, v.new_vaccinations
, SUM(CONVERT(bigint, v.new_vaccinations)) OVER (Partition by d.location Order by d.date_converted) as RollingPeopleVaccinated
From dbo.covid19_deaths d
Join dbo.covid19_vaccinations v
	On d.location = v.location
	and d.date_converted = v.date_converted
where d.location = 'Cambodia' and d.continent is not null 
order by 2,3



--------------------------------------------------------------------------------------

-- Calculate the percentage of people who have been vaccinated 

-- Using CTE

With PopvsVacKhm (Continent, location, date_converted, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select d.continent, d.location, d.date_converted, d.population, v.new_vaccinations
, SUM(CONVERT(bigint, v.new_vaccinations)) OVER (Partition by d.location Order by d.location, d.date_converted) as RollingPeopleVaccinated
From dbo.covid19_deaths d
Join dbo.covid19_vaccinations v
	On d.location = v.location
	and d.date_converted = v.date_converted
where d.location = 'Cambodia' and d.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentagePopulationVaccinated
From PopvsVacKhm
