# Query 4: Downstream Costs Analysis

## 🎯 Purpose
Identify if Fast Checkout caused hidden operational costs (refunds, disputes, support tickets).

## 📊 Business Question
**Did the segment issues manifest as increased operational costs?**

## 🔍 What This Query Does
Measures three cost metrics across variants:
1. Refund rates on successful transactions
2. Dispute rates on all transactions
3. Support ticket volume and resolution time

---

## 📈 Results

### Refund Analysis (Successful Transactions)
| Variant | Successful Txns | Refunds | Refund Rate | Total Refunded |
|---------|-----------------|---------|-------------|----------------|
| Control | 4,489 | 95 | 2.12% | $9,934.12 |
| Fast Checkout | 4,672 | 99 | 2.12% | $10,311.63 |

### Dispute Analysis
| Variant | Total Txns | Disputes | Dispute Rate | Change |
|---------|-----------|----------|--------------|--------|
| Control | 4,963 | 131 | 2.64% | - |
| Fast Checkout | 5,008 | 106 | 2.12% | -0.52% |

### Support Ticket Analysis
| Variant | Tickets | Ticket Rate | Avg Resolution |
|---------|---------|-------------|----------------|
| Control | 296 | 5.96% | 37.8 hrs |
| Fast Checkout | 253 | 5.05% | 36.7 hrs |

---

## 💡 Key Findings

✅ **Refund rates identical** (2.12% both variants)  
✅ **Dispute rates lower** in Fast Checkout (2.64% → 2.12%)  
✅ **Support tickets lower** in Fast Checkout (5.96% → 5.05%)  
✅ **No operational cost increase**

---

## 🧠 Interpretation

**What this means:**
- Fast Checkout did NOT introduce fraud or cost problems
- The segment issue from Query 3 is about **revenue optimization**, not operational risk
- Lower dispute/ticket rates suggest Fast Checkout actually improved user experience

**Why this matters:**
This validates that our recommendation isn't about preventing fraud or reducing costs—it's purely about capturing maximum revenue through better targeting.

---

## 🔧 How It Works

### Query Structure
The query runs **3 separate analyses** in sequence:

**Part 1: Refund Analysis**
- Filters to successful transactions only
- Counts refunds per variant
- Calculates refund rate as % of successful transactions

**Part 2: Dispute Analysis**
- Looks at all transactions
- Counts disputes by variant
- Calculates dispute rate as % of all transactions

**Part 3: Support Ticket Analysis**
- Joins transactions with support tickets
- Filters tickets within 7 days of transaction
- Calculates ticket rate and avg resolution time

### Key SQL Patterns Used
```sql
-- LEFT JOIN to include transactions without refunds/tickets
LEFT JOIN refunds r ON t.transaction_id = r.transaction_id

-- Window function to compare variants
LAG(refund_rate) OVER (ORDER BY experiment_variant)

-- Date filtering for ticket association
DATE(s.timestamp) BETWEEN DATE(t.timestamp) AND DATE(t.timestamp, '+7 days')
```

---

## 🗣️ Interview Talking Point

> "Query 4 validates operational impact. I measured refund rates, disputes, and support tickets to rule out fraud or cost concerns. All metrics were stable or improved in Fast Checkout, confirming that the segment issue is about revenue optimization, not operational problems. This strengthens the case for selective deployment based purely on revenue performance."

---

## 📝 Connection to Analysis Framework

| Query | Question | Answer |
|-------|----------|--------|
| Query 3 | Who benefited? | High-risk users (+$29), Low-risk users (-$5) |
| **Query 4** | **Did this cause costs?** | **No - costs stable** |
| Query 5 | Better metric? | Net revenue per attempt |

**This proves:** The recommendation to deploy selectively isn't about avoiding costs—it's about maximizing revenue.

---

## 🔗 Why This Query Matters

**Validates the recommendation:**
- If costs had spiked, we'd need to factor that into the decision
- Stable costs mean we can focus purely on revenue optimization
- This strengthens the business case for selective deployment

**Common concern addressed:**
- "Won't targeting high-risk users increase fraud?"
- Answer: No - refund rates identical, disputes actually lower

---

**Previous:** [Query 3 - Segment Analysis](q3_segment_impact.md)  
**Next:** [Query 5 - Counterfactual Metric](q5_counterfactual_metric.md)