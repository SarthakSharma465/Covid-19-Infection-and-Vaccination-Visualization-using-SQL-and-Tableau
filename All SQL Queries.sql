SELECT * 
FROM Portfolio_Project..CovidDeaths
ORDER BY 3,4;

-- SELECT * 
-- FROM Portfolio_Project..CovidVaccinations
-- ORDER BY 3,4;


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project..CovidDeaths
ORDER BY 1,2;

-- Total cases versus Total deaths
-- Percentage cases/deaths
SELECT location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast (total_cases as float))*100 AS Death_Percentage
FROM Portfolio_Project..CovidDeaths
WHERE location = 'India'
ORDER BY Death_Percentage DESC;

-- Total cases versus population in India
-- Percentage effected = totalcases/population
SELECT location, date, total_cases, population, total_deaths, (total_cases/population)*100 AS Percentage_Effected, (cast(total_deaths as float)/cast (total_cases as float))*100 AS Death_Percentage
FROM Portfolio_Project..CovidDeaths
WHERE location = 'India'
ORDER BY Percentage_Effected DESC;

-- Total cases versus population in the USA
-- Percentage effected = totalcases/population
SELECT location, date, total_cases, population, total_deaths, (total_cases/population)*100 AS Percentage_Effected, (cast(total_deaths as float)/cast (total_cases as float))*100 AS Death_Percentage
FROM Portfolio_Project..CovidDeaths
WHERE location LIKE '%states'
ORDER BY Percentage_Effected DESC;

-- Maximum infection rate in the world 
-- Percentage effected = totalcases/population
SELECT location, total_cases, population, total_deaths, (total_cases/population)*100 AS Percentage_Effected, (cast(total_deaths as float)/cast (total_cases as float))*100 AS Death_Percentage
FROM Portfolio_Project..CovidDeaths
ORDER BY Percentage_Effected DESC;

-- Maximum deaths in the world
-- Total deaths is in Nvarchar data type so we need to typecast it and also we need to remove continents from the data
-- As we want to work on countries as an entity
SELECT location, MAX(cast(total_deaths as int)) AS Total_deaths
FROM Portfolio_Project..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY Total_deaths DESC;

-- Total deaths by continent
SELECT location, MAX(cast(total_deaths as int)) AS Total_deaths
FROM Portfolio_Project..CovidDeaths
WHERE continent is null AND location NOT LIKE '%income%'
GROUP BY location
ORDER BY Total_deaths DESC;

-- Total deaths by continent
SELECT continent, MAX(cast(total_deaths as int)) AS Total_deaths
FROM Portfolio_Project..CovidDeaths
WHERE continent is not null 
GROUP BY continent
ORDER BY Total_deaths DESC;


-- Global Numbers

-- This gives number of cases and deaths till date by adding them 
SELECT date, SUM(new_cases) AS Cases, SUM(new_deaths) AS Deaths, SUM(new_deaths)/SUM(CASE WHEN new_cases = 0 THEN 1 ELSE new_cases END)*100 AS Death_percentage
FROM Portfolio_Project..CovidDeaths
WHERE continent is not null -- No continent entity is being considered here
GROUP BY date
ORDER BY 1,2;

-- If we need total cases and deaths over the entire duration then we don't select date just take the sum
SELECT SUM(new_cases) AS Cases, SUM(new_deaths) AS Deaths, SUM(new_deaths)/SUM(CASE WHEN new_cases = 0 THEN 1 ELSE new_cases END)*100 AS Death_percentage
FROM Portfolio_Project..CovidDeaths
WHERE continent is not null -- No continent entity is being considered here
-- GROUP BY date
ORDER BY 1,2;

-- COVID VACCINATIONS
-- We join both the tables death and vaccinations on date and location
SELECT *
FROM Portfolio_Project..CovidVaccinations vac -- vac is called the alias so we don't have to call the whole name again so we use vac instead
JOIN Portfolio_Project..CovidDeaths dea
ON vac.location = dea.location
AND vac.date = dea.date;

-- Looking at total population vs the vaccination
-- Rolling Sum of new vaccinations

-- Concept of CTE is used, Common Table Expression 
-- We created a virtual table and used the SELECT statement on the table
WITH PopsVac ( Continent, Location, Date, Population, new_vaccinations, Total_vaccinations_tilldate)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as Total_vaccinations_tilldate
FROM Portfolio_Project..CovidVaccinations vac -- vac is called the alias so we don't have to call the whole name again so we use vac instead
JOIN Portfolio_Project..CovidDeaths dea
ON vac.location = dea.location
AND vac.date = dea.date
WHERE dea.continent IS NOT NULL
-- GROUP BY dea.date, dea.location
 -- ORDER BY 2,3;
)

SELECT *, (Total_vaccinations_tilldate/Population)*100 as Percentage_people_vaccinated
FROM PopsVac;

-- Alternate way to cast is to use CONVERT(int, attribute_name)
-- Creating a view for later visualizations

CREATE VIEW PercentagePopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as Total_vaccinations_tilldate
FROM Portfolio_Project..CovidVaccinations vac -- vac is called the alias so we don't have to call the whole name again so we use vac instead
JOIN Portfolio_Project..CovidDeaths dea
ON vac.location = dea.location
AND vac.date = dea.date
WHERE dea.continent IS NOT NULL
-- GROUP BY dea.date, dea.location
 -- ORDER BY 2,3;

 SELECT * FROM PercentagePopulationVaccinated;




 





