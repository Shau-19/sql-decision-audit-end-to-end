-- ============================================================================
-- QUERY 5: Counterfactual Metric Analysis
-- ============================================================================
-- Purpose: Compare old metric (success rate) vs better metric (net revenue/attempt)
-- Finding: Both showed improvement - validates need for segment analysis
-- ============================================================================

WITH metrics_comparison AS (
    SELECT 
        t.experiment_variant,
        
        -- OLD METRIC: Payment success rate
        COUNT(*) AS total_attempts,
        SUM(CASE WHEN t.status = 'success' THEN 1 ELSE 0 END) AS successful_payments,
        ROUND(100.0 * SUM(CASE WHEN t.status = 'success' THEN 1 ELSE 0 END) / COUNT(*), 2) AS success_rate,
        
        -- BETTER METRIC: Net revenue per attempt (after refunds)
        ROUND(SUM(CASE WHEN t.status = 'success' THEN t.amount ELSE 0 END), 2) AS gross_revenue,
        ROUND(COALESCE(SUM(r.refund_amount), 0), 2) AS total_refunds,
        ROUND(
            SUM(CASE WHEN t.status = 'success' THEN t.amount ELSE 0 END) - COALESCE(SUM(r.refund_amount), 0),
            2
        ) AS net_revenue,
        ROUND(
            (SUM(CASE WHEN t.status = 'success' THEN t.amount ELSE 0 END) - COALESCE(SUM(r.refund_amount), 0)) / COUNT(*),
            2
        ) AS net_revenue_per_attempt
        
    FROM transactions t
    LEFT JOIN refunds r ON t.transaction_id = r.transaction_id
    WHERE DATE(t.timestamp) >= '2024-02-01'
      AND DATE(t.timestamp) < '2024-03-01'
    GROUP BY t.experiment_variant
)

SELECT 
    experiment_variant,
    total_attempts,
    
    -- OLD METRIC (what was optimized)
    success_rate || '%' AS old_metric_success_rate,
    ROUND(
        success_rate - LAG(success_rate) OVER (ORDER BY experiment_variant),
        2
    ) AS old_metric_lift_pct,
    
    -- BETTER METRIC (what should have been optimized)
    '$' || net_revenue AS net_revenue_total,
    '$' || net_revenue_per_attempt AS better_metric_net_rev_per_attempt,
    ROUND(
        net_revenue_per_attempt - LAG(net_revenue_per_attempt) OVER (ORDER BY experiment_variant),
        2
    ) AS better_metric_lift_dollars,
    
    -- DECISION IMPACT
    CASE 
        WHEN experiment_variant = 'control' THEN 'Baseline'
        WHEN net_revenue_per_attempt > LAG(net_revenue_per_attempt) OVER (ORDER BY experiment_variant) 
        THEN '✓ Would approve rollout'
        ELSE '✗ Would REJECT rollout'
    END AS decision_under_better_metric
    
FROM metrics_comparison
ORDER BY experiment_variant;