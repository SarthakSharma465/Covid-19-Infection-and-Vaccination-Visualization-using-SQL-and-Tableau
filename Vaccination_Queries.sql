SELECT * FROM Portfolio_Project..CovidVaccinations

-- Query Number 1:
 SELECT SUM(cast(new_vaccinations AS float)) AS Total_Vaccinations
 FROM Portfolio_Project..CovidVaccinations
 WHERE continent IS NOT NULL
