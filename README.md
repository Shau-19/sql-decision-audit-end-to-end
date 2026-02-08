# Decision Audit System: When Metrics Mislead

**SQL-driven forensic analysis revealing segment-level optimization worth 5x more than aggregate results suggested.**

---

## 📊 Project Overview

A fintech payment platform launched "Fast Checkout" and observed +2.84% improvement in payment success rates during A/B testing. Leadership approved global rollout based on this metric.

**My Task:** Conduct post-decision audit to determine if the rollout maximized business value.

**Key Finding:** While aggregate metrics showed +$3.16 per attempt improvement, segment analysis revealed:
- **High-risk users:** +$29.09 per attempt ✅
- **Medium-risk users:** +$10.69 per attempt ✅  
- **Low-risk users:** -$5.13 per attempt ❌

**Recommendation:** Selective deployment to high and medium-risk segments would yield +$15-20 per attempt (5x better than current state), representing ~$800K annual value.

---

## 🔍 The Analysis

### Query Framework

| Query | Question | Key Finding |
|-------|----------|-------------|
| **1. Success Analysis** | Did conversion improve? | Yes, +2.84% improvement |
| **2. Revenue Impact** | Did revenue improve proportionally? | Only +$3.16 per attempt (modest) |
| **3. Segment Analysis** | Who actually benefited? | High-risk: +$29 / Low-risk: -$5 |
| **4. Cost Analysis** | Hidden operational costs? | No, costs remained stable |
| **5. Counterfactual** | What if we measured differently? | Better metric: net revenue per attempt |
| **6. Optimization** | What's the better strategy? | Selective deployment beats blanket rollout |

### The Core Insight

**Simpson's Paradox in action:** The blanket rollout averaged exceptional segment gains (+$29) with losses (-$5), yielding mediocre overall results (+$3). Strategic deployment captures value where the feature adds benefit while avoiding degradation where it doesn't.

---

## 💼 Business Impact

| Scenario | Net Revenue Lift | Annual Value |
|----------|------------------|--------------|
| Current (Blanket Rollout) | +$3.16 per attempt | ~$200K |
| **Recommended (Selective)** | **+$15-20 per attempt** | **~$1M** |
| **Incremental Opportunity** | **+$12-17 per attempt** | **~$800K** |

---

## 🛠️ Technical Details

- **Database:** SQLite (55,045 transactions, 10,000 users)
- **Analysis Period:** 4 months (Jan-Apr 2024)
- **Primary Tool:** SQL (CTEs, Window Functions, JOINs, PARTITION BY)
- **Data:** Synthetically generated realistic fintech transaction data

---

## 📁 Repository Structure

```
decision-audit-system/
│
├── README.md                        # This file
├── ANALYSIS.md                      # Complete analysis with results
│
├── sql/                             # 6 analytical queries
│   ├── 01_funnel_analysis.sql
│   ├── 02_revenue_analysis.sql
│   ├── 03_segment_impact.sql        # Key insight query
│   ├── 04_downstream_costs.sql
│   ├── 05_counterfactual_metric.sql
│   └── 06_tradeoff_analysis.sql
│
├── data/                            # Database and CSVs
│   ├── payflow_data.db
│   └── *.csv files
│
└── docs/                            # Query explanations
    ├── query_01_breakdown.md
    ├── query_02_breakdown.md
    ├── query_03_breakdown.md
    ├── query_04_breakdown.md
    ├── query_05_breakdown.md
    └── query_06_breakdown.md
```

---

## 🚀 Quick Start

### View the Analysis
**👉 See complete analysis with results:** [ANALYSIS.md](ANALYSIS.md)

### Run the Queries

**Option 1: DB Browser for SQLite (Recommended)**
```bash
1. Download DB Browser for SQLite
2. Open data/payflow_data.db
3. Execute SQL tab → paste query from sql/ folder
4. Run and view results
```

**Option 2: Command Line**
```bash
sqlite3 data/payflow_data.db < sql/01_funnel_analysis.sql
```

### Sample Output (Query 3: Segment Analysis)

```
risk_score | variant       | net_rev_per_attempt | lift    | recommendation
-----------|---------------|---------------------|---------|-------------------
high       | control       | $71.81              | -       |
high       | fast_checkout | $100.90             | +$29.09 | ✓ Deploy
medium     | control       | $92.44              | -       |
medium     | fast_checkout | $103.13             | +$10.69 | ✓ Deploy
low        | control       | $111.26             | -       |
low        | fast_checkout | $106.13             | -$5.13  | ✗ Keep on Control
```

---

## 🎓 Skills Demonstrated

### Analytical
- A/B test evaluation and post-hoc analysis
- Segment-level performance decomposition
- Metric validation and selection
- Counterfactual reasoning
- Strategic optimization recommendations
- Decision forensics

### Technical (SQL)
- Complex CTEs and subqueries
- Window functions (LAG, PARTITION BY)
- Multi-table JOINs
- Conditional aggregation (CASE WHEN)
- Revenue decomposition
- Cohort and segment analysis

### Business
- Translating technical findings to business impact
- Quantifying opportunity costs
- Strategic deployment planning
- Revenue-aligned metric design
- Stakeholder-ready recommendations

---

## 💡 Key Lessons

1. **Aggregate metrics can mislead** - Always break down by key segments (user type, geography, behavior)
2. **Conversion ≠ Revenue** - Optimize metrics that directly align with business outcomes
3. **Strategic deployment > Blanket rollout** - Features can be segment-dependent
4. **Simpson's Paradox is real** - What's true overall may hide what's true for subgroups

---

## 📖 Documentation

- **[ANALYSIS.md](Analysis.md)** - Complete analysis with all query results and business interpretations
- **[docs/](QUERY_Analysis/)** - Individual query breakdowns with step-by-step explanations
- **[sql/](sql/)** - All SQL queries with business context comments

---

## 🎯 Use Cases

**Portfolio:** Demonstrates SQL proficiency, analytical thinking, and business acumen

**Interviews:**
- *"Walk me through a project"* → Use this as primary technical example
- *"Tell me about finding a non-obvious insight"* → Query 3 segment analysis
- *"How do you evaluate experiments?"* → 6-query progressive framework

**Learning:** Study systematic approach to decision auditing and segment analysis

---

## 📊 Results Summary

### What the Aggregate Showed
- Conversion: +2.84%
- Net revenue: +$3.16 per attempt
- Decision: Approve ✅

### What Segment Analysis Revealed
- High-risk segment: +$29.09 per attempt (exceptional)
- Medium-risk segment: +$10.69 per attempt (strong)
- Low-risk segment: -$5.13 per attempt (negative)

### Optimal Strategy
Deploy to high and medium-risk segments only → **5x better results**

---

## 📝 Project Context

This project demonstrates SQL-first data analysis for product decisions. The scenario is inspired by real A/B test challenges in fintech and e-commerce where aggregate metrics can mask segment-level variation.

**Data:** Synthetically generated for educational purposes  
**Tools:** SQLite, Python (data generation)  
**Analysis:** Pure SQL (no dashboards or ML)


---


**Built to showcase SQL-driven decision forensics and strategic analytical thinking.**
