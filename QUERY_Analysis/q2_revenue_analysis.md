# Query 2: Revenue Analysis

## 🎯 Purpose
Determine if the conversion improvement translated to proportional revenue growth.

## 📊 Business Question
**Did Fast Checkout's +2.84% conversion improvement result in meaningful revenue gains?**

## 🔍 What This Query Does
Calculates total revenue, average transaction value, and revenue per attempt for each variant. Compares revenue metrics to conversion metrics from Query 1.

---

## 📈 Results

| Variant | Total Revenue | Avg Transaction | Revenue/Attempt | Lift |
|---------|---------------|-----------------|-----------------|------|
| Control | $504,101.72 | $118.53 | $107.21 | - |
| Fast Checkout | $524,468.43 | $116.69 | $108.86 | **+3.16%** |

---

## 💡 Key Findings

✅ **Net revenue improved by 3.16%** (positive outcome)  
⚠️ **Revenue growth (+3.16%) roughly matched conversion growth (+2.84%)**  
⚠️ **Average transaction value declined** ($118.53 → $116.69, -$1.84 per transaction)

---

## 🧠 Interpretation

While technically positive, this raises questions:
- Why did average transaction values drop?
- Is the conversion improvement bringing in lower-value transactions?
- Are different user segments behaving differently?

The declining transaction value suggests **composition effects** — Fast Checkout may be attracting a different mix of users or transaction types.

**This warrants deeper investigation into WHO is benefiting.**

**→ Query 3 performs segment analysis**

---

## 🔧 How It Works

### Core SQL Patterns
```sql
-- Total revenue (successful transactions only)
SUM(CASE WHEN status = 'success' THEN amount ELSE 0 END) AS total_revenue

-- Average transaction value (NULL excludes failures from average)
AVG(CASE WHEN status = 'success' THEN amount ELSE NULL END) AS avg_transaction

-- Revenue per attempt (includes all attempts)
total_revenue / COUNT(*) AS revenue_per_attempt
```

### Key Concepts Used
- **Conditional Aggregation:** Different logic for SUM vs AVG
- **NULL vs 0:** NULL excludes from average, 0 includes as zero
- **Revenue Decomposition:** Breaking down by different metrics

---

## 🗣️ Interview Talking Point

> "Query 2 analyzes revenue impact. While Fast Checkout improved conversion, I needed to verify this translated to business value. I calculated total revenue, average transaction value, and revenue per attempt. Results showed modest revenue growth (+3.16%) with declining transaction values (-$1.84), suggesting composition changes worth investigating in Query 3."

---

## 📝 Why This Matters

**The disconnect:**
- **Conversion:** +2.84% ✅
- **Revenue growth:** +3.16% ✅
- **Avg transaction value:** -$1.84 ⚠️

This pattern suggests Fast Checkout is either:
1. Processing more lower-value transactions
2. Attracting different user types
3. Changing user behavior

**All of these point to the need for segment analysis.**

---

## 🔗 Connection to Query 1

| Query | Metric | Result |
|-------|--------|--------|
| Query 1 | Conversion rate | +2.84% |
| Query 2 | Revenue growth | +3.16% |
| **Gap** | Transaction value | -$1.84 |

The gap between conversion improvement and transaction value decline is the first red flag.

---

**Previous:** [Query 1 - Success Analysis](q1_funnel_analysis.md)  
**Next:** [Query 3 - Segment Analysis](q3_segment_impact.md)