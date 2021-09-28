--Showing Covid 19 Data From Jan 22, 2020 to Sept 20, 2021
--Link to Dataset: https://ourworldindata.org/covid-deaths

Select *
From PortfolioProject..CovidDeaths
Where continent is not null 


--Seect data that we are going to use
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
order by location, date


--Looking at the Percentage of Toatal Cases and Total Deaths
Select Location, date, total_cases, total_deaths, ((total_deaths/total_Cases)*100) as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
order by location, date


--Looking at the Death Percentage people who died beacause of Covid in United Sates
Select Location, date, total_cases, total_deaths, ((total_deaths/total_Cases)*100) as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null and location = 'United States'
order by location, date


--Looking at the Percentage of People who got Covid
Select Location, date, total_cases, population, ((total_cases/population)*100) as PercentPopulationInfected
From PortfolioProject..CovidDeaths
order by location, date


--Looking at the Percentage of Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc


--Counting Covid Deaths per continent 
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
--Eropean Union is a part of Europe
Group by Location
order by TotalDeathCount desc


--Looking at International Total Cases, Total Deaths, and Death Percentage of People who got Covid
Select SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(New_Deaths as int))/SUM(New_Cases)*100 as Global_Death_Percentage
From PortfolioProject..CovidDeaths
where continent is not null 


--Looking at the highest Death Count per Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc




-- Total Population vs Vaccinations
-- Showing Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as Dea
Join PortfolioProject..CovidVaccinations as Vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not NULL
order by dea.location, dea.date



-- Using CTE to perform Calculation on Partition By in previous query
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


Select *
From PercentPopulationVaccinated
