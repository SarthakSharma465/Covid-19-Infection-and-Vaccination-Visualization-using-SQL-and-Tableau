-- 1) Query Number 1
-- Here we query for total cases , total deaths, and the average death percentage
SELECT sum(new_cases) AS  Total_Cases, sum(new_deaths) AS  Total_Deaths, sum(new_deaths)/sum(new_cases)*100 as Total_death_percentage
FROM Portfolio_Project..CovidDeaths
WHERE continent IS NOT NULL

-- There are certain entries where continent is NULL, those entries don't contain the data for countries but for continents as a whole so we don't need to consider them.

-- 2) Query Number 2
-- Here we calculate the total death count of the world
SELECT SUM(new_deaths) as Total_Death_Count, location
FROM Portfolio_Project..CovidDeaths
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International') AND location NOT LIKE '%income%'
GROUP BY location
ORDER BY Total_Death_Count DESC

-- 3) Query Number 3
-- Maximum Infection Count, Percentage Population Infected
-- Max of new cases, Max
 SELECT location, population, MAX(new_cases) AS Highest_Infection_Count, MAX(new_cases/population)*100 AS Percentage_Population_Affected 
 FROM Portfolio_Project..CovidDeaths
 GROUP BY location, population
 ORDER BY Percentage_Population_Affected DESC


 -- 4) Query Number 4
 -- Maximum Infection Count, Percentage Population Infected Alongwith date
-- Max of new cases, Max
 SELECT Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Portfolio_Project..CovidDeaths
--Where location like '%states%'
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC


