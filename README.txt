Data Cleaning – Layoffs Dataset (SQL)

📌 Project Overview  
This project focuses on cleaning a layoffs dataset using MySQL. The goal is to prepare the data for further analysis by addressing missing values, duplicates, inconsistent formats, and incorrect data types—ensuring the dataset is reliable and analysis-ready.


📂 Dataset Description  
The dataset contains layoff information from various companies, with the following key columns:

- Company – Name of the company  
- Location – City of operation  
- Industry – Company's industry  
- Total Laid Off – Number of employees laid off  
- Percentage Laid Off – % of total workforce laid off  
- Date – Date of the layoff event  
- Stage – Stage of funding or operation  
- Country – Country where the company operates  
- Funds Raised (Millions – Total funding raised (in millions)  

🎯 Objectives  
- Identify and fix issues like missing data, inconsistencies, and duplicates  
- Standardize formats across the dataset  
- Prepare data for further analysis or visualization  

🛠️Data Cleaning Steps Performed

1. Initial Inspection
- Reviewed data structure and key columns  
- Checked for NULLs, duplicates, and formatting inconsistencies  

2. Data Cleaning Operations
- Removed Duplicates to retain only unique entries  
- Handled NULLs:  
  - Addressed missing values in critical fields (e.g., industry, total_laid_off)  
  - Either imputed or removed rows based on context  
- Standardized Text Columns:  
  - Fixed inconsistent values (e.g., changed "crypto" to "Crypto")  
  - Cleaned location and country fields (e.g., removed trailing characters)  
- Fixed Date Format to ensure proper date data type  

 3. Exploratory Analysis
- Queried key stats: total layoffs, layoffs by industry and country  
- Identified trends across different dimensions  

 4. Final Review
- Confirmed cleaned data is ready for use in analysis or modeling  

 🧰 Tools Used  
- MySQL – For querying and transformation  

 ✅ Conclusion  
After thorough data cleaning, the layoffs dataset is consistent and ready for in-depth analysis. The cleaned dataset can now support visualizations and insights into the impact of layoffs across sectors and regions.
