
-- Toatal cases vs total deaths

--Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as '% of deaths' , population
--from PortfolioProject..CovidDeaths
--where location like '%kingdom%' 
--and continent is not null
--order by 1,2

-- Total cases vs population
-- shows what population of population has got covid

--Select Location, date, total_cases, population, (total_cases/population)*100 as 'Infected population %' 
--from PortfolioProject..CovidDeaths
--where location like '%kingdom%' 
--and continent is not null
--order by 1,2

-- Country with highest infction rate wrt population

--Select Location, population, max(total_cases) as 'Highest Infection Count',  max((total_cases/population)*100) as 'Highest Infected Population%'
--from PortfolioProject..CovidDeaths
--where continent is not null
--Group by population, location
--order by 'Highest Infected Population%' desc

-- Show Countries with highest death count 

--Select continent, max(cast(total_deaths as int)) as 'Highest Death Count'--, max((total_deaths/total_cases)*100) as 'max deaths %' 
--from PortfolioProject..CovidDeaths
--where continent is not null
--group by continent
--order by 'Highest Death Count' desc


-- GROUPING BY CONTINENT HIGHEST DEATH COUNT 

--Select location, population, max(cast(total_deaths as int)) as 'Highest Death Count'--, max((total_deaths/total_cases)*100) as 'max deaths %' 
--from PortfolioProject..CovidDeaths
--where continent is not null
--group by continent, population, location
--order by 'Highest Death Count' desc


-- GLOBAL NUMBERS

--Select SUM(NEW_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
----, total_deaths, (total_deaths/total_cases)*100 as '% of deaths' 
--from PortfolioProject..CovidDeaths
----where location like '%kingdom%' 
--WHERE continent is not null
----group by "date"
--order by 1,2



-- USE CTE
-- Population vs Vaccinated 

with PopvsVax (continent, location, date, population, new_vaccinations, RollingPeopleVaxxed)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(convert(int, vac.new_vaccinations)) Over (partition by dea.Location order by 
 dea.location, dea.date) as RollingPeopleVaxxed
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..Covidvaccinations as vac
	on dea.location =vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaxxed/population)*100 
from PopvsVax

-- TEMP TABLE 

DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime, 
population numeric,
new_vaccinations numeric,
RollingPeopleVaxxed numeric
)


Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(convert(int, vac.new_vaccinations)) Over (partition by dea.Location order by 
 dea.location, dea.date) as RollingPeopleVaxxed
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..Covidvaccinations as vac
	on dea.location =vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaxxed/population)*100 
from #PercentPopulationVaccinated





CREATE VIEW PercentPopulationVaxxinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(convert(int, vac.new_vaccinations)) Over (partition by dea.Location order by 
 dea.location, dea.date) as RollingPeopleVaxxed
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..Covidvaccinations as vac
	on dea.location =vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

select * from PercentPopulationVaxxinated