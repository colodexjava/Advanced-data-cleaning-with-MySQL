# Advanced-data-cleaning-with-MySQL
This project shows a more advanced approach to data cleaning using SQL workbench alone.
## Outline
- [Project Overview](#project-overview)

- [Data Source](#data-source)

- [Tools](#tools)

- [Clinical Problem](#clinical-problem)

- [Dataset Description](#dataset-description)

- [Skills Demonstrated](#skills-demonstrated)

- [Data Preparation](#data-preparation)

- [Key Questions](#key-questions)

- [Key Findings](#key-findings)

- [Skills Learnt](#skills-learnt)

- [Recommendations](#recommendations)

- [Limitations](#limitations)

- [Next Step](#next-step)

## Project Overview

This project shows a more advanced approach to data cleaning using SQL workbench alone. This data contains about 10,000 simulated patient health records designed to reflect the complexity of real-world healthcare data. It is ladened with inconsistencies, missing values, and formatting errors – making it perfect for practicing data wrangling, organizing and formatting for further exploratory analysis. 


## Data Source

Kaggle - Patient_Health_Record_Raw.csv


## Tools

MySQL Workbench


## Clinical Problem

A major health care facility in charge of providing quality health care to the community has decided to improve on the data collection and research opportunity. They decided to look at the records taken so far, only to realize the data where not inputted properly, making it impossible to derive anything logical from the dataset. 


## Dataset Description

The data set contains simulated patient health records of a real-world healthcare data. This data includes patient biodata, vital sign check, important investigation, past medical history, medication and follow-up visit time.
Columns included in the dataset:
  - Patient_ID:  Unique patient identifier (with inconsistent formatting in raw data).
  - Name:  Patient name (contains variations, duplicates, and inconsistent capitalization).
  - Age:  Patient age (includes negative, outlier, or text values).
  - Gender:  gender information (varied labels such as M, Male, F, Female, Unknown).
  -	City: Patient’s city (misspellings and inconsistent casing).
  -	BMI:  Body Mass Index (with units or missing values).
  -	Blood_Pressure: Blood pressure readings (various formats: “120/80”, “120 over 80”, etc.).
  -	Heart_Rate: Patient heart rate (with unrealistic values in raw data).
  -	Cholesterol_Level: Cholesterol level (categorical and numeric mix).
  -	Diabetic: Indicates whether the patient is diabetic (yes/no/unknown).
  -	Smoker: Smoking status (Yes, No, Former, Ex-Smoker).
  -	Medications: Prescribed medications (comma-separated values).
  -	Last_Visit_Date: Last medical visit date (in multiple formats).
  -	Follow_Up: Recommended follow-up days.
  -	Diagnosis_Code: ICD-like diagnosis codes (some missing or inconsistent).
  -	Notes Doctor’s notes (contains emojis, unstructured text).
  -	Has_Disease Target label indicating if the patient has a disease (binary).


## Skills Demonstrated

Advanced use and understanding of MySQL database manager like altering table structure, creating of new columns to achieve a set goal, formatting of column strings using update and other string and character functions, use of temporary table to test outcome of different ideas, identification of outliers, standardization of name, values and data type, standardization of multiple date format using the CASE and STR_TO_DATE function. Also utilized the REGEXP as another form of searching for string structure to modify with the UPDATE function. Conversion of different columns from one datatype to another, repopulating of missing data ad finally, utilizing the NULL to replace missing values instead of blanks – for better assessment. 


## Data Preparation

The dataset was obtained from Kaggle specifically for the purpose of showcasing my data cleaning ability for a more complex dataset. It was transferred into MySQ server using the “data table import wizard”. Each column was carefully inspected, issues noted and documented with possible solution afterwards – to better understand how to approach the data and ensure that all task needed to clean that column was done. Each formatting and standardization were done with the intention to fit the analysis required. 


## Key Questions

-	Were there missing data?
-	Were there any duplicate in the dataset?
-	Are there any wrong spellings in the name column?
-	How did you standardize the Last_Visit_Date, seeing that it is in text datatype with multiple format?
-	How did you repopulate the age column and city column?
-	How did you standardize the Cholesterol_level column, seeing it had both numerical and categorical data?
-	How did you address the blanks?


## Key Findings

1.	From the Patient_id column, we can deduce that about 396 patients had no recorded ID, hence unfit for analysis. This information was removed since no other means of tracking the patient info, seeing that some patients bear same name. The format was then structured to eliminate the multiple zeros to make it more readable.
2.	The name column had multiple structure and casing. This was resolved using the STRING_INDEX syntax in the UPDATE function to match a Proper CASING. There were no missing values here. Although, since this is only a simulated data set, only 5 names were used to repopulate the entire name column but with different casing and wrong spelling. 
3.	Using the name column and gender column, with the help of an aggregate function (count ()) and GROUP BY, I was able to deduce the possible gender for each name. This was then used to repopulate the data. 
In the age column, there was an outlier (250), this was noted in 2297 counts. Possible correction would be 25 years of age. Those negative values were remove using -1 to multiply the values < 0.
4.	Concerning the city column, “New York” had multiple wrongly spelt names hence it was corrected and standardized to a uniform name. This is inclusive for Los Angeles. About 723 candidates left these spaces in the city column blank, hence, I replaced it with “unknown”. 
5.	In preparation for analysis of the dataset, the BMI, needed to be converted to ‘int’ datatype and the unit removed from the data in the row. Places where the BMI was not mentioned will be converted to 0.
6.	While editing the blood pressure, I mistakenly converted all the values to 120/80. To correct this, I had to drop the duplicate table and rerun all the previous code from creating of the duplicate table to just before the error was made. This was a clear show of why it is very important to work on a duplicate and not the raw original table. Since I planned on exploring the blood pressure, I created two new columns from it, titled systolic_bp and diastolic_bp. These two columns were then converted to INT.
7.	Concerning the heart rate, there were about 1766 row having heart rate of 500. This is pretty abnormal for a patient. I took out one zero which will put it at an acceptable level, seeing them as outliers. “eighty” was converted to “80”. Lastly, a heartrate of 0 is as good as dead. So, I first compared it with the blood pressure. Rows with no heart rate but normal blood pressure values were replaced with “null”. While those with no blood pressure, the heart rate was replaced with 0. From the comparison, there are 356 rows with 0 heart rate and NULL blood_pressure. 
8.	For the cholesterol level, since we don't have the standard values and equally unsure about what the highs and lows are. I used a case statement to assign each value to either high or normal according to a set standard. But first converted the values from Mg/dl to mmol/L (UK/NICE standard) using the conversion coefficient of “38.67”.
9.	According to WHO/NICE- aligned clinical ranges used in practice, I assigned each value into the various categories;
a.	Normal: < 5.2mmol/L
b.	Borderline high: 5.3 – 6.2 mmol/L
c.	High: > 6.2 mmol/L
10.	Diabetic column is mainly to standardize the values to either Yes, No or Unknown. Same goes for smoker and Has_diaese column.
11.	It was observed from the last visit date that the format was not uniform, and the datatype is still text. The date column had over 4 different formats, making it pretty difficult to edit all at once. To fix this, I first created a new column, then used the UPDATE, CASE, REGEXP and STR_TO_DATE to convert all the dates the the appropriate format. After which, I changed the datatype to “date” and dropped the previous column. 


## Skills Learnt

1.	Use of regular table expression (REGEXP) to standardize date presented in different format
2.	Use of ALTER to rename columns
3.	Use of CASE statement in UPDATE function
4.	Use of SUBSTRING_INDEX in standardizing names having delimiter as either space, coma or any other character.
5.	Use of group by and aggregate function for data inspection.
6.	Use of temporary tables to text run idea.


## Recommendations

1.	Always take out time to understand your dataset before commencing cleaning
2.	Never make the mistake of working directly on your original table. Create a temporary table or a duplicate to work on. 
3.	Data type is a crucial part of data cleaning. Simply because a date looks like the standardised format doesn’t mean it is actually a date. Always look at the data types in the schema information to be sure that each column has their expected data type.
4.	Being overly judicious with editing a dataset might create more trouble than solution. To avoid such, have in mind, the essence of the work and what it is intended for.
5.	Keep practicing on variable data set and format to understand data dynamics.


## Limitations

•	in this dataset cleaning, I did not encounter any limitation
•	there were too many missing data in the dataset. Hopefully, an advice to the record department on how to standardize data collection will improve the data quality.


## Next Step

•	advancing to steps in exploring the data
•	continue with data visualization in SQL





