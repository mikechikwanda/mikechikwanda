-- ============================
-- 1. Data Quality Check
-- ============================

-- Check the structure of the table
DESCRIBE telco_stg;

-- ============================
-- 2. Modify Data Types (Standardization)
-- ============================
-- This step ensures that each column is using the appropriate data type for optimized querying.

ALTER TABLE telco_stg
MODIFY COLUMN customerID VARCHAR(20),
MODIFY COLUMN gender ENUM('Male', 'Female'),
MODIFY COLUMN SeniorCitizen TINYINT,
MODIFY COLUMN Partner ENUM('Yes', 'No'),
MODIFY COLUMN Dependents ENUM('Yes', 'No'),
MODIFY COLUMN tenure INT,
MODIFY COLUMN PhoneService ENUM('Yes', 'No'),
MODIFY COLUMN MultipleLines ENUM('Yes', 'No', 'No phone service'),
MODIFY COLUMN InternetService ENUM('DSL', 'Fiber optic', 'No'),
MODIFY COLUMN OnlineSecurity ENUM('Yes', 'No', 'No internet service'),
MODIFY COLUMN OnlineBackup ENUM('Yes', 'No', 'No internet service'),
MODIFY COLUMN DeviceProtection ENUM('Yes', 'No', 'No internet service'),
MODIFY COLUMN TechSupport ENUM('Yes', 'No', 'No internet service'),
MODIFY COLUMN StreamingTV ENUM('Yes', 'No', 'No internet service'),
MODIFY COLUMN StreamingMovies ENUM('Yes', 'No', 'No internet service'),
MODIFY COLUMN Contract ENUM('Month-to-month', 'One year', 'Two year'),
MODIFY COLUMN PaperlessBilling ENUM('Yes', 'No'),
MODIFY COLUMN PaymentMethod ENUM('Electronic check', 'Mailed check', 'Bank transfer (automatic)', 'Credit card (automatic)'),
MODIFY COLUMN MonthlyCharges DECIMAL(10, 2),
MODIFY COLUMN TotalCharges DECIMAL(10, 2),
MODIFY COLUMN Churn ENUM('Yes', 'No');

-- ============================
-- 3. Data Quality - Missing Values Check
-- ============================

-- Check for missing values across all columns to ensure data completeness
SELECT
    'customerID' AS column_name, COUNT(*) - COUNT(customerID) AS missing_values FROM telco_stg
UNION ALL
SELECT 'gender', COUNT(*) - COUNT(gender) FROM telco_stg
UNION ALL
SELECT 'SeniorCitizen', COUNT(*) - COUNT(SeniorCitizen) FROM telco_stg
UNION ALL
SELECT 'Partner', COUNT(*) - COUNT(Partner) FROM telco_stg
UNION ALL
SELECT 'Dependents', COUNT(*) - COUNT(Dependents) FROM telco_stg
UNION ALL
SELECT 'tenure', COUNT(*) - COUNT(tenure) FROM telco_stg
UNION ALL
SELECT 'PhoneService', COUNT(*) - COUNT(PhoneService) FROM telco_stg
UNION ALL
SELECT 'MultipleLines', COUNT(*) - COUNT(MultipleLines) FROM telco_stg
UNION ALL
SELECT 'InternetService', COUNT(*) - COUNT(InternetService) FROM telco_stg
UNION ALL
SELECT 'OnlineSecurity', COUNT(*) - COUNT(OnlineSecurity) FROM telco_stg
UNION ALL
SELECT 'OnlineBackup', COUNT(*) - COUNT(OnlineBackup) FROM telco_stg
UNION ALL
SELECT 'DeviceProtection', COUNT(*) - COUNT(DeviceProtection) FROM telco_stg
UNION ALL
SELECT 'TechSupport', COUNT(*) - COUNT(TechSupport) FROM telco_stg
UNION ALL
SELECT 'StreamingTV', COUNT(*) - COUNT(StreamingTV) FROM telco_stg
UNION ALL
SELECT 'StreamingMovies', COUNT(*) - COUNT(StreamingMovies) FROM telco_stg
UNION ALL
SELECT 'Contract', COUNT(*) - COUNT(Contract) FROM telco_stg
UNION ALL
SELECT 'PaperlessBilling', COUNT(*) - COUNT(PaperlessBilling) FROM telco_stg
UNION ALL
SELECT 'PaymentMethod', COUNT(*) - COUNT(PaymentMethod) FROM telco_stg
UNION ALL
SELECT 'MonthlyCharges', COUNT(*) - COUNT(MonthlyCharges) FROM telco_stg
UNION ALL
SELECT 'TotalCharges', COUNT(*) - COUNT(TotalCharges) FROM telco_stg
UNION ALL
SELECT 'Churn', COUNT(*) - COUNT(Churn) FROM telco_stg;

