-- select * from Portfolio1..CovidDeaths order by 3,4;


-- covid death percentage with date
select location, date, total_cases, total_deaths, format((total_deaths/total_cases)*100, 'N2') AS Percentage, population 
from Portfolio1..CovidDeaths 
where location = 'india'
order by 1,2 


-- covid case percentage by population
select location, date, total_cases, total_deaths, format((total_cases/population)*100, 'N3') AS DeathPercentage, population 
from Portfolio1..CovidDeaths 
where location = 'india'
order by 1,2 


-- max covid cases by countries
select location, population, Max(total_cases) as HighestCount, CAST(MAX((total_cases/population)*100) AS DECIMAL(10,2)) as HighestPercentage
from Portfolio1..CovidDeaths 
GROUP BY location, population
order by 4 desc


-- max covid deaths by continents
select location, Max(cast((total_deaths) AS int)) as HighestDeathCount, 
CAST(MAX((total_deaths/population)*100) AS DECIMAL(10,2)) as HighestPercentage
from Portfolio1..CovidDeaths 
where continent is null
GROUP BY location
order by 2 desc


-- showing continents with highest death count per population
SELECT 
    continent, 
    MAX(CAST(total_deaths AS INT)) as HighestDeathCount, 
    SUM(CAST(total_deaths AS INT)) as TotalDeaths
FROM 
    Portfolio1..CovidDeaths 
GROUP BY 
    continent
ORDER BY 
    3 DESC


-- total cases and deaths date wise worldwide
SELECT 
    date, 
    SUM(new_cases) AS TotalCases,
	SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
	SUM(CAST(new_deaths AS INT))*100/SUM(new_cases) as percentageWorldwide
FROM 
    Portfolio1..CovidDeaths 
where continent is not null
GROUP BY date
ORDER BY 
    date asc


-- joining tables
select death.continent, death.location, death.population, death.date, vac.new_vaccinations from 
Portfolio1..CovidDeaths death join Portfolio1..CovidVaccinations vac
on death.location = vac.location
and death.date = vac.date
where death.continent is not null
order by 2,3 


-- total population vs vaccination
select death.continent, death.location, death.population, death.date, vac.new_vaccinations, 
Sum(CONVERT(int, vac.new_vaccinations)) 
OVER 
(PARTITION BY death.location ORDER BY death.location, death.date) as RollingPeopleVaccinated
from Portfolio1..CovidDeaths death join Portfolio1..CovidVaccinations vac
on death.location = vac.location
and death.date = vac.date
where death.continent is not null
order by 2,3

