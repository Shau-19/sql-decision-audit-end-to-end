-- ============================================================================
-- QUERY 2: Revenue Analysis
-- ============================================================================
-- Purpose: Analyze revenue impact and transaction value trends
-- Finding: Revenue growth (+3.16%) with declining avg transaction value
-- ============================================================================

WITH revenue_metrics AS (
    SELECT 
        experiment_variant,
        COUNT(*) AS total_transactions,
        SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) AS successful_txns,
        ROUND(SUM(CASE WHEN status = 'success' THEN amount ELSE 0 END), 2) AS total_revenue,
        ROUND(AVG(CASE WHEN status = 'success' THEN amount ELSE NULL END), 2) AS avg_transaction_value,
        ROUND(SUM(CASE WHEN status = 'success' THEN amount ELSE 0 END) / COUNT(*), 2) AS revenue_per_attempt
    FROM transactions
    WHERE DATE(timestamp) >= '2024-02-01'
      AND DATE(timestamp) < '2024-03-01'
    GROUP BY experiment_variant
)

SELECT 
    experiment_variant,
    total_transactions,
    successful_txns,
    '$' || total_revenue AS total_revenue,
    '$' || avg_transaction_value AS avg_txn_value,
    '$' || revenue_per_attempt AS revenue_per_attempt,
    ROUND(
        100.0 * (total_revenue - LAG(total_revenue) OVER (ORDER BY experiment_variant)) 
        / NULLIF(LAG(total_revenue) OVER (ORDER BY experiment_variant), 0),
        2
    ) AS revenue_lift_pct
FROM revenue_metrics
ORDER BY experiment_variant;