-- ============================
-- 4. Data Quality - Duplicates Check
-- ============================

-- Check for duplicates based on customerID (which should be unique)
SELECT 
    COUNT(customerID) AS total_entries,
    COUNT(DISTINCT customerID) AS unique_entries,
    (COUNT(customerID) - COUNT(DISTINCT customerID)) AS duplicates
FROM telco_stg;

-- ============================
-- 5. Exploratory Data Analysis (EDA)
-- ============================

-- Step 1: Churn Distribution
-- Overall churn percentage and distribution across key dimensions

-- Churn distribution across all customers
SELECT 
  AVG(MonthlyCharges) AS avg_monthly_charges, 
  MIN(MonthlyCharges) AS min_monthly_charges, 
  MAX(MonthlyCharges) AS max_monthly_charges,
  COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS churned_count,
  COUNT(CASE WHEN Churn = 'No' THEN 1 END) AS not_churned_count
FROM telco_stg;

-- Overall churn rate
SELECT 
  COUNT(*) AS total_customers, 
  COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS churned_count,
  (COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) / COUNT(*) * 100) AS churn_rate
FROM telco_stg;

-- Churn by Contract Type
SELECT 
  Contract,
  COUNT(*) AS total_customers,
  COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS churned_count,
  (COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) / COUNT(*) * 100) AS churn_rate
FROM telco_stg
GROUP BY Contract;

-- Step 2: Churn by Demographics

-- Churn by Gender
SELECT 
  gender, 
  COUNT(*) AS total_customers, 
  COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS churned_count,
  (COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) / COUNT(*) * 100) AS churn_rate
FROM telco_stg
GROUP BY gender;

-- Churn by Senior Citizen Status
SELECT 
  CASE WHEN SeniorCitizen = 0 THEN 'Not Senior' 
       WHEN SeniorCitizen = 1 THEN 'Senior' 
  END AS SeniorCitizen, 
  COUNT(*) AS total_customers, 
  COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS churned_count,
  (COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) / COUNT(*) * 100) AS churn_rate
FROM telco_stg
GROUP BY SeniorCitizen;

-- Step 3: Churn by Service Type
SELECT 
  InternetService, 
  COUNT(*) AS total_customers, 
  COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS churned_count,
  (COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) / COUNT(*) * 100) AS churn_rate
FROM telco_stg
GROUP BY InternetService;

-- Step 4: Churn by Contract Type
SELECT 
  Contract, 
  COUNT(*) AS total_customers, 
  COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS churned_count,
  (COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) / COUNT(*) * 100) AS churn_rate
FROM telco_stg
GROUP BY Contract;

-- Step 5: Average Customer Lifetime and Churn
SELECT 
  Churn,
  AVG(tenure) AS avg_tenure
FROM telco_stg
GROUP BY Churn;

-- Step 6: Monthly and Total Charges vs. Churn Rate
SELECT 
  CASE 
    WHEN MonthlyCharges < 30 THEN '<30'
    WHEN MonthlyCharges BETWEEN 30 AND 70 THEN '30-70'
    ELSE '>70'
  END AS charge_range,
  COUNT(*) AS total_customers, 
  COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS churned_count,
  (COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) / COUNT(*) * 100) AS churn_rate
FROM telco_stg
GROUP BY charge_range;

-- Step 7: Churn by Payment Method
SELECT 
  PaymentMethod, 
  COUNT(*) AS total_customers, 
  COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS churned_count,
  (COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) / COUNT(*) * 100) AS churn_rate
FROM telco_stg
GROUP BY PaymentMethod;

-- ============================
-- 6. Create Views for Reusability and Optimization
-- ============================

CREATE VIEW churn_summary AS
SELECT 
    COUNT(*) AS total_customers, 
    COUNT(CASE WHEN tenure = 0 THEN 1 END) AS new_joins,
    COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) AS total_churn,
    (COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) / COUNT(*) * 100) AS churn_rate
FROM telco_stg;
