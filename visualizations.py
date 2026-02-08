"""
Decision Audit System - Visualizations (Optional)
Simple charts to support the analysis
"""

import sqlite3
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Set style
sns.set_style("whitegrid")
plt.rcParams['figure.figsize'] = (12, 6)

# Connect to database
conn = sqlite3.connect('payflow_data.db')

print("Generating visualizations...")

# ============================================================================
# Chart 1: Success Rate by Variant
# ============================================================================

query1 = """
SELECT 
    experiment_variant,
    ROUND(100.0 * SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) / COUNT(*), 2) AS success_rate
FROM transactions
WHERE DATE(timestamp) >= '2024-02-01' AND DATE(timestamp) < '2024-03-01'
GROUP BY experiment_variant
"""

df1 = pd.read_sql_query(query1, conn)

plt.figure(figsize=(8, 5))
bars = plt.bar(df1['experiment_variant'], df1['success_rate'], color=['#3498db', '#2ecc71'])
plt.title('Payment Success Rate by Variant', fontsize=14, fontweight='bold')
plt.ylabel('Success Rate (%)')
plt.ylim(85, 95)

# Add value labels
for bar in bars:
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2., height,
             f'{height:.1f}%',
             ha='center', va='bottom', fontsize=12, fontweight='bold')

plt.tight_layout()
plt.savefig('chart1_success_rate.png', dpi=300, bbox_inches='tight')
print("✓ Saved: chart1_success_rate.png")
plt.close()

# ============================================================================
# Chart 2: Segment Performance (Net Revenue per Attempt)
# ============================================================================

query2 = """
SELECT 
    u.risk_score,
    t.experiment_variant,
    ROUND(
        (SUM(CASE WHEN t.status = 'success' THEN t.amount ELSE 0 END) - COALESCE(SUM(r.refund_amount), 0)) / COUNT(*),
        2
    ) AS net_rev_per_attempt
FROM transactions t
JOIN users u ON t.user_id = u.user_id
LEFT JOIN refunds r ON t.transaction_id = r.transaction_id
WHERE DATE(t.timestamp) >= '2024-02-01' AND DATE(t.timestamp) < '2024-03-01'
GROUP BY u.risk_score, t.experiment_variant
ORDER BY u.risk_score, t.experiment_variant
"""

df2 = pd.read_sql_query(query2, conn)

# Pivot for easier plotting
pivot = df2.pivot(index='risk_score', columns='experiment_variant', values='net_rev_per_attempt')

plt.figure(figsize=(10, 6))
x = range(len(pivot))
width = 0.35

bars1 = plt.bar([i - width/2 for i in x], pivot['control'], width, label='Control', color='#3498db')
bars2 = plt.bar([i + width/2 for i in x], pivot['fast_checkout'], width, label='Fast Checkout', color='#2ecc71')

plt.xlabel('Risk Segment', fontweight='bold')
plt.ylabel('Net Revenue per Attempt ($)', fontweight='bold')
plt.title('Segment Performance: Net Revenue per Attempt', fontsize=14, fontweight='bold')
plt.xticks(x, pivot.index)
plt.legend()

# Add value labels
for bars in [bars1, bars2]:
    for bar in bars:
        height = bar.get_height()
        plt.text(bar.get_x() + bar.get_width()/2., height,
                 f'${height:.0f}',
                 ha='center', va='bottom', fontsize=10)

plt.tight_layout()
plt.savefig('chart2_segment_performance.png', dpi=300, bbox_inches='tight')
print("✓ Saved: chart2_segment_performance.png")
plt.close()

# ============================================================================
# Chart 3: Segment Lift Comparison
# ============================================================================

# Calculate lift for each segment
lifts = []
for risk in ['high', 'medium', 'low']:
    control_val = pivot.loc[risk, 'control']
    fast_val = pivot.loc[risk, 'fast_checkout']
    lift = fast_val - control_val
    lifts.append({'risk_score': risk, 'lift': lift})

df_lift = pd.DataFrame(lifts)

plt.figure(figsize=(8, 5))
colors = ['#2ecc71' if x > 0 else '#e74c3c' for x in df_lift['lift']]
bars = plt.bar(df_lift['risk_score'], df_lift['lift'], color=colors)

plt.axhline(y=0, color='black', linestyle='-', linewidth=0.8)
plt.title('Net Revenue Lift by Segment', fontsize=14, fontweight='bold')
plt.ylabel('Lift ($ per attempt)', fontweight='bold')
plt.xlabel('Risk Segment', fontweight='bold')

# Add value labels
for bar in bars:
    height = bar.get_height()
    label_y = height + 1 if height > 0 else height - 3
    plt.text(bar.get_x() + bar.get_width()/2., label_y,
             f'${height:.1f}',
             ha='center', fontsize=11, fontweight='bold')

plt.tight_layout()
plt.savefig('chart3_segment_lift.png', dpi=300, bbox_inches='tight')
print("✓ Saved: chart3_segment_lift.png")
plt.close()

conn.close()

print("\n" + "="*60)
print("✓ All visualizations generated successfully!")
print("="*60)
print("\nGenerated files:")
print("  • chart1_success_rate.png")
print("  • chart2_segment_performance.png")
print("  • chart3_segment_lift.png")
print("\nAdd these to your GitHub README or presentation!")