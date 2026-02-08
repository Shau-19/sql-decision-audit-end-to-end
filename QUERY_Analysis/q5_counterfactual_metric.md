# Query 5: Counterfactual Metric Analysis

## 🎯 Purpose
Evaluate what would have happened if we'd measured net revenue per attempt instead of success rate.

## 📊 Business Question
**Would a better metric have led to a different rollout decision?**

## 🔍 What This Query Does
Compares two metrics side-by-side:
- **Old Metric:** Payment success rate (what was actually used)
- **Better Metric:** Net revenue per attempt (what should have been used)

Then shows what decision each metric would have recommended.

---

## 📈 Results

| Metric Type | Control | Fast Checkout | Lift | Decision |
|-------------|---------|---------------|------|----------|
| **Old Metric**<br>(Success Rate) | 90.45% | 93.29% | +2.84% | ✅ Approve rollout |
| **Better Metric**<br>(Net Rev/Attempt) | $101.57 | $104.73 | +$3.16 | ✅ Would also approve |

---

## 💡 Key Findings

✅ **Both metrics showed improvement**  
✅ **Both would have led to rollout approval**  
⚠️ **But the better metric provides richer signal for segment analysis**

---

## 🧠 Interpretation

**Initial expectation:**
We thought the better metric would have rejected the rollout (Query 5 header suggested this).

**Actual finding:**
Both metrics showed positive results (+2.84% and +$3.16), so both would have approved rollout.

**The real insight:**
The problem wasn't the metric choice—it was the **lack of segment-level analysis**.

If we had:
1. Used net revenue per attempt (better metric) ✅
2. **AND broken it down by segment** ✅
3. We would have seen the +$29/-$5 variation immediately

**This emphasizes:** Always analyze metrics by key segments, regardless of which metric you choose.

---

## 🔧 How It Works

### The Better Metric Formula
```sql
Net Revenue per Attempt = (Gross Revenue - Refunds) / Total Attempts
```

**Why it's better:**
- Captures **conversion** (successful transactions)
- Captures **transaction value** (amount per transaction)
- Captures **refund costs** (actual revenue retained)
- Aligns with **business outcomes** (money in the bank)

### SQL Logic
```sql
-- Calculate both metrics in one CTE
WITH metrics_comparison AS (
    -- Old: Success rate
    success_rate = successful_payments / total_attempts
    
    -- Better: Net revenue per attempt
    net_revenue_per_attempt = (gross_revenue - refunds) / total_attempts
)

-- Compare decisions
CASE 
    WHEN net_revenue_per_attempt > LAG(net_revenue_per_attempt) 
    THEN 'Would approve'
    ELSE 'Would reject'
END
```

---

## 🗣️ Interview Talking Point

> "Query 5 compares the metric that was used (success rate) with a better alternative (net revenue per attempt). Interestingly, both showed improvement, so both would have approved the rollout. This reveals that the issue wasn't metric choice—it was the lack of segment-level analysis. Even the best aggregate metric can mask segment variation. This taught me to always break down metrics by key dimensions."

---

## 📝 Why Net Revenue Per Attempt is Better

| Aspect | Success Rate | Net Revenue/Attempt |
|--------|--------------|---------------------|
| **Measures** | % of successful payments | $ retained per attempt |
| **Captures value** | ❌ No | ✅ Yes |
| **Captures refunds** | ❌ No | ✅ Yes |
| **Aligns with business** | Partially | ✅ Directly |
| **Example** | 90% success | $105 per attempt |

**The lesson:**
Choose metrics that directly predict business outcomes.

---

## 🔗 Connection to Analysis Framework

| Query | Question | Learning |
|-------|----------|----------|
| Query 1-2 | Did metrics improve? | Yes, but modestly |
| Query 3 | Segment variation? | Massive (+$29 to -$5) |
| Query 4 | Cost problems? | No |
| **Query 5** | **Better metric?** | **Yes, but still need segments** |
| Query 6 | Optimal strategy? | Selective deployment |

**Key insight:** Metric + Segmentation = Complete picture

---

## 💡 The Deeper Lesson

**Not just "what metric"** but **"at what level"**

Even if we had used the perfect metric (net revenue per attempt), if we'd only looked at **aggregate** results (+$3.16), we'd still have missed the opportunity.

**The winning combination:**
1. Revenue-aligned metric ✅
2. Segment-level analysis ✅
3. Strategic deployment ✅

---

## 📊 Visual Comparison

**What leadership saw (aggregate):**
```
Control:       $101.57 per attempt
Fast Checkout: $104.73 per attempt (+$3.16)
Decision: Approve ✅
```

**What they should have also seen (segments):**
```
High-risk:   $71.81 → $100.90 (+$29.09) ✅
Medium-risk: $92.44 → $103.13 (+$10.69) ✅
Low-risk:    $111.26 → $106.13 (-$5.13) ❌
```

**The complete picture changes the decision from "blanket rollout" to "selective deployment"**

---

**Previous:** [Query 4 - Downstream Costs](q4_downstream_costs.md)  
**Next:** [Query 6 - Strategic Recommendation](q6_tradeoff_analysis.md)