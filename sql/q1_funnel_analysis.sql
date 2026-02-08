-- ============================================================================
-- QUERY 1: Payment Success Analysis
-- ============================================================================
-- Purpose: Measure payment success rates during A/B test (Feb 2024)
-- Finding: Fast Checkout improved success rate by ~3%
-- ============================================================================

WITH experiment_metrics AS (
    SELECT 
        experiment_variant,
        COUNT(*) AS total_payment_attempts,
        SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) AS successful_payments,
        SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) AS failed_payments,
        SUM(CASE WHEN status = 'disputed' THEN 1 ELSE 0 END) AS disputed_payments
    FROM transactions
    WHERE DATE(timestamp) >= '2024-02-01'
      AND DATE(timestamp) < '2024-03-01'
    GROUP BY experiment_variant
)

SELECT 
    experiment_variant,
    total_payment_attempts,
    successful_payments,
    failed_payments,
    disputed_payments,
    ROUND(100.0 * successful_payments / total_payment_attempts, 2) AS success_rate_pct,
    ROUND(
        100.0 * successful_payments / total_payment_attempts - 
        LAG(100.0 * successful_payments / total_payment_attempts) OVER (ORDER BY experiment_variant),
        2
    ) AS lift_vs_control
FROM experiment_metrics
ORDER BY experiment_variant;