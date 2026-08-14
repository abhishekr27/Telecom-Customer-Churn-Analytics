-- ============================================================
-- TELECOM CUSTOMER CHURN ANALYTICS
-- 04 - Service & Subscription Analysis
-- Database: PostgreSQL
-- ============================================================


-- 1. Phone Service Adoption
SELECT
    phone_service,
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
GROUP BY phone_service
ORDER BY churn_rate_percentage DESC;


-- 2. Multiple Lines Adoption
SELECT
    multiple_lines,
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
WHERE multiple_lines IS NOT NULL
GROUP BY multiple_lines
ORDER BY churn_rate_percentage DESC;


-- 3. Internet Service Adoption
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
ORDER BY total_customers DESC;


-- 4. Internet Type Analysis
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
ORDER BY total_customers DESC;


-- 5. Online Security Analysis
SELECT
    online_security,
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
WHERE online_security IS NOT NULL
GROUP BY online_security
ORDER BY churn_rate_percentage DESC;


-- 6. Online Backup Analysis
SELECT
    online_backup,
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
WHERE online_backup IS NOT NULL
GROUP BY online_backup
ORDER BY churn_rate_percentage DESC;


-- 7. Device Protection Analysis
SELECT
    device_protection_plan,
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
WHERE device_protection_plan IS NOT NULL
GROUP BY device_protection_plan
ORDER BY churn_rate_percentage DESC;


-- 8. Premium Tech Support Analysis
SELECT
    premium_tech_support,
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
WHERE premium_tech_support IS NOT NULL
GROUP BY premium_tech_support
ORDER BY churn_rate_percentage DESC;


-- 9. Streaming TV Analysis
SELECT
    streaming_tv,
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
WHERE streaming_tv IS NOT NULL
GROUP BY streaming_tv
ORDER BY churn_rate_percentage DESC;


-- 10. Streaming Movies Analysis
SELECT
    streaming_movies,
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
WHERE streaming_movies IS NOT NULL
GROUP BY streaming_movies
ORDER BY churn_rate_percentage DESC;


-- 11. Streaming Music Analysis
SELECT
    streaming_music,
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
WHERE streaming_music IS NOT NULL
GROUP BY streaming_music
ORDER BY churn_rate_percentage DESC;


-- 12. Unlimited Data Analysis
SELECT
    unlimited_data,
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
WHERE unlimited_data IS NOT NULL
GROUP BY unlimited_data
ORDER BY churn_rate_percentage DESC;


-- 13. Contract & Service Analysis
SELECT
    contract,
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
    ) AS churn_rate_percentage,
    ROUND(AVG(monthly_charge), 2) AS average_monthly_charge
FROM telecom_customer_churn_cleaned
GROUP BY contract, internet_service
ORDER BY churn_rate_percentage DESC;


-- 14. Customers Using Multiple Services
SELECT
    contract,
    COUNT(*) AS total_customers,
    ROUND(
        AVG(
            CASE
                WHEN online_security = 'Yes'
                  AND online_backup = 'Yes'
                  AND device_protection_plan = 'Yes'
                  AND premium_tech_support = 'Yes'
                THEN 1
                ELSE 0
            END
        ) * 100,
        2
    ) AS percentage_with_all_support_services,
    ROUND(
        COUNT(*) FILTER (
            WHERE customer_status = 'Churned'
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM telecom_customer_churn_cleaned
GROUP BY contract
ORDER BY churn_rate_percentage DESC;
