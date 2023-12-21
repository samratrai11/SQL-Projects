Covid-19 Findings
1.	Data set link: https://ourworldindata.org/covid-deaths

2.	Tool used: MYSQL WORKBENCH
•	The reason for using MYSQL WORKBENCH is because it is compatible with MacBook Air.
3.	Download MYSQL WORKBENCH: https://dev.mysql.com/downloads/workbench/

MYSQL CODE AND SUMMARY:

-- Selection of COVID deaths table

select * from
Project1.coviddeaths
order by 3,4

key insights:
•	SELECT *: This retrieves all columns from the specified table.
•	FROM Project1.coviddeaths: This specifies the table from which to retrieve the data. In this case, it's assumed that there's a table named coviddeaths in the schema or database named Project1.
•	ORDER BY 3, 4: This orders the result set based on the values in the third and fourth columns. The numbers in the ORDER BY clause refer to the positions of the columns in the SELECT clause. So, the result set will be sorted first by the values in the third column and then, for rows with equal values in the third column, by the values in the fourth column.

-- Selection of COVID vaccine table

SELECT * from Project1.covidvacc
order by 3,4

-- looking at total 

select location, date, total_cases, new_cases,total_deaths,population
from Project1.coviddeaths
order by 1,2

•	key insights: the query retrieves specific columns from the coviddeaths table and orders the results first by location and then by date.

-- specific country's death percentage, total deaths and total cases:

select location, date, total_cases,total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
from Project1.coviddeaths
where location like '%united kingdom%'
order by 1,2

•	key insights: this query retrieves data for the United Kingdom from the coviddeaths table, calculates the death percentage, and orders the result set by location and date.
•	SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 AS DeathPercentage: This part of the query selects specific columns from the table. Additionally, it calculates a new column, DeathPercentage, which represents the percentage of total deaths relative to total cases.
•	WHERE location LIKE '%united kingdom%': Filters the rows to include only those where the location column contains the phrase 'united kingdom'. The % symbols are wildcards, allowing for matches with any characters before or after 'united kingdom'.

-- calculation of total cases and death percentage of population of a specific country:

select location, date, total_cases,population, (total_cases/population)*100 as DeathPercentage
from Project1.coviddeaths
where location like '%kingdom%'
order by 1,2

key insights:
•	This query retrieves data for locations containing the word 'kingdom' from the coviddeaths table, calculates the death percentage relative to the population, and orders the result set by location and date.

-- calculation of highestinfectioncount, percentpopulationinfected in relation to location:

select location,population, MAX(total_cases) as highestinfectioncount, MAX((total_cases/population))*100 as PercentPopulationInfected
from Project1.coviddeaths
group by location, population
order by PercentPopulationInfected desc

key insights:
•	SELECT location, population, MAX(total_cases) AS highestinfectioncount, MAX((total_cases / population)) * 100 AS PercentPopulationInfected: This part of the query selects specific columns from the table. It calculates the maximum infection count (highestinfectioncount) and the corresponding percentage of population infected (PercentPopulationInfected) for each location.
•	GROUP BY location, population: Groups the result set by unique combinations of location and population. This means that the subsequent aggregate functions (MAX in this case) are applied to each group.
•	this query retrieves information about the highest infection count and the corresponding percentage of the population infected for each location in the coviddeaths table. The result set is then ordered by the percentage of population infected in descending order.

-- showing countries with highest death count per population:

select location, MAX(CAST(total_deaths as signed)) as totaldeathcount
from Project1.coviddeaths
where continent is not null
group by location
order by totaldeathcount desc

key insights:
•	SELECT location, MAX(CAST(total_deaths AS SIGNED)) AS totaldeathcount: This part of the query selects specific columns from the table. It calculates the maximum total death count (totaldeathcount) for each location. The CAST(total_deaths AS SIGNED) part ensures that the total_deaths column is treated as a signed integer, which may be necessary if the data type of total_deaths is not already an integer type.
•	this query retrieves information about the maximum total death count for each location where the continent is not null from the coviddeaths table. The result set is then ordered by the total death count in descending order.

-- CONTINENT Breakdown
-- Showing continents with the highest death count 

Select continent, MAX(cast(Total_deaths as signed)) as TotalDeathCount
From Project1.coviddeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc

key insights:
•	This query retrieves information about the maximum total death count for each continent from the coviddeaths table, considering only records where the continent is not null. The result set is then ordered by the total death count in descending order.

