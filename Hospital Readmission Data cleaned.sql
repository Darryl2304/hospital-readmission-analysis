-- Wipe the old broken table
-- Recreate with column names that EXACTLY match your CSV headers
CREATE TABLE hospital_data (
    facility_name               TEXT,
    facility_id                 TEXT,
    state                       TEXT,
    measure_name                TEXT,
    num_discharges              TEXT,
    excess_readmission_ratio    TEXT,
    predicted_readmission_rate  TEXT,
    expected_readmission_rate   TEXT,
    num_readmissions            TEXT,
    start_date                  TEXT,
    end_date                    TEXT,
    condition_name              TEXT,
    performance_flag            TEXT,
    volume_category             TEXT
);
SELECT COUNT(*) AS total_rows
FROM hospital_data;
SELECT *
FROM hospital_data
LIMIT 5;

-- Q1 Which states have the worst Readmission problem?

SELECT
    state,
    COUNT(*) AS total_records,
    ROUND(AVG(CAST(excess_readmission_ratio AS DECIMAL(10,4))), 4) AS avg_excess_ratio,
    SUM(CASE WHEN performance_flag = 'High Risk' THEN 1 ELSE 0 END) AS high_risk_count,
    ROUND(
        SUM(CASE WHEN performance_flag = 'High Risk' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS high_risk_pct
FROM hospital_data
GROUP BY state
ORDER BY avg_excess_ratio DESC
LIMIT 15;

-- Q2 Which Medical Condition has the Highest Readmission Rate?

SELECT
    condition_name,
    COUNT(DISTINCT facility_id) AS num_hospitals,
    ROUND(AVG(CAST(excess_readmission_ratio AS DECIMAL(10,4))), 4) AS avg_excess_ratio,
    ROUND(AVG(CAST(predicted_readmission_rate AS DECIMAL(10,4))), 4) AS avg_predicted_rate,
    ROUND(AVG(CAST(expected_readmission_rate AS DECIMAL(10,4))), 4) AS avg_expected_rate,
    SUM(CASE WHEN performance_flag = 'High Risk' THEN 1 ELSE 0 END) AS high_risk_hospitals
FROM hospital_data
GROUP BY condition_name
ORDER BY avg_excess_ratio DESC;

-- Q3 Does Hospital Size Affect Performance?

SELECT
    volume_category,
    COUNT(*) AS total_records,
    COUNT(DISTINCT facility_id) AS num_hospitals,
    ROUND(AVG(CAST(excess_readmission_ratio AS DECIMAL(10,4))), 4) AS avg_excess_ratio,
    SUM(CASE WHEN performance_flag = 'Good' THEN 1 ELSE 0 END) AS good_performers,
    SUM(CASE WHEN performance_flag = 'High Risk' THEN 1 ELSE 0 END) AS high_risk,
    SUM(CASE WHEN performance_flag = 'Average' THEN 1 ELSE 0 END) AS average_performers
FROM hospital_data
GROUP BY volume_category
ORDER BY
    CASE volume_category
        WHEN 'High Volume' THEN 1
        WHEN 'Medium Volume' THEN 2
        WHEN 'Low Volume' THEN 3
    END;

-- Q4 Top 10 Worst Performing Hospitals

SELECT
    facility_name,
    facility_id,
    state,
    COUNT(*) AS conditions_tracked,
    ROUND(AVG(CAST(excess_readmission_ratio AS DECIMAL(10,4))), 4) AS avg_excess_ratio,
    SUM(CASE WHEN performance_flag = 'High Risk' THEN 1 ELSE 0 END) AS high_risk_conditions,
    volume_category
FROM hospital_data
GROUP BY facility_name, facility_id, state, volume_category
HAVING avg_excess_ratio > 1.0
ORDER BY avg_excess_ratio DESC
LIMIT 10;

-- Q5- CTE: Hospitals that are High Risk Across Multiple Conditions

-- Step 1: CTE creates a temporary named result
WITH high_risk_summary AS (
    SELECT
        facility_name,
        facility_id,
        state,
        volume_category,
        COUNT(*) AS total_conditions,
        SUM(CASE WHEN performance_flag = 'High Risk' THEN 1 ELSE 0 END) AS high_risk_count,
        ROUND(AVG(CAST(excess_readmission_ratio AS DECIMAL(10,4))), 4) AS avg_excess_ratio
    FROM hospital_data
    GROUP BY facility_name, facility_id, state, volume_category
)

-- Step 2: Query FROM that temporary result
SELECT
    facility_name,
    state,
    volume_category,
    total_conditions,
    high_risk_count,
    avg_excess_ratio,
    ROUND(high_risk_count * 100.0 / total_conditions, 1) AS pct_conditions_high_risk
FROM high_risk_summary
WHERE high_risk_count >= 3
ORDER BY high_risk_count DESC, avg_excess_ratio DESC;







