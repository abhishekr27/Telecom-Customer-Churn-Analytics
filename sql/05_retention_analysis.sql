-- ============================================================
-- TELECOM CUSTOMER CHURN ANALYTICS
-- 05 - Retention Analysis
-- Database: PostgreSQL
-- ============================================================


-- 1. Churn Rate by Tenure Group
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


-- 2. High-Risk Contract Segments
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
    ) AS churn_rate_percentage,

    ROUND(
        AVG(monthly_charge),
        2
    ) AS average_monthly_charge,

    ROUND(
        SUM(total_revenue),
        2
    ) AS total_revenue

FROM telecom_customer_churn_cleaned

GROUP BY contract

ORDER BY churn_rate_percentage DESC;


-- 3. Revenue at Risk by Contract
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

    ROUND(
        AVG(monthly_charge) FILTER (
            WHERE customer_status = 'Churned'
        ),
        2
    ) AS average_monthly_charge_of_churned

FROM telecom_customer_churn_cleaned

GROUP BY contract

ORDER BY revenue_at_risk DESC;


-- 4. High-Risk Contract + Internet Segments
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

    ROUND(
        SUM(total_revenue) FILTER (
            WHERE customer_status = 'Churned'
        ),
        2
    ) AS revenue_at_risk

FROM telecom_customer_churn_cleaned

WHERE internet_type IS NOT NULL

GROUP BY contract, internet_type

HAVING COUNT(*) >= 20

ORDER BY churn_rate_percentage DESC;


-- 5. High-Value Churned Customers
SELECT
    customer_id,
    age,
    age_group,
    city,
    tenure_in_months,
    contract,
    internet_type,
    payment_method,
    monthly_charge,
    total_revenue,
    churn_category,
    churn_reason

FROM telecom_customer_churn_cleaned

WHERE customer_status = 'Churned'

ORDER BY total_revenue DESC

LIMIT 25;


-- 6. High Monthly Charge + Churn Risk
SELECT
    CASE
        WHEN monthly_charge < 50 THEN '< $50'
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

    ROUND(
        SUM(total_revenue) FILTER (
            WHERE customer_status = 'Churned'
        ),
        2
    ) AS revenue_at_risk

FROM telecom_customer_churn_cleaned

GROUP BY monthly_charge_group

ORDER BY churn_rate_percentage DESC;


-- 7. Month-to-Month High-Risk Customers
SELECT
    COUNT(*) AS high_risk_customers,

    ROUND(
        SUM(total_revenue),
        2
    ) AS total_revenue_exposure,

    ROUND(
        AVG(monthly_charge),
        2
    ) AS average_monthly_charge

FROM telecom_customer_churn_cleaned

WHERE contract = 'Month-to-Month'
  AND monthly_charge >= 70
  AND customer_status = 'Churned';


-- 8. Retention Opportunity Segments
SELECT
    CASE
        WHEN contract = 'Month-to-Month'
             AND monthly_charge >= 70
             AND tenure_in_months <= 12
            THEN 'High Priority'

        WHEN contract = 'Month-to-Month'
             AND monthly_charge >= 70
            THEN 'Medium Priority'

        WHEN contract = 'Month-to-Month'
            THEN 'Monitor'

        ELSE 'Lower Priority'
    END AS retention_priority,

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

    ROUND(
        SUM(total_revenue),
        2
    ) AS total_revenue

FROM telecom_customer_churn_cleaned

GROUP BY retention_priority

ORDER BY
    CASE retention_priority
        WHEN 'High Priority' THEN 1
        WHEN 'Medium Priority' THEN 2
        WHEN 'Monitor' THEN 3
        ELSE 4
    END;


-- 9. Churn Category and Revenue Exposure
SELECT
    churn_category,

    COUNT(*) AS churned_customers,

    ROUND(
        SUM(total_revenue),
        2
    ) AS revenue_at_risk,

    ROUND(
        AVG(monthly_charge),
        2
    ) AS average_monthly_charge

FROM telecom_customer_churn_cleaned

WHERE customer_status = 'Churned'
  AND churn_category IS NOT NULL

GROUP BY churn_category

ORDER BY revenue_at_risk DESC;


-- 10. Churn Reason and Revenue Exposure
SELECT
    churn_reason,

    COUNT(*) AS churned_customers,

    ROUND(
        SUM(total_revenue),
        2
    ) AS revenue_at_risk,

    ROUND(
        AVG(monthly_charge),
        2
    ) AS average_monthly_charge

FROM telecom_customer_churn_cleaned

WHERE customer_status = 'Churned'
  AND churn_reason IS NOT NULL

GROUP BY churn_reason

ORDER BY revenue_at_risk DESC;


-- 11. Overall Retention Summary
SELECT
    COUNT(*) AS total_customers,

    COUNT(*) FILTER (
        WHERE customer_status = 'Stayed'
    ) AS retained_customers,

    COUNT(*) FILTER (
        WHERE customer_status = 'Churned'
    ) AS churned_customers,

    ROUND(
        COUNT(*) FILTER (
            WHERE customer_status = 'Stayed'
        ) * 100.0 / COUNT(*),
        2
    ) AS retention_rate_percentage,

    ROUND(
        COUNT(*) FILTER (
            WHERE customer_status = 'Churned'
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage,

    ROUND(
        SUM(total_revenue) FILTER (
            WHERE customer_status = 'Churned'
        ),
        2
    ) AS revenue_at_risk

FROM telecom_customer_churn_cleaned;
