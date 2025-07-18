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

-- 4. ICU Pressure Comparison with Similar Testing Rates
-- Compare countries with similar testing rates per million (±20%) to identify disparities in ICU pressure.
WITH country_metrics AS (
    -- Compute serious-to-active case ratio and reuse TestPerM from the dataset
    SELECT
        CountryName,
        SeriousCases,
        ActiveCases,
        TestPerM,
        -- Calculate SeriousToActiveRate directly here
        ROUND((SeriousCases * 100.0 / NULLIF(ActiveCases, 0)), 2) AS SeriousToActiveRatePct
    FROM
        covid_data
    WHERE
        SeriousCases IS NOT NULL
        AND ActiveCases > 0
        AND TestPerM IS NOT NULL
),
paired_countries AS (
    -- Self-join to pair countries with similar testing rates (±20%) and directly calculate RateDifference
    SELECT
        a.CountryName AS Country1,
        b.CountryName AS Country2,
        a.SeriousToActiveRatePct AS Country1_SeriousToActiveRatePct,
        b.SeriousToActiveRatePct AS Country2_SeriousToActiveRatePct,
        a.TestPerM AS Country1_TestPerM,
        b.TestPerM AS Country2_TestPerM,
        ROUND(a.SeriousToActiveRatePct - b.SeriousToActiveRatePct, 2) AS RateDifference
    FROM
        country_metrics a
    INNER JOIN
        country_metrics b
        ON a.CountryName < b.CountryName -- Prevent duplicate pairings
        AND a.TestPerM BETWEEN b.TestPerM * 0.8 AND b.TestPerM * 1.2
        AND a.SeriousToActiveRatePct > b.SeriousToActiveRatePct
)
-- Final result: Top 10 country pairs with the largest ICU pressure differences
SELECT
    Country1,
    Country2,
    Country1_SeriousToActiveRatePct,
    Country2_SeriousToActiveRatePct,
    Country1_TestPerM,
    Country2_TestPerM,
    RateDifference
FROM
    paired_countries
ORDER BY
    RateDifference DESC
LIMIT 10;
