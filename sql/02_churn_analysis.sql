-- ============================================================
-- TELECOM CUSTOMER CHURN ANALYTICS
-- 02 - Churn Analysis
-- Database: PostgreSQL
-- ============================================================


-- 1. Churn Rate by Contract
SELECT
    contract,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE customer_status = 'Churned'
    ) AS churned_customers,
    ROUND(
        COUNT(*) FILTER (
            WHERE customer_status = 'Churned'
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM telecom_customer_churn_cleaned
GROUP BY contract
ORDER BY churn_rate_percentage DESC;


-- 2. Churn Rate by Internet Type
SELECT
    internet_type,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE customer_status = 'Churned'
    ) AS churned_customers,
    ROUND(
        COUNT(*) FILTER (
            WHERE customer_status = 'Churned'
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM telecom_customer_churn_cleaned
WHERE internet_type IS NOT NULL
GROUP BY internet_type
ORDER BY churn_rate_percentage DESC;


-- 3. Churn Rate by Internet Service
SELECT
    internet_service,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE customer_status = 'Churned'
    ) AS churned_customers,
    ROUND(
        COUNT(*) FILTER (
            WHERE customer_status = 'Churned'
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM telecom_customer_churn_cleaned
GROUP BY internet_service
ORDER BY churn_rate_percentage DESC;


-- 4. Churn Rate by Gender
SELECT
    gender,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE customer_status = 'Churned'
    ) AS churned_customers,
    ROUND(
        COUNT(*) FILTER (
            WHERE customer_status = 'Churned'
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM telecom_customer_churn_cleaned
GROUP BY gender
ORDER BY churn_rate_percentage DESC;


-- 5. Churn Rate by Age Group
SELECT
    age_group,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE customer_status = 'Churned'
    ) AS churned_customers,
    ROUND(
        COUNT(*) FILTER (
            WHERE customer_status = 'Churned'
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM telecom_customer_churn_cleaned
GROUP BY age_group
ORDER BY churn_rate_percentage DESC;


-- 6. Churn Rate by Payment Method
SELECT
    payment_method,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE customer_status = 'Churned'
    ) AS churned_customers,
    ROUND(
        COUNT(*) FILTER (
            WHERE customer_status = 'Churned'
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM telecom_customer_churn_cleaned
GROUP BY payment_method
ORDER BY churn_rate_percentage DESC;


-- 7. Churn Rate by Monthly Charge Group
SELECT
    "Monthly Charge Group",
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE customer_status = 'Churned'
    ) AS churned_customers,
    ROUND(
        COUNT(*) FILTER (
            WHERE customer_status = 'Churned'
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM telecom_customer_churn_cleaned
GROUP BY "Monthly Charge Group"
ORDER BY churn_rate_percentage DESC;


-- 8. Churn Rate by Tenure Group
SELECT
    CASE
        WHEN tenure_in_months <= 6 THEN '0-6 Months'
        WHEN tenure_in_months <= 12 THEN '7-12 Months'
        WHEN tenure_in_months <= 24 THEN '13-24 Months'
        WHEN tenure_in_months <= 36 THEN '25-36 Months'
        WHEN tenure_in_months <= 60 THEN '37-60 Months'
        ELSE '60+ Months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE customer_status = 'Churned'
    ) AS churned_customers,
    ROUND(
        COUNT(*) FILTER (
            WHERE customer_status = 'Churned'
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM telecom_customer_churn_cleaned
GROUP BY tenure_group
ORDER BY churn_rate_percentage DESC;


-- 9. Top Churn Reasons
SELECT
    churn_reason,
    COUNT(*) AS churned_customers
FROM telecom_customer_churn_cleaned
WHERE customer_status = 'Churned'
  AND churn_reason IS NOT NULL
GROUP BY churn_reason
ORDER BY churned_customers DESC;


-- 10. Churn Category Distribution
SELECT
    churn_category,
    COUNT(*) AS churned_customers
FROM telecom_customer_churn_cleaned
WHERE customer_status = 'Churned'
  AND churn_category IS NOT NULL
GROUP BY churn_category
ORDER BY churned_customers DESC;


-- 11. Churn by Contract and Internet Type
SELECT
    contract,
    internet_type,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE customer_status = 'Churned'
    ) AS churned_customers,
    ROUND(
        COUNT(*) FILTER (
            WHERE customer_status = 'Churned'
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM telecom_customer_churn_cleaned
WHERE internet_type IS NOT NULL
GROUP BY contract, internet_type
ORDER BY churn_rate_percentage DESC;


-- 12. High-Risk Customer Segments
SELECT
    contract,
    internet_type,
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE customer_status = 'Churned'
    ) AS churned_customers,
    ROUND(
        COUNT(*) FILTER (
            WHERE customer_status = 'Churned'
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM telecom_customer_churn_cleaned
WHERE internet_type IS NOT NULL
GROUP BY contract, internet_type
HAVING COUNT(*) FILTER (
    WHERE customer_status = 'Churned'
) > 0
ORDER BY churn_rate_percentage DESC;
