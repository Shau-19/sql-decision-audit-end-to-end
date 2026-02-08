# Query 1: Payment Success Analysis

## 🎯 Purpose
Validate the metric that justified the rollout: payment success rate.

## 📊 Business Question
**Did Fast Checkout improve payment success rates during the A/B test?**

## 🔍 What This Query Does
Calculates and compares payment success rates between Control and Fast Checkout variants during February 2024 (the A/B test period).

---

## 📈 Results

| Variant | Total Attempts | Successful | Failed | Disputed | Success Rate | Lift |
|---------|---------------|------------|--------|----------|--------------|------|
| Control | 4,963 | 4,489 | 343 | 131 | **90.45%** | - |
| Fast Checkout | 5,008 | 4,672 | 230 | 106 | **93.29%** | **+2.84%** |

---

## 💡 Key Findings

✅ **Fast Checkout improved success rates by 2.84 percentage points**  
✅ **Failed payments decreased** (343 → 230)  
✅ **Disputed transactions decreased** (131 → 106)

---

## 🧠 Interpretation

This metric justified the rollout decision. Fast Checkout made more payments succeed and reduced both failures and disputes. From a pure conversion perspective, the decision looked data-driven and correct.

**But the question remains:** Did this conversion improvement translate to business value?

**→ Query 2 investigates revenue impact**

---

## 🔧 How It Works

### Core SQL Pattern
```sql
-- Count successful payments
SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) AS successful_payments

-- Calculate success rate
ROUND(100.0 * successful_payments / total_attempts, 2) AS success_rate

-- Calculate lift vs Control
LAG(success_rate) OVER (ORDER BY variant)
```

### Key Concepts Used
- **Conditional Aggregation:** `CASE WHEN` inside `SUM()`
- **Window Function:** `LAG()` to compare rows
- **Percentage Calculation:** Ratio × 100

---

## 🗣️ Interview Talking Point

> "Query 1 measures payment success rates during the A/B test. I filtered to February 2024, grouped by variant, and calculated success rates using conditional aggregation. The window function LAG compares Fast Checkout to Control, showing a +2.84% improvement. This metric justified the rollout."

---

## 📝 Business Context

**Why this metric was chosen:**
- Easy to understand (% of payments that succeed)
- Directly measures user experience
- Standard A/B test metric for checkout flows

**What it captures:**
- Transaction completion rates
- Technical success of payment processing

**What it misses:**
- Transaction value (covered in Query 2)
- User segment performance (covered in Query 3)
- Long-term costs (covered in Query 4)

---

**Next:** [Query 2 - Revenue Analysis](q2_revenue_analysis.md)