-- global numbers

Select date, sum(new_cases) as TotalCases, sum(cast(new_deaths as signed)) as TotalDeaths,
sum(cast(new_deaths as signed))/sum(new_cases)*100 as DeathPercentage
From Project1.coviddeaths
Where continent is not null 
Group by date
order by 1,2 desc

key insights:
•	SELECT date, SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS SIGNED)) AS TotalDeaths, SUM(CAST(new_deaths AS SIGNED)) / SUM(new_cases) * 100 AS DeathPercentage: This part of the query selects specific columns from the table. It calculates the total cases (TotalCases), total deaths (TotalDeaths), and death percentage (DeathPercentage) for each date. The CAST(new_deaths AS SIGNED) part ensures that the new_deaths column is treated as a signed integer.
•	FROM Project1.coviddeaths: Specifies the table from which to retrieve the data (coviddeaths in the schema or database Project1).
•	WHERE continent IS NOT NULL: Filters the rows to include only those where the continent column is not null.
•	GROUP BY date: Groups the result set by unique values in the date column. The subsequent aggregate functions (SUM and CAST) are applied to each group.
•	ORDER BY 1, 2 DESC: Orders the result set based on the values in the first column (date) in ascending order and the second column (TotalCases) in descending order. This means that the result set will be sorted by date in ascending order and, for dates with equal values, by total cases in descending order.
•	This query provides aggregated information about total cases, total deaths, and death percentage for each date from the coviddeaths table, considering only records where the continent is not null. The result set is then ordered by date in ascending order and total cases in descending order.

-- Overall deathpercentage of the world

Select sum(new_cases) as TotalCases, sum(cast(new_deaths as signed)) as TotalDeaths,
sum(cast(new_deaths as signed))/sum(new_cases)*100 as DeathPercentage
From Project1.coviddeaths
Where continent is not null 
order by 1,2 desc

key insights:
•	This query provides aggregated information about total cases, total deaths, and death percentages for all records in the coviddeaths table where the continent is not null. The result set is then ordered by total cases in ascending order and total deaths in descending order.

-- join the tables
select * from Project1.coviddeaths dea
join Project1.covidvacc vacc
on dea.location = vacc.location
and dea.date = vacc.date

key insights:
•	JOIN Project1.covidvacc vacc: Specifies the second table (covidvacc) and aliases it as vacc.
•	ON dea.location = vacc.location AND dea.date = vacc.date: Defines the conditions for the join. The query joins rows from the two tables where the values in the location and date columns are the same.
•	The result of this query will be a combined result set with columns from both tables (coviddeaths and covidvacc) where there are matching rows based on the specified conditions. This type of join is useful when you want to combine information from two tables where there is a commonality in the values of certain columns (in this case, location and date).


-- Total Population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations
from Project1.coviddeaths dea
join Project1.covidvacc vacc
on dea.location = vacc.location
and dea.date = vacc.date
where dea.continent is not null
order by 2,3 

key insights:
•	FROM Project1.coviddeaths dea: Specifies the first table (coviddeaths) and aliases it as dea.
•	JOIN Project1.covidvacc vacc ON dea.location = vacc.location AND dea.date = vacc.date: Performs an inner join with the covidvacc table (vacc) based on matching values in the location and date columns.
•	WHERE dea.continent IS NOT NULL: Filters the result set to include only rows where the continent column in the coviddeaths table is not null.
•	This query retrieves information about the continent, location, date, population, and the number of new vaccinations for matching rows in the coviddeaths and covidvacc tables, where the continent is not null. The result set is then ordered by location and date.

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

key insights:
•	Common Table Expression (CTE) - PopvsVacc: This part of the query defines a CTE that combines data from the coviddeaths and covidvacc tables. It includes information about the continent, location, date, population, and new vaccinations. The RollingPeopleVaccinated column is calculated using the SUM window function, providing a rolling sum of new vaccinations over time for each location.
•	Final SELECT Statement: This part of the query selects all columns from the PopvsVacc CTE and calculates an additional column, VaccinationPercentage, which represents the percentage of the population that has been vaccinated. This is computed by dividing the RollingPeopleVaccinated by the population and multiplying by 100.
•	This query calculates the rolling sum of new vaccinations over time for each location and computes the percentage of the population that has been vaccinated. The result set includes information about the continent, location, date, population, new vaccinations, rolling people vaccinated, and vaccination percentage.


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

key insights:
•	The query calculates and returns the total number of cases, total number of deaths, and the sum of reproduction rates for the specified location ('united kingdom') from the coviddeaths table, considering only rows where the continent is not null.

-- daily new cases and new deaths of covid-19 of a specified country
SELECT
    date,
    location,
    total_cases - LAG(total_cases) OVER (PARTITION BY location ORDER BY date) AS new_cases,
    total_deaths - LAG(total_deaths) OVER (PARTITION BY location ORDER BY date) AS new_deaths
FROM Project1.coviddeaths
WHERE location = 'United Kingdom'
ORDER BY date;

Key insights:
•	total_cases - LAG(total_cases) OVER (PARTITION BY location ORDER BY date) AS new_cases: Calculates the difference between the total cases on the current date and the total cases on the previous date (using the LAG function with the PARTITION BY clause to partition the data by location and order it by date). This difference represents the new cases for each day.
•	total_deaths - LAG(total_deaths) OVER (PARTITION BY location ORDER BY date) AS new_deaths: Similar to the new_cases calculation, this calculates the difference between the total deaths on the current date and the total deaths on the previous date. This difference represents the new deaths for each day.
•	The query provides a result set that includes the date, location ('United Kingdom'), and the calculated new cases and new deaths for each day based on the total cases and total deaths in the 'United Kingdom' from the coviddeaths table.

-- Top countries with the highest mortality rates (deaths per cases):
SELECT
    location,
    MAX(total_deaths / total_cases) AS mortality_rate
FROM Project1.coviddeaths
GROUP BY location
ORDER BY mortality_rate DESC;

Key insights:
•	MAX(total_deaths / total_cases) AS mortality_rate: Calculates the maximum mortality rate for each location by dividing the maximum value of total_deaths by total_cases. The MAX function is used with the GROUP BY clause to obtain this value for each location.
•	This query provides a result set that includes each unique location, along with the maximum mortality rate calculated as the maximum value of the ratio of total deaths to total cases. The result set is ordered by the calculated mortality rate in descending order.

-- daily growth rate of total cases and total deaths for a specific country 
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

Key insights:
•	Use the LAG window function to find the difference between the current day's value and the previous day's value, then divide this difference by the previous day's value to calculate the growth rate.
•	(total_cases - LAG(total_cases) OVER (PARTITION BY location ORDER BY date)) / LAG(total_cases) OVER (PARTITION BY location ORDER BY date) AS cases_growth_rate: Calculates the growth rate of total cases by finding the difference between the current day's total cases and the previous day's total cases, and then dividing this difference by the previous day's total cases. This is done using the LAG window function with the PARTITION BY clause to partition the data by location and order it by date.
•	(total_deaths - LAG(total_deaths) OVER (PARTITION BY location ORDER BY date)) / LAG(total_deaths) OVER (PARTITION BY location ORDER BY date) AS deaths_growth_rate: Similar to the cases_growth_rate calculation, this calculates the growth rate of total deaths.
•	The query provides a result set that includes the date, location ('United Kingdom'), total cases, total deaths, cases growth rate, and deaths growth rate. The growth rates are calculated based on the differences between consecutive days' total cases and total deaths. The result set is ordered by date.


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

Key insights:
•	LAG window function to find the difference between the current day's value and the previous day's value for new cases and new deaths. Then, it divides this difference by the previous day's value to calculate the growth rate. 
•	(new_cases - LAG(new_cases) OVER (PARTITION BY location ORDER BY date)) / LAG(new_cases) OVER (PARTITION BY location ORDER BY date) AS cases_growth_rate: Calculates the growth rate of new cases by finding the difference between the current day's new cases and the previous day's new cases, and then dividing this difference by the previous day's new cases. This is done using the LAG window function with the PARTITION BY clause to partition the data by location and order it by date.
•	(new_deaths - LAG(new_deaths) OVER (PARTITION BY location ORDER BY date)) / LAG(new_deaths) OVER (PARTITION BY location ORDER BY date) AS deaths_growth_rate: Similar to the cases_growth_rate calculation, this calculates the growth rate of new deaths.
•	The query provides a result set that includes the date, location ('United Kingdom'), new cases, new deaths, cases growth rate, and deaths growth rate. The growth rates are calculated based on the differences between consecutive days' new cases and new deaths. The result set is ordered by date.


