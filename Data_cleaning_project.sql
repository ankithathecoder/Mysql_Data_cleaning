#DATA CLEANING PROJECT

-- This will select and display all the data from the 'layoffs' table to give an overview of the raw data.
SELECT *
FROM layoffs;

-- MAIN STEPS: 
-- 1. Remove dulicates
-- 2. Standardize data
-- 3. NULL value/blank value
-- 4. Remove any columns

-- Step 1: Create a temporary copy of the 'layoffs' table to perform cleaning operations
CREATE TABLE layoffs_staging
LIKE layoffs;
SELECT *
FROM layoffs_staging;

-- Insert data from the 'layoffs' table into 'layoffs_staging'
INSERT layoffs_staging
SELECT *
FROM layoffs;

-- Check for duplicates by using ROW_NUMBER()
WITH duplicate_cte AS(
	SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
	FROM layoffs_staging
)
-- Display duplicate records where row_num > 1 (duplicates)
SELECT *
FROM duplicate_cte 
WHERE row_num>1;
-- Check specific company data 
SELECT *
FROM layoffs_staging
WHERE company='Casper';

-- Step 2: Create another table to insert data along with row numbers to identify duplicates
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert data into the new table with row numbers for duplicate checking
INSERT INTO layoffs_staging2
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
	FROM layoffs_staging;

-- Step 3: Remove duplicate rows from the 'layoffs_staging2' table
DELETE
FROM layoffs_staging2
WHERE row_num>1;

-- Display rows that have duplicates (if any)
SELECT *
FROM layoffs_staging2
WHERE row_num>1;

-- Step 4: Standardize data by removing spaces, correcting values, and handling inconsistent data
-- Remove spaces from the 'company' column
SELECT company, TRIM(company)
FROM layoffs_staging2;

-- Update the 'company' column by trimming spaces
UPDATE layoffs_staging2
SET company=TRIM(company);

-- Step 5: Standardize 'industry' names by correcting common variations
SELECT DISTINCT(industry)
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'crypto%';

-- Update the 'industry' column where 'crypto' appears to standardize it
UPDATE layoffs_staging2
SET industry='Crypto'
WHERE industry LIKE 'crypto%';
 
-- LOCATION everything fine ,so checked country there is a full stop in one
SELECT DISTINCT(country)
FROM layoffs_staging2
ORDER BY 1;

-- Standardize 'country' names by removing trailing periods 
SELECT DISTINCT(country), TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

-- Remove the trailing period in country names like "United States."
UPDATE layoffs_staging2
SET country=TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Step 6: Convert 'date' column from text to DATE type
SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

-- Update the 'date' column to proper DATE format
UPDATE layoffs_staging2
SET `date`=STR_TO_DATE(`date`,'%m/%d/%Y');

-- Alter column type to DATE
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2; 

-- Step 7: Handle NULL/blank values in columns
-- Find rows with NULL values in 'total_laid_off' and 'percentage_laid_off'
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Find rows where the 'industry' column is NULL or empty
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry='';

--  Check for industries like "Bally" and decide whether to clean up or update them
SELECT *
FROM layoffs_staging2
WHERE industry LIKE "Bally%";

-- Convert empty strings to NULL for uniformity
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry ='';

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company=t2.company
    AND t1.location=t2.location
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL;

-- Join the table to find missing industries and update them
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company=t2.company AND t1.location=t2.location
SET t1.industry=t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;

-- Step 8: Remove unwanted rows where key columns are NULL
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete rows where 'total_laid_off' and 'percentage_laid_off' are both NULL
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Final SELECT to confirm all data is cleaned
SELECT *
FROM layoffs_staging2;

-- Drop the 'row_num' column as it's no longer needed
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;