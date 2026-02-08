-- ============================================================================
-- QUERY 4: Downstream Costs Analysis
-- ============================================================================
-- Purpose: Measure operational costs (refunds, disputes, support tickets)
-- Finding: Costs remained stable - validates pure optimization opportunity
-- ============================================================================

-- Refund Analysis (Successful Transactions Only)
WITH refund_metrics AS (
    SELECT 
        t.experiment_variant,
        COUNT(DISTINCT t.transaction_id) AS successful_transactions,
        COUNT(DISTINCT r.refund_id) AS refunds_on_success,
        ROUND(100.0 * COUNT(DISTINCT r.refund_id) / COUNT(DISTINCT t.transaction_id), 2) AS refund_rate,
        ROUND(SUM(r.refund_amount), 2) AS total_refund_amount
    FROM transactions t
    LEFT JOIN refunds r ON t.transaction_id = r.transaction_id
    WHERE t.status = 'success'
      AND DATE(t.timestamp) >= '2024-02-01'
      AND DATE(t.timestamp) < '2024-03-01'
    GROUP BY t.experiment_variant
)
SELECT 
    experiment_variant,
    successful_transactions,
    refunds_on_success,
    refund_rate || '%' AS refund_rate_pct,
    '$' || total_refund_amount AS total_refunded,
    ROUND(
        refund_rate - LAG(refund_rate) OVER (ORDER BY experiment_variant),
        2
    ) AS refund_rate_change_pct
FROM refund_metrics
ORDER BY experiment_variant;

-- Dispute Analysis  
WITH dispute_metrics AS (
    SELECT 
        experiment_variant,
        COUNT(*) AS total_transactions,
        SUM(CASE WHEN status = 'disputed' THEN 1 ELSE 0 END) AS disputed_transactions,
        ROUND(100.0 * SUM(CASE WHEN status = 'disputed' THEN 1 ELSE 0 END) / COUNT(*), 2) AS dispute_rate
    FROM transactions
    WHERE DATE(timestamp) >= '2024-02-01'
      AND DATE(timestamp) < '2024-03-01'
    GROUP BY experiment_variant
)
SELECT 
    experiment_variant,
    total_transactions,
    disputed_transactions,
    dispute_rate || '%' AS dispute_rate_pct,
    ROUND(
        dispute_rate - LAG(dispute_rate) OVER (ORDER BY experiment_variant),
        2
    ) AS dispute_rate_change
FROM dispute_metrics
ORDER BY experiment_variant;

-- Support Ticket Analysis
WITH support_metrics AS (
    SELECT 
        t.experiment_variant,
        COUNT(DISTINCT t.transaction_id) AS total_transactions,
        COUNT(DISTINCT s.ticket_id) AS total_tickets,
        ROUND(100.0 * COUNT(DISTINCT s.ticket_id) / COUNT(DISTINCT t.transaction_id), 2) AS ticket_rate,
        ROUND(AVG(s.resolution_time), 1) AS avg_resolution_hours
    FROM transactions t
    LEFT JOIN support_tickets s ON t.user_id = s.user_id
        AND DATE(s.timestamp) BETWEEN DATE(t.timestamp) AND DATE(t.timestamp, '+7 days')
    WHERE DATE(t.timestamp) >= '2024-02-01'
      AND DATE(t.timestamp) < '2024-03-01'
    GROUP BY t.experiment_variant
)
SELECT 
    experiment_variant,
    total_transactions,
    total_tickets,
    ticket_rate || '%' AS ticket_rate_pct,
    avg_resolution_hours || ' hrs' AS avg_resolution_time,
    ROUND(
        ticket_rate - LAG(ticket_rate) OVER (ORDER BY experiment_variant),
        2
    ) AS ticket_rate_change
FROM support_metrics
ORDER BY experiment_variant;