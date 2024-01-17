
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
    (TotalDeath / TotalCases) * 100 AS CaseFatalityRate,
    (TotalRecovered / TotalCases) * 100 AS RecoveryRate
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
    TestPerM
FROM
    covid_data
ORDER BY
    TestPerM DESC;

-- Additional Queries (if applicable)

-- Time Series Analysis (if date information is available)
-- Observe the trend of new cases and new deaths over time.
SELECT
    Date,
    SUM(NewCases) AS TotalNewCases,
    SUM(NewDeath) AS TotalNewDeaths
FROM
    covid_data
GROUP BY
    Date
ORDER BY
    Date;

-- Regional Variation Analysis
-- Compare COVID-19 impact across different regions.
SELECT
    Region,  -- Replace with the actual column name representing regions in your dataset
    SUM(TotalCases) AS TotalCasesByRegion,
    SUM(TotalDeath) AS TotalDeathsByRegion,
    SUM(TotalRecovered) AS TotalRecoveredByRegion
FROM
    covid_data
GROUP BY
    Region;
