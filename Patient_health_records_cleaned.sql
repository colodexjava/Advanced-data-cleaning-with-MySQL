SELECT * 
FROM new_pj1.patient_health_records_raw;

SELECT gender
FROM new_pj1.patient_health_records_raw;

## IF A MISTAKE OCCURS, JUST SELECT FROM THIS POINT TO THE LAST ENTRY BEFORE THE MISTAKE. RUN QUERY FOR THE SELECTED CODE
DROP TABLE pthealth;
CREATE TABLE pthealth
LIKE patient_health_records_raw;
INSERT INTO pthealth
SELECT * FROM patient_health_records_raw;

## working on each column, beginning from the first. 

UPDATE pthealth
SET patient_id = concat('ID- ', cast(substring(patient_id, 4) AS UNSIGNED))
WHERE patient_id <> '';

DELETE FROM pthealth
WHERE patient_id ='';

UPDATE pthealth
SET name = 'Smith Alice'
WHERE name LIKE 'SMI%';

UPDATE pthealth
SET name = TRIM(name);

UPDATE pthealth
SET name = 'Michael Brown'
WHERE name LIKE 'michael%';

UPDATE pthealth
SET name = 'John Doe'
WHERE name LIKE 'John%';

UPDATE pthealth
SET name = 'Jane Doe'
WHERE name LIKE 'Jane%';

UPDATE pthealth
SET name = 'Lee Sara'
WHERE name LIKE 'LE%';

## sorting the age
UPDATE pthealth
SET age = (-1)*(age)
WHERE age < 0;

## sort the gender
UPDATE pthealth
SET gender = 'Female'
WHERE gender LIKE 'F%';

UPDATE pthealth
SET gender = 'Male'
WHERE gender LIKE 'M%';

## repopulate the work using the name to filter down.
UPDATE pthealth
SET gender = 'Female'
WHERE name LIKE 'Smith%';

UPDATE pthealth
SET gender = 'Female'
WHERE name LIKE 'John%';

UPDATE pthealth
SET gender = 'Female'
WHERE name LIKE 'Mich%';

UPDATE pthealth
SET gender = 'Female'
WHERE name LIKE 'Mich%';

UPDATE pthealth
SET gender = 'Female'
WHERE name LIKE 'Jane%';

UPDATE pthealth
SET gender = 'Male'
WHERE name LIKE 'Lee%';

UPDATE pthealth
SET age = 25
WHERE age = 250;

## addressing the city column
UPDATE pthealth
SET city = 'New York'
WHERE city LIKE 'n%' OR city LIKE 'N%';

UPDATE pthealth
SET city = 'Los Angeles'
WHERE city LIKE 'la%';

UPDATE pthealth
SET city = 'Unknown'
where city like '';

## working on the different parameter beginning from the BMI
UPDATE pthealth
SET bmi = '22.0'
WHERE bmi LIKE '22k%';

UPDATE pthealth
SET bmi = '0.0'
WHERE bmi LIKE 'N/A';

ALTER TABLE pthealth
MODIFY BMI int;

## working on the blood pressure. i intend to keep it as text for now
UPDATE pthealth
SET blood_pressure = '120/80'
WHERE blood_pressure = '120 over 80'
OR blood_pressure = '120 - 80';

UPDATE pthealth
SET blood_pressure = NULL
WHERE blood_pressure = 'N/A';

ALTER TABLE pthealth
ADD systolic_bp VARCHAR(20),
ADD dyastolic_bp VARCHAR(20);

UPDATE pthealth
SET systolic_bp = substring_index(blood_pressure, '/', 1),
dyastolic_bp = substring_index(blood_pressure, '/', -1)
WHERE blood_pressure IS NOT NULL;

ALTER TABLE pthealth
DROP COLUMN blood_pressure;

ALTER TABLE pthealth
MODIFY systolic_bp INT;
ALTER TABLE pthealth
MODIFY dyastolic_bp INT;

ALTER TABLE pthealth
CHANGE dyastolic_bp diastolic_bp INT;

## heart rate adjustement is next. 

UPDATE pthealth
SET heart_rate = '50'
WHERE heart_rate = '500';

