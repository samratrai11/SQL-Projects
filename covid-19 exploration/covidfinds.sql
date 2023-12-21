-- selection of coviddeaths table
select * from
Project1.coviddeaths
order by 3,4

-- selection of covidvaccine table
SELECT * from Project1.covidvacc
order by 3,4

-- looking at total 
select location, date, total_cases, new_cases,total_deaths,population
from Project1.coviddeaths
order by 1,2

-- specific country's deathpercentage, total deaths and total cases
select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Project1.coviddeaths
where location like '%united kingdom%'
order by 1,2

-- calculation of total cases and deathpercentage of population of a specific country
select location, date, total_cases,population, (total_cases/population)*100 as DeathPercentage
from Project1.coviddeaths
where location like '%kingdom%'
order by 1,2

-- calculation of highestinfectioncount, percentpopulationinfected in relation to location
select location,population, MAX(total_cases) as highestinfectioncount, MAX((total_cases/population))*100 as PercentPopulationInfected
from Project1.coviddeaths
group by location, population
order by PercentPopulationInfected desc

-- showing countries with higest death count per population
select location, MAX(CAST(total_deaths as signed)) as totaldeathcount
from Project1.coviddeaths
where continent is not null
group by location
order by totaldeathcount desc

-- CONTINENT Breakdown

-- Showing contintents with the highest death count 

Select continent, MAX(cast(Total_deaths as signed)) as TotalDeathCount
From Project1.coviddeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- global numbers
Select date, sum(new_cases) as TotalCases, sum(cast(new_deaths as signed)) as TotalDeaths,
sum(cast(new_deaths as signed))/sum(new_cases)*100 as DeathPercentage
From Project1.coviddeaths
Where continent is not null 
Group by date
order by 1,2 desc

-- Overall deathpercentage of the world
Select sum(new_cases) as TotalCases, sum(cast(new_deaths as signed)) as TotalDeaths,
sum(cast(new_deaths as signed))/sum(new_cases)*100 as DeathPercentage
From Project1.coviddeaths
Where continent is not null 
order by 1,2 desc

-- join the tables
select * from Project1.coviddeaths dea
join Project1.covidvacc vacc
on dea.location = vacc.location
and dea.date = vacc.date

-- Total Population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations
from Project1.coviddeaths dea
join Project1.covidvacc vacc
on dea.location = vacc.location
and dea.date = vacc.date
where dea.continent is not null
order by 2,3 
-- People being vaccinated per day with addition of new vaccinations found
-- USE of CTE for calculation

with PopvsVacc (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated) as 
(
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vacc.new_vaccinations,
    SUM(CAST(vacc.new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.location order by
    dea.location,dea.date) AS RollingPeopleVaccinated
FROM Project1.coviddeaths dea
JOIN Project1.covidvacc vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent IS NOT NULL
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVacc

-- total cases of covid-19
SELECT COUNT(*) AS total_cases FROM Project1.coviddeaths;

-- date of the dataset
SELECT MAX(date) AS latest_date, MIN(date) AS earliest_date FROM Project1.coviddeaths;

-- calculation of total cases, deaths, and recoveries for a specific country 
SELECT
    SUM(total_cases) AS TotalCases,
    SUM(total_deaths) AS TotalDeaths,
    SUM(reproduction_rate) AS ReproductionRate
FROM Project1.coviddeaths
where continent is not null
and location = 'united kingdom';

-- daily new cases and new deaths of covid-19 of a specified country
SELECT
    date,
    location,
    total_cases - LAG(total_cases) OVER (PARTITION BY location ORDER BY date) AS new_cases,
    total_deaths - LAG(total_deaths) OVER (PARTITION BY location ORDER BY date) AS new_deaths
FROM Project1.coviddeaths
WHERE location = 'United Kingdom'
ORDER BY date;

-- Top countries with the highest mortality rates (deaths per cases):
SELECT
    location,
    MAX(total_deaths / total_cases) AS mortality_rate
FROM Project1.coviddeaths
GROUP BY location
ORDER BY mortality_rate DESC;

--  daily growth rate of total cases and total deaths for a specific country 
SELECT
    date,
    location,
    total_cases,
    total_deaths,
    (total_cases - LAG(total_cases) OVER (PARTITION BY location ORDER BY date)) / LAG(total_cases) OVER (PARTITION BY location ORDER BY date) AS cases_growth_rate,
    (total_deaths - LAG(total_deaths) OVER (PARTITION BY location ORDER BY date)) / LAG(total_deaths) OVER (PARTITION BY location ORDER BY date) AS deaths_growth_rate
FROM Project1.coviddeaths
WHERE location = 'united kingdom'
ORDER BY date;

-- daily growth rate of new cases and new deaths for a specific country 
SELECT
    date,
    location,
    new_cases,
    new_deaths,
    (new_cases - LAG(new_cases) OVER (PARTITION BY location ORDER BY date)) / LAG(new_cases) OVER (PARTITION BY location ORDER BY date) AS cases_growth_rate,
    (new_deaths - LAG(new_deaths) OVER (PARTITION BY location ORDER BY date)) / LAG(new_deaths) OVER (PARTITION BY location ORDER BY date) AS deaths_growth_rate
FROM Project1.coviddeaths
WHERE location = 'united kingdom'
ORDER BY date;
-- 

