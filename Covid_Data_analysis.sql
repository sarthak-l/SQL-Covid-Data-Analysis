-- COVID-19 Global Analysis SQL Queries

-- 1. Global Overview
-- Calculate the total number of COVID-19 cases, deaths, and recoveries globally.
SELECT
    SUM(TotalCases) AS GlobalTotalCases,
    SUM(TotalDeath) AS GlobalTotalDeaths,
    SUM(TotalRecovered) AS GlobalTotalRecovered
FROM
    covid_data;

-- 2. Country-wise Analysis
-- Top 10 countries with the highest number of cases and deaths,
-- along with case-fatality rate and recovery rate.
SELECT
    CountryName,
    TotalCases,
    TotalDeath,
    TotalRecovered,
    (TotalDeath * 100.0 / TotalCases) AS CaseFatalityRate,
    (TotalRecovered * 100.0 / TotalCases) AS RecoveryRate
FROM
    covid_data
ORDER BY
    TotalCases DESC
LIMIT 10;

-- 3. Testing Analysis
-- Evaluate countries based on their testing rates per million population.
SELECT
    CountryName,
    TotalTests,
    Population,
    (TotalTests * 1000000.0 / Population) AS TestPerM
FROM
    covid_data
ORDER BY
    TestPerM DESC;

-- Save and close the file after adding any other necessary SQL queries.


