-- Hospital Readmission Analysis
-- MySQL Queries by Darryl Sosthenes
-- Dataset: CMS HRRP via Kaggle

-- ================================================
-- Q1: Which States Have the Worst Readmission Problem?
-- ================================================
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

-- ================================================
-- Q2: Which Medical Condition Has the Highest Readmission Rate?
-- ================================================
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

-- ================================================
-- Q3: Does Hospital Size Affect Performance?
-- ================================================
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

-- ================================================
-- Q4: Top 10 Worst Performing Hospitals
-- ================================================
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

-- ================================================
-- Q5 (CTE): Hospitals High Risk Across 3+ Conditions
-- ================================================
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