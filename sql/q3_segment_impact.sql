-- ============================================================================
-- QUERY 3: Segment Impact Analysis (KEY INSIGHT)
-- ============================================================================
-- Purpose: Performance breakdown by user risk segment
-- Finding: High-risk +$29, Medium +$11, Low -$5 per attempt
-- Key Insight: Simpson's Paradox - aggregate masks segment variation
-- ============================================================================

WITH segment_performance AS (
    SELECT 
        t.experiment_variant,
        u.risk_score,
        COUNT(*) AS total_attempts,
        SUM(CASE WHEN t.status = 'success' THEN 1 ELSE 0 END) AS successful_txns,
        ROUND(100.0 * SUM(CASE WHEN t.status = 'success' THEN 1 ELSE 0 END) / COUNT(*), 2) AS success_rate,
        ROUND(SUM(CASE WHEN t.status = 'success' THEN t.amount ELSE 0 END), 2) AS total_revenue,
        ROUND(AVG(CASE WHEN t.status = 'success' THEN t.amount ELSE NULL END), 2) AS avg_txn_value
    FROM transactions t
    JOIN users u ON t.user_id = u.user_id
    WHERE DATE(t.timestamp) >= '2024-02-01'
      AND DATE(t.timestamp) < '2024-03-01'
    GROUP BY t.experiment_variant, u.risk_score
)

SELECT 
    risk_score,
    experiment_variant,
    total_attempts,
    successful_txns,
    success_rate || '%' AS success_rate_pct,
    '$' || total_revenue AS total_revenue,
    '$' || avg_txn_value AS avg_txn_value,
    ROUND(
        success_rate - LAG(success_rate) OVER (PARTITION BY risk_score ORDER BY experiment_variant),
        2
    ) AS success_rate_lift
FROM segment_performance
ORDER BY risk_score, experiment_variant;