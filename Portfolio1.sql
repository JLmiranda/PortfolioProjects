-- Getting all data from tables
SELECT * FROM portfolio.biggest_companies;
SELECT * FROM portfolio.cleaned_biggest_companies;

-- Group only for single value
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- Top 10 biggest company
SELECT * FROM portfolio.biggest_companies
ORDER BY Number_Employees DESC
LIMIT 10;

-- Joining 2 Tables
SELECT * FROM portfolio.cleaned_biggest_companies
JOIN portfolio.biggest_companies
ON cleaned_biggest_companies.Company_Name = biggest_companies.Company_Name;

-- Highest Number of Employees per Country
SELECT biggest_companies.Company_Name, Country, MAX(Number_Employees) AS Highest_Number_Employees FROM portfolio.cleaned_biggest_companies
JOIN portfolio.biggest_companies
ON cleaned_biggest_companies.Company_Name = biggest_companies.Company_Name
GROUP BY Country
ORDER By Number_Employees DESC;


-- Top 10 Countries that has Biggest Company
SELECT Country, Count(Country) AS Number_of_Companies
FROM portfolio.cleaned_biggest_companies
GROUP BY Country
ORDER BY Number_of_Companies DESC
LIMIT 10;

-- Top 10 Industries that has Biggest Company
SELECT Industry, Count(Industry) AS Number_of_Industry
FROM portfolio.cleaned_biggest_companies
GROUP BY Industry
ORDER BY Number_of_Industry DESC
LIMIT 10;

-- Increase Revenue from 2018 to 2020
SELECT Company_Name, Revenue_2018, Revenue_2020
FROM portfolio.cleaned_biggest_companies
WHERE Revenue_2020 > Revenue_2018;

-- Decrease Revenue from 2018 to 2020
SELECT Company_Name, Revenue_2018, Revenue_2020
FROM portfolio.cleaned_biggest_companies
WHERE Revenue_2018 > Revenue_2020;


-- Average of increase of net income from 2018-2020
SELECT Company_Name, ROUND((Net_Income_2018 + Net_Income_2019 + Net_Income_2020)/100,2) AS Average_Increase
FROM portfolio.cleaned_biggest_companies
GROUP BY Net_Income_2019;


-- Top 10 Company in United states that has highest income in 2020
Select Company_Name, Country, Industry, Net_Income_2020 AS Highest_Income2020
FROM portfolio.cleaned_biggest_companies
WHERE Country = 'United States' 
ORDER BY 4 DESC
LIMIT 10;

-- Status of Income Difference from 2019-2020
SELECT Company_Name, Net_Income_2019, Net_Income_2020,
	CASE
		WHEN Net_Income_2020 > Net_Income_2019 THEN 'Increased Income'
		WHEN Net_Income_2020 < Net_Income_2019 THEN 'Decreased Income'
		ELSE 'Constant'
	END AS Status
FROM portfolio.cleaned_biggest_companies;

-- Number of Companies per Country
SELECT Country, COUNT(Company_Name) AS Total_Companies
FROM portfolio.cleaned_biggest_companies
GROUP BY Country
ORDER BY Total_Companies DESC;

-- Getting companies founded Between 1995 and 2000
SELECT Company_Name, Country, Year_Founded
FROM portfolio.cleaned_biggest_companies
WHERE Year_Founded BETWEEN '1995' AND '2000' 
ORDER BY Year_Founded DESC;









