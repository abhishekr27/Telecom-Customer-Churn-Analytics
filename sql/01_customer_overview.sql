-- ============================================================
-- TELECOM CUSTOMER CHURN ANALYTICS
-- 01 - Customer Overview
-- Database: PostgreSQL
-- ============================================================


-- 1. Total Customers
SELECT
    COUNT(*) AS total_customers
FROM telecom_customer_churn_cleaned;


-- 2. Customer Status Distribution
SELECT
    customer_status,
    COUNT(*) AS customer_count
FROM telecom_customer_churn_cleaned
GROUP BY customer_status
ORDER BY customer_count DESC;


-- 3. Churned Customers
SELECT
    COUNT(*) AS churned_customers
FROM telecom_customer_churn_cleaned
WHERE customer_status = 'Churned';


-- 4. Stayed Customers
SELECT
    COUNT(*) AS stayed_customers
FROM telecom_customer_churn_cleaned
WHERE customer_status = 'Stayed';


-- 5. Overall Churn Rate
SELECT
    ROUND(
        COUNT(*) FILTER (WHERE customer_status = 'Churned') * 100.0
        / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM telecom_customer_churn_cleaned;


-- 6. Average Monthly Charge
SELECT
    ROUND(AVG(monthly_charge), 2) AS average_monthly_charge
FROM telecom_customer_churn_cleaned;


-- 7. Total Revenue
SELECT
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM telecom_customer_churn_cleaned;


-- 8. Average Customer Tenure
SELECT
    ROUND(AVG(tenure_in_months), 2) AS average_tenure_months
FROM telecom_customer_churn_cleaned;


-- 9. Customer Overview Summary
SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (
        WHERE customer_status = 'Churned'
    ) AS churned_customers,
    COUNT(*) FILTER (
        WHERE customer_status = 'Stayed'
    ) AS stayed_customers,
    ROUND(
        COUNT(*) FILTER (
            WHERE customer_status = 'Churned'
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage,
    ROUND(AVG(monthly_charge), 2) AS average_monthly_charge,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(tenure_in_months), 2) AS average_tenure_months
FROM telecom_customer_churn_cleaned;
