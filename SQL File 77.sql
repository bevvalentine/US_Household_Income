# US Household Income Data Cleaningus_household_income

SELECT *
FROM us_project.us_household_income;

SELECT *
FROM us_project.us_household_income_statistics;

ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN 'ï»¿id' TO 'id';

SELECT COUNT(id)
FROM us_project.us_household_income;

SELECT COUNT(id)
FROM us_project.us_household_income_statistics;


# Find duplicates in us.household.income table
SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

SELECT *
FROM (
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM us_project.us_household_income
) duplicates
WHERE row_num > 1
;


# Delete Duplicates
DELETE FROM us_household_income
WHERE row_id IN(
	SELECT row_id
	FROM (
		SELECT row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM us_project.us_household_income
		) duplicates
WHERE row_num > 1)
;

# Find duplicates in us.household.statistics table
SELECT id, COUNT(id)
FROM us_project.us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;
# there is none

#fixing the lower-case state names
SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY 1
;

UPDATE us_project.us_household_income
SET State_name = 'Alabama'
WHERE State_name = 'alabama'
;

#CHANGE State_name georia to Georgia
UPDATE us_project.us_household_income
SET State_name = 'Georgia' 
WHERE State_name = 'georia'
;

# State abbrevations
SELECT DISTINCT
    State_ab
FROM
    us_project.us_household_income
ORDER BY 1
;
# all correct

# fix missing values
SELECT *
FROM us_household_income
WHERE Place = ''
ORDER BY 1
;
# Only one record has null

SELECT *
FROM us_household_income
WHERE County = 'Autauga County'
AND City = 'Vinemont'
ORDER BY 1
;

# UPDATE null in row_id 32
UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND	City = 'Vinemont';

#Checking the Type column for errors
SELECT Type, COUNT(Type)
FROM us_household_income
GROUP BY Type
;

#Change 'Borough' to 'Boroughs'
UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;

SELECT *
FROM us_household_income;

#Fix the zeros in the ALand and AWater columns
SELECT ALand, AWater
FROM us_household_income
WHERE AWater = 0 OR AWater is NULL OR AWater = '';

#Is it all zeros?
SELECT DISTINCT AWater
FROM us_household_income
WHERE AWater = 0 OR AWater is NULL OR AWater = '';

#Any Land?
SELECT ALand, AWater
FROM us_household_income
WHERE (AWater = 0 OR AWater is NULL OR AWater = '')
AND (ALand = 0 OR ALand is NULL OR ALand = '')
;
#No Zero ALand!
SELECT ALand, AWater
FROM us_household_income
WHERE (ALand = 0 OR ALand is NULL OR ALand = '');
#Some counties are just water, NO LAND
