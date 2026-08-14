-- ============================================================
-- TELECOM CUSTOMER CHURN ANALYTICS
-- 03 - Revenue Analysis
-- Database: PostgreSQL
-- ============================================================


-- 1. Overall Revenue Summary
SELECT
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_revenue_per_customer,
    ROUND(AVG(monthly_charge), 2) AS average_monthly_charge
FROM telecom_customer_churn_cleaned;


-- 2. Revenue by Customer Status
SELECT
    customer_status,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_revenue
FROM telecom_customer_churn_cleaned
GROUP BY customer_status
ORDER BY total_revenue DESC;


-- 3. Revenue by Contract
SELECT
    contract,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_revenue,
    ROUND(AVG(monthly_charge), 2) AS average_monthly_charge
FROM telecom_customer_churn_cleaned
GROUP BY contract
ORDER BY total_revenue DESC;


-- 4. Revenue by Internet Type
SELECT
    internet_type,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_revenue
FROM telecom_customer_churn_cleaned
WHERE internet_type IS NOT NULL
GROUP BY internet_type
ORDER BY total_revenue DESC;


-- 5. Revenue by Payment Method
SELECT
    payment_method,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_revenue,
    ROUND(AVG(monthly_charge), 2) AS average_monthly_charge
FROM telecom_customer_churn_cleaned
GROUP BY payment_method
ORDER BY total_revenue DESC;


-- 6. Revenue by Gender
SELECT
    gender,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_revenue
FROM telecom_customer_churn_cleaned
GROUP BY gender
ORDER BY total_revenue DESC;


-- 7. Revenue by Age Group
SELECT
    age_group,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_revenue
FROM telecom_customer_churn_cleaned
GROUP BY age_group
ORDER BY total_revenue DESC;


-- 8. Revenue by City
SELECT
    city,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_revenue
FROM telecom_customer_churn_cleaned
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 10;


-- 9. Revenue Lost from Churned Customers
SELECT
    COUNT(*) AS churned_customers,
    ROUND(SUM(total_revenue), 2) AS churned_customer_revenue,
    ROUND(AVG(total_revenue), 2) AS average_revenue_per_churned_customer
FROM telecom_customer_churn_cleaned
WHERE customer_status = 'Churned';


-- 10. Revenue by Contract and Customer Status
SELECT
    contract,
    customer_status,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_revenue
FROM telecom_customer_churn_cleaned
GROUP BY contract, customer_status
ORDER BY contract, total_revenue DESC;


-- 11. Revenue Exposure by Contract
SELECT
    contract,
    COUNT(*) FILTER (
        WHERE customer_status = 'Churned'
    ) AS churned_customers,
    ROUND(
        SUM(total_revenue) FILTER (
            WHERE customer_status = 'Churned'
        ),
        2
    ) AS revenue_at_risk,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM telecom_customer_churn_cleaned
GROUP BY contract
ORDER BY revenue_at_risk DESC;


-- 12. High-Revenue Churned Customers
SELECT
    customer_id,
    contract,
    internet_type,
    tenure_in_months,
    monthly_charge,
    total_revenue,
    churn_category,
    churn_reason
FROM telecom_customer_churn_cleaned
WHERE customer_status = 'Churned'
ORDER BY total_revenue DESC
LIMIT 20;


-- 13. Revenue by Monthly Charge Range
SELECT
    CASE
        WHEN monthly_charge < 30 THEN '< $30'
        WHEN monthly_charge < 50 THEN '$30-$50'
        WHEN monthly_charge < 70 THEN '$50-$70'
        WHEN monthly_charge < 90 THEN '$70-$90'
        ELSE '$90+'
    END AS monthly_charge_group,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(monthly_charge), 2) AS average_monthly_charge
FROM telecom_customer_churn_cleaned
GROUP BY monthly_charge_group
ORDER BY
    CASE
        WHEN monthly_charge_group = '< $30' THEN 1
        WHEN monthly_charge_group = '$30-$50' THEN 2
        WHEN monthly_charge_group = '$50-$70' THEN 3
        WHEN monthly_charge_group = '$70-$90' THEN 4
        ELSE 5
    END;


-- 14. Revenue and Churn Rate by Monthly Charge Range
SELECT
    CASE
        WHEN monthly_charge < 30 THEN '< $30'
        WHEN monthly_charge < 50 THEN '$30-$50'
        WHEN monthly_charge < 70 THEN '$50-$70'
        WHEN monthly_charge < 90 THEN '$70-$90'
        ELSE '$90+'
    END AS monthly_charge_group,
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
GROUP BY monthly_charge_group
ORDER BY churn_rate_percentage DESC;
