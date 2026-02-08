-- ============================================================================
-- QUERY 6: Strategic Trade-Off Analysis
-- ============================================================================
-- Purpose: Segment-specific deployment recommendation
-- Finding: Deploy to high+medium risk, keep low risk on Control = 5x better
-- ============================================================================

WITH segment_metrics AS (
    SELECT 
        u.risk_score,
        t.experiment_variant,
        COUNT(*) AS total_attempts,
        SUM(CASE WHEN t.status = 'success' THEN 1 ELSE 0 END) AS successful_txns,
        ROUND(100.0 * SUM(CASE WHEN t.status = 'success' THEN 1 ELSE 0 END) / COUNT(*), 2) AS success_rate,
        
        -- Net revenue calculations
        ROUND(SUM(CASE WHEN t.status = 'success' THEN t.amount ELSE 0 END), 2) AS gross_revenue,
        ROUND(COALESCE(SUM(r.refund_amount), 0), 2) AS refunds,
        ROUND(
            SUM(CASE WHEN t.status = 'success' THEN t.amount ELSE 0 END) - COALESCE(SUM(r.refund_amount), 0),
            2
        ) AS net_revenue,
        ROUND(
            (SUM(CASE WHEN t.status = 'success' THEN t.amount ELSE 0 END) - COALESCE(SUM(r.refund_amount), 0)) / COUNT(*),
            2
        ) AS net_revenue_per_attempt
        
    FROM transactions t
    JOIN users u ON t.user_id = u.user_id
    LEFT JOIN refunds r ON t.transaction_id = r.transaction_id
    WHERE DATE(t.timestamp) >= '2024-02-01'
      AND DATE(t.timestamp) < '2024-03-01'
    GROUP BY u.risk_score, t.experiment_variant
)

SELECT 
    risk_score,
    experiment_variant,
    total_attempts,
    success_rate || '%' AS success_rate_pct,
    '$' || net_revenue AS net_revenue,
    '$' || net_revenue_per_attempt AS net_rev_per_attempt,
    
    -- Calculate lift vs control for this segment
    ROUND(
        net_revenue_per_attempt - LAG(net_revenue_per_attempt) OVER (PARTITION BY risk_score ORDER BY experiment_variant),
        2
    ) AS net_rev_lift_dollars,
    
    -- Recommendation
    CASE 
        WHEN experiment_variant = 'control' THEN ''
        WHEN (net_revenue_per_attempt - LAG(net_revenue_per_attempt) OVER (PARTITION BY risk_score ORDER BY experiment_variant)) > 0 
        THEN '✓ Deploy to this segment'
        ELSE '✗ Keep on Control'
    END AS rollout_recommendation
    
FROM segment_metrics
ORDER BY risk_score, experiment_variant;