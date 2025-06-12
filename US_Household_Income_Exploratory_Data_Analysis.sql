# US Household Income Exploratory Data Analysis

SELECT *
FROM us_project.us_household_income;

SELECT *
FROM us_project.us_household_statistics;

# Which states have the most area of water and area of land

SELECT State_Name, County, City, ALand, AWater
FROM us_project.us_household_income;

# Sum of area of land for each state - show descending order

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 2 DESC;

# Sum of area of water for each state - show descending order

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC;

# Top 10 Largest States by Land

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

# Top 10 Largest States by Water

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;

# Join both data sets

SELECT *
FROM us_project.us_household_income u
JOIN us_project.us_household_statistics us
    ON u.id = us.id;

# Join both data sets on the Statistics with ID from Income data is empty/NULL - What are we missing with this join? 

SELECT *
FROM us_project.us_household_income u
RIGHT JOIN us_project.us_household_statistics us
	ON u.id = us.id
WHERE u.id IS NULL;
# some of the data is missing in ALL STATES

#use Inner Join to merge the data to include only the data that is in common

SELECT *
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_statistics us
	ON u.id = us.id;

# In this data, we do not want to include the Mean, Median, or Stdev equal zero

SELECT *
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_statistics us
	ON u.id = us.id
WHERE Mean <> 0;

# Look at the Mean and the Median of the State Name, County, Type, and Primary - categorical data

SELECT u.State_Name, County, Type, 'Primary', Mean, Median
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_statistics us
	ON u.id = us.id
WHERE Mean <> 0;

# Look at the average, mean, and median income at the State level

SELECT u.State_Name, AVG(Mean), AVG(Median)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_statistics us
	ON u.id = us.id
	WHERE Mean <> 0
GROUP BY u.State_Name
;

#Round the input to the tenth AND order by the Average Mean

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUIND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_statistics us
	ON u.id = us.id
	WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2;

# Let's look at the bottom five

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUIND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_statistics us
	ON u.id = us.id
	WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2
LIMIT 5;

#Let's look at the opposite. What states have the highest average income?

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUIND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_statistics us
	ON u.id = us.id
	WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 5;

# Can you order by the top 5 Median salaries?

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUIND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_statistics us
	ON u.id = us.id
	WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 5;

# What are the lowest 5 median salaries?

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_statistics us
	ON u.id = us.id
	WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 ASC
LIMIT 5;

# Let's look at the type (City, Town, Village, Borough) where people are living

SELECT Type, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_statistics us
	ON u.id = us.id
	WHERE Mean <> 0
GROUP BY Type
ORDER BY 2 DESC
LIMIT 10;

# We should do a count of type to see how many households are being counted in the outcome
 
SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_statistics us
	ON u.id = us.id
	WHERE Mean <> 0
GROUP BY 1
ORDER BY 3 DESC
LIMIT 20;

# Municipality is average high because there is only ONE - that ONE is higher than the rest of "Type"

# Let's take a look at the median

SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_statistics us
	ON u.id = us.id
	WHERE Mean <> 0
GROUP BY 1
ORDER BY 4 DESC
LIMIT 20;

#CDP and Track are the highest. Track also has a high count

# What states have the lowest, as represented in "Community"

SELECT *
FROM us_household_income
WHERE Type = 'Community';

# Answer: It is Puerto Rico

# Filter out the outliers, show the data where the type is greater than 100 

SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_statistics us
	ON u.id = us.id
	WHERE Mean <> 0
GROUP BY 1
HAVING COUNT(TYPE) > 100
ORDER BY 4 DESC
LIMIT 20;

# Look at the joined data again to find another problem to solve

SELECT *
FROM us_project.us_household_income u
JOIN us_project.us_household_statistics us
    ON u.id = us.id;

# What do the salaries look like from the big cities or areas

SELECT u.State_Name, City, ROUND(AVG(Mean),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_statistics us
    ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG(Mean),1) DESC;
# From highest to lowest first

# Add the median

SELECT u.State_Name, City, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u
JOIN us_project.us_household_statistics us
    ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY ROUND(AVG(Mean),1) DESC;

# Does it cap out at 300,000? - This could be found while looking at the data sourcing