UPDATE pthealth
SET heart_rate = '80'
WHERE heart_rate = 'eighty';

UPDATE pthealth
SET heart_rate = '0'
WHERE systolic_bp IS NULL;

UPDATE pthealth
SET heart_rate = NULL
WHERE systolic_bp > 0
AND heart_rate = '0';

ALTER TABLE pthealth
MODIFY heart_rate INT;

## time to look at the cholesterol_level. since we don't have the standard values and equally unsure about what the high and low is, we will be using a case statement to asign each value to either high or normal accourding to a set standard.
UPDATE pthealth
	SET cholesterol_level = CASE WHEN (CAST(cholesterol_level as unsigned) / 38.67) < 5.2
								THEN 'Normal' ELSE 'Borderline High'
						END
	WHERE cholesterol_level = '190';
	UPDATE pthealth
	SET cholesterol_level = CASE WHEN (CAST(cholesterol_level as unsigned) / 38.67) < 6.2
								THEN 'Borderline High' ELSE 'High'
						END
		WHERE cholesterol_level = '250';
	UPDATE pthealth
	SET cholesterol_level = 'Unknown'
	WHERE cholesterol_level = '';
    
## diabetic column standardization
SELECT diabetic, count(*) from pthealth
group by diabetic;

UPDATE pthealth
SET diabetic = 'No'
WHERE diabetic = 'N' OR diabetic = 'no';
UPDATE pthealth
SET diabetic = 'Yes'
WHERE diabetic = 'y';
UPDATE pthealth
SET diabetic = 'Unknown'
WHERE diabetic = '';

## smoker column standardization
SELECT smoker, count(*) FROM pthealth
GROUP BY smoker;

UPDATE pthealth
SET smoker = 'Unknown'
WHERE smoker = 'n/a' OR smoker = '';
UPDATE pthealth
SET smoker = 'Yes'
WHERE smoker = 'yes';

## medication remains untouched. as this is subject to change and contain lots of variables. 
select medications, count(*) from pthealth
group by medications;
UPDATE pthealth
SET medications = 'Unknown'
WHERE medications = '';

## follow_up column
select follow_up, count(*)
from pthealth
group by Follow_Up;

UPDATE pthealth
SET follow_up = '0'
WHERE follow_up = 'N/A';
UPDATE pthealth
SET follow_up = '14'
WHERE follow_up LIKE 'two%';
ALTER TABLE pthealth
MODIFY follow_up INT;

## diagnosis code
select diagnosis_code, count(*) from pthealth
group by diagnosis_code;
UPDATE pthealth
SET diagnosis_code = 'Unknown'
WHERE diagnosis_code = '';

## review the note
select Has_Disease, count(*) from pthealth
group by Has_Disease;

UPDATE pthealth
SET has_disease = 'Unknown'
WHERE has_disease = '' OR has_disease = 'Unknown';

## lastly is the last_visit_date column to be standardized. 

ALTER TABLE pthealth
ADD clean_lv_date VARCHAR(25);

UPDATE pthealth
SET clean_lv_date =
	CASE
		WHEN last_visit_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
        THEN STR_TO_DATE(last_visit_date, '%d/%m/%Y')
        WHEN last_visit_date REGEXP '^[A-Za-z]{3} [0-9]{2} [0-9]{4}$'
        THEN STR_TO_DATE(last_visit_date, '%b %d %Y')
        WHEN last_visit_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
		THEN STR_TO_DATE(last_visit_date, '%Y-%m-%d')
        WHEN last_visit_date REGEXP '^[0-9]{4}[0-9]{2}[0-9]{2}$'
		THEN STR_TO_DATE(last_visit_date, '%Y%m%d')
        ELSE null
	END;

ALTER TABLE pthealth
DROP COLUMN Last_Visit_Date;

ALTER TABLE pthealth
MODIFY clean_lv_date DATE;
ALTER TABLE pthealth
CHANGE clean_lv_date last_visit_date DATE;

SELECT * 
FROM patient_health_records_raw;
SELECT * 
FROM pthealth
ORDER BY Patient_ID;




