# Python EDA & Analytical Roadmap
## Business Sales Performance Analytics
**Role:** Senior Data Analyst & Python BI Consultant  
**Project Phase:** Phase 2 (Exploratory Data Analysis & Business Intelligence in Python)  
**Status:** Approved for Implementation  

---

## 1. Project Folder Structure for Python Analysis
To ensure modularity and ease of maintenance, configure your Python-specific project layout as follows:

```text
business-sales-performance-analytics/
├── requirements.txt               # Analytics libraries (pandas, numpy, matplotlib, seaborn, scipy)
├── data/
│   ├── raw/                       # ORIGINAL untouched Superstore CSV
│   └── processed/                 # CLEANED dataset written by Pandas script
├── notebooks/
│   ├── 01_data_cleaning_etl.ipynb # Raw data ingestion, validation, and schema correction
│   ├── 02_exploratory_analysis.ipynb # Statistical EDA, correlation, and distribution plotting
│   └── 03_business_deep_dives.ipynb# Advanced KPI calculations, Pareto, and leakage analysis
└── src/                           # Production scripts
    ├── __init__.py
    └── visualization_helpers.py   # Reusable matplotlib/seaborn custom plot styling
```

---

## 2. Required Python Libraries
To replicate industry standards, document and install these exact dependencies inside your `requirements.txt`:

```text
pandas>=2.0.0      # High-performance data manipulation and dataframe aggregation
numpy>=1.24.0      # Vectorized matrix math, array indexing, and conditional flags
matplotlib>=3.7.0  # Core plotting engine for building standard data charts
seaborn>=0.12.0    # Statistical visualization wrapper for advanced correlation/heatmaps
scipy>=1.10.0      # Advanced statistical distribution testing (e.g., Z-scores, kurtosis)
openpyxl>=3.1.0    # Engine supporting exporting final analytical frames to Excel
```

---

## 3. Data Loading & Ingestion Process
A robust ingestion script handles potential encoding mismatches (highly common in Windows/Excel retail files) and converts date-string objects to datetime structures during load.

```python
import pandas as pd
import numpy as np

def ingest_raw_data(file_path):
    print("[INFO] Initiating dataset ingestion...")
    try:
        # standard encoding is utf-8, but superstore files often use latin1 or cp1252
        df = pd.read_csv(file_path, encoding='unicode_escape')
        print(f"[SUCCESS] Ingested dataset: {df.shape[0]} rows, {df.shape[1]} columns.")
        
        # 1. Standardize Column Formatting (Strip spaces, lowercase, snake_case)
        df.columns = df.columns.str.strip().str.lower().str.replace(' ', '_').str.replace('-', '_')
        
        # 2. Force Chronological Data Types
        df['order_date'] = pd.to_datetime(df['order_date'])
        df['ship_date'] = pd.to_datetime(df['ship_date'])
        
        return df
    except Exception as e:
        print(f"[ERROR] Ingestion failed: {str(e)}")
        return None
```

---

## 4. In-Depth Data Cleaning & Ingestion Workflow
The standard Python data transformation workflow consists of five distinct verification checkpoints:

```mermaid
flowchart LR
    A["Raw Load"] --> B["Type Alignment"]
    B --> C["Null / Blank Audit"]
    C --> D["Duplicate Scrubbing"]
    D --> E["Outlier Mitigation"]
    E --> F["Processed Output"]
    
    style A fill:#eaeded,stroke:#2c3e50
    style F fill:#d5f5e3,stroke:#27ae60
```

1.  **Logical Type Verification:** Force numeric conversions on metric fields and text conversions on IDs.
2.  **Date Validation:** Enforce chronological consistency: `df = df[df['ship_date'] >= df['order_date']]`.
3.  **Dimension Standardization:** Clean geographical casing (e.g., standardizing 'texas' vs 'Texas') and strip leading/trailing spaces.
4.  **Derived Value Audit:** Recalculate sales margins to verify that raw `sales` minus `profit` does not violate baseline logic.

---

## 5. Data Quality Checks
Conduct the following automated checks to verify data integrity:

```python
def check_data_quality(df):
    print("=== DATA QUALITY REPORT ===")
    # 1. Structural Check
    print(f"Dataset Shape: {df.shape[0]} rows, {df.shape[1]} columns")
    
    # 2. Chronological Conflict Check
    date_conflicts = df[df['ship_date'] < df['order_date']]
    print(f"Chronological Date Conflicts: {len(date_conflicts)}")
    
    # 3. Numeric Integrity Check (e.g., Quantity cannot be negative)
    quantity_violations = df[df['quantity'] <= 0]
    print(f"Quantity Range Violations (<= 0): {len(quantity_violations)}")
    
    # 4. Logical Margin Check
    margin_violations = df[df['sales'] < df['profit']]
    print(f"Profit Anomalies (Profit > Sales): {len(margin_violations)}")
```

---

## 6. Missing Value Analysis
Identify and address gaps in the data:

*   **Objective:** Detect columns with missing or incomplete values.
*   **Business Significance:** Missing values in keys like `product_id` or dimensions like `region` will corrupt group-bys and lead to inaccurate reports.
*   **Recommended Visualization:** Horizontal bar chart of missing values using `sns.barplot(x=df.isnull().sum(), y=df.columns)`.
*   **Expected Insight:** Retail databases often have missing values in shipping methods, shipping dates, or discount rates. Replace missing discounts with `0.00` to avoid calculation errors.

```python
# Missing Value Evaluation Code
missing_counts = df.isnull().sum()
missing_percentage = (df.isnull().sum() / len(df)) * 100
missing_report = pd.DataFrame({'Missing Count': missing_counts, 'Percentage (%)': missing_percentage})
print(missing_report[missing_report['Missing Count'] > 0])
```

---

## 7. Duplicate Record Analysis
Identify and remove redundant entries:

*   **Objective:** Locate and delete duplicate rows in the dataset.
*   **Business Significance:** Double-counted entries artificially inflate sales figures, rendering profit reporting incorrect.
*   **Recommended Visualization:** Simple text KPI block or a terminal logger reporting duplicated counts.
*   **Expected Insight:** Duplicates often occur due to system integration errors. Ensure you drop duplicate rows based on key fields: `df.drop_duplicates(subset=['order_id', 'product_id', 'customer_id'], keep='first', inplace=True)`.

---

## 8. Outlier Detection Approach (Z-Score & IQR)
Determine whether extreme values represent data entry errors or legitimate high-value orders:

*   **Objective:** Identify extreme transactional outliers in metrics like `sales`, `profit`, and `shipping_cost`.
*   **Business Significance:** Outliers skew averages (e.g., AOV) and distort visualizations. It is vital to separate standard customer transactions from rare, massive corporate wholesale orders.
*   **Recommended Visualization:** Horizontal boxplots using `sns.boxplot(x=df['sales'])` or `sns.boxplot(x=df['profit'])`.
*   **Expected Insight:** The US Superstore dataset typically contains extreme outliers in both `sales` and `profit` (e.g., high-value technology orders). These are usually valid B2B wholesale transactions, not errors, and should be kept for analysis but segmented separately.

```python
# Statistical Outlier Profiling (Interquartile Range - IQR)
Q1 = df['sales'].quantile(0.25)
Q3 = df['sales'].quantile(0.75)
IQR = Q3 - Q1
lower_bound = Q1 - 1.5 * IQR
upper_bound = Q3 + 1.5 * IQR
outliers = df[(df['sales'] < lower_bound) | (df['sales'] > upper_bound)]
print(f"Total Sales Outliers Identified: {len(outliers)} ({len(outliers)/len(df)*100:.2f}%)")
```

---

## 9. Core Descriptive Statistics
Calculate standard statistical metrics to establish a baseline:

*   **Objective:** Generate descriptive statistics for numerical columns (`sales`, `quantity`, `discount`, `profit`).
*   **Business Significance:** Provides an initial baseline of average transactional sizes, product volume per order, average discounting, and profitability metrics.
*   **Expected Output:** Using Python’s `.describe()`, analyze:
    *   **Mean vs Median (50%):** A high difference indicates skewed data (outliers pulling the average).
    *   **Standard Deviation (std):** Measures variance in pricing and discount structures.

```python
# Compute core metrics
numerical_stats = df[['sales', 'quantity', 'discount', 'profit']].describe().T
print(numerical_stats)
```

---

## 10. Univariate Analysis Plan
Understand the behavior of individual columns:

*   **Objective:** Analyze the distribution of individual variables (e.g., Sales, Segment, Region).
*   **Business Significance:** Helps you understand the shape and behavior of individual variables before combining them in multivariate models.
*   **Recommended Visualization:** Histograms for continuous variables (`sales`, `profit`) and vertical count bars for categorical variables (`segment`, `region`).
*   **Expected Insight:** Continuous variables like sales and profit typically follow a highly skewed log-normal distribution, meaning most transactions are small, while a few wholesale orders drive the volume.

```python
import matplotlib.pyplot as plt
import seaborn as sns

# Visualizing Segment Distribution
plt.figure(figsize=(8, 4))
sns.countplot(data=df, x='segment', palette='Blues_r')
plt.title('Transactions by Customer Segment')
plt.ylabel('Order Count')
plt.show()
```

---

## 11. Bivariate Analysis Plan (Sales vs. Margin)
Analyze relationships between pairs of variables:

*   **Objective:** Evaluate how sales value correlates with profit margins across categories.
*   **Business Significance:** Identifies high-revenue categories that may actually be dragging down profitability due to high overheads.
*   **Recommended Visualization:** Grouped bar chart comparing total sales alongside total profit for each category, or a scatter plot of `Sales` vs. `Profit`.
*   **Expected Insight:** Furniture typically generates high sales volume but yields very low profit margins, whereas Technology and Office Supplies generate higher profits relative to their sales volumes.

---

## 12. Multivariate Analysis Plan (Discount-Segment-Margin)
Examine relationships across three or more variables:

*   **Objective:** Analyze how profit margins are impacted by discounts across customer segments.
*   **Business Significance:** Helps you understand which customer segments are highly price-sensitive and where promotional discounts are eroding profitability.
*   **Recommended Visualization:** Heatmap matrix or a faceted scatter plot (`sns.relplot`) mapping Sales (X-axis), Profit (Y-axis), Customer Segment (Col/Facet), and Discount Rate (Color scale).
*   **Expected Insight:** Corporate segments are often less price-sensitive, while aggressive discounting in the Consumer segment can lead to steep profit declines.

---

## 13. Correlation Analysis
Identify direct linear relationships:

*   **Objective:** Measure the strength of linear relationships between numerical variables.
*   **Business Significance:** Proves mathematically whether increasing discounts drives higher volume, and quantifies its impact on net profit.
*   **Recommended Visualization:** Colored correlation heatmap matrix.
*   **Expected Insight:** A strong negative correlation typically exists between `discount` and `profit`, highlighting the risks of aggressive discounting strategies.

```python
# Correlation Matrix Calculation & Heatmap
correlation_matrix = df[['sales', 'quantity', 'discount', 'profit']].corr()
plt.figure(figsize=(6, 4))
sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', fmt=".2f", linewidths=.5)
plt.title('Correlation Matrix of Core Sales Metrics')
plt.show()
```

---

## 14. Monthly Sales Trend & Seasonality Analysis
Track chronological trends:

*   **Objective:** Map net sales and profit patterns month-by-month over a multi-year period.
*   **Business Significance:** Identifies seasonal demand spikes (e.g., Q4 holiday surge) to help optimize inventory stocking levels and resource planning.
*   **Recommended Visualization:** Line/Area combo chart showing Monthly Sales (continuous line) with Monthly Profit (shaded area).
*   **Expected Insight:** Typical retail trends show a substantial spike in sales during September, November, and December, followed by a post-holiday dip in January.

```python
# Monthly Aggregation Script
df['order_month'] = df['order_date'].dt.to_period('M')
monthly_sales = df.groupby('order_month')[['sales', 'profit']].sum().reset_index()
monthly_sales['order_month'] = monthly_sales['order_month'].astype(str)

plt.figure(figsize=(12, 5))
plt.plot(monthly_sales['order_month'], monthly_sales['sales'], label='Total Revenue', color='#00A8FF', marker='o')
plt.bar(monthly_sales['order_month'], monthly_sales['profit'], label='Net Profit', color='#2ECC71', alpha=0.6)
plt.xticks(rotation=45, ha='right')
plt.title('Monthly Revenue & Profitability Trends')
plt.legend()
plt.tight_layout()
plt.show()
```

---

## 15. Category & Sub-Category Performance Analysis
Segment product performance:

*   **Objective:** Rank product categories and sub-categories by sales and profitability.
*   **Business Significance:** Helps you identify top-performing product categories to focus on, and call out low-margin categories that need attention.
*   **Recommended Visualization:** Grouped horizontal bar chart or a nested Treemap.
*   **Expected Insight:** "Copiers" and "Phones" (Technology) are usually high-value, high-profit sub-categories, while "Tables" and "Bookcases" (Furniture) can often experience high net losses due to heavy discounts and freight costs.

---

## 16. Regional Sales & Profit Analysis
Examine performance by geography:

*   **Objective:** Evaluate regional sales volume and net profit margins across territories.
*   **Business Significance:** Identifies high-performing territories where you should double down on marketing, and low-performing regions that need operational reviews.
*   **Recommended Visualization:** Grouped bar chart comparing sales and profit by Region, or a choropleth map.
*   **Expected Insight:** The West and East regions typically drive the largest share of sales and profits, while the Central region can see lower profits due to high discounting in states like Texas and Illinois.

---

## 17. Customer Segment Analysis
Profile customer buying habits:

*   **Objective:** Analyze average transaction sizes, discounting patterns, and margins across segments (Corporate, Consumer, Home Office).
*   **Business Significance:** Helps tailor pricing, discounting, and marketing strategies for specific customer groups.
*   **Recommended Visualization:** Nested donut chart or clustered bar chart.
*   **Expected Insight:** The Consumer segment typically drives the highest total revenue, but the Corporate and Home Office segments often yield larger Average Order Values (AOV) with lower discounting rates.

---

## 18. Discount vs. Profit Margin Analysis
Analyze the impact of promotional pricing:

*   **Objective:** Analyze the impact of discounts on overall profitability.
*   **Business Significance:** Helps you identify the "profit inflection point" where promotional discounts begin to erode net margins.
*   **Recommended Visualization:** Scatter plot of Average Discount (X-axis) vs. Profit Margin % (Y-axis), grouped by category.
*   **Expected Insight:** Discounts above **20%** often result in a steep decline in profitability, suggesting the need for stricter discounting limits.

```python
# Discount vs Margin Scatter Plot
plt.figure(figsize=(9, 5))
sns.scatterplot(data=df, x='discount', y='profit', hue='category', alpha=0.7)
plt.axhline(0, color='red', linestyle='--', linewidth=1)
plt.title('Transaction Profit vs Applied Discount Rate')
plt.xlabel('Discount Rate (Decimal)')
plt.ylabel('Net Profit ($)')
plt.show()
```

---

## 19. Top 10 and Bottom 10 Product Analysis
Identify catalog stars and low-performers:

*   **Objective:** Identify the highest-earning and lowest-earning products in your inventory.
*   **Business Significance:** Helps you optimize your catalog by focusing on high-performing products and restructuring or phasing out low-performing ones.
*   **Recommended Visualization:** Horizontal bar charts showing the Top 10 products (by Profit) and Bottom 10 products (by Loss).
*   **Expected Insight:** Certain products, despite driving high sales volumes, can generate significant net losses due to excessive promotional discounting.

---

## 20. Executive KPI Calculations (Python Implementation)
Calculate core business health metrics using Python:

*   **Objective:** Calculate the key financial health metrics of the business.
*   **Business Significance:** Establishes the core benchmark figures that will be displayed in the executive dashboard.
*   **Expected Insight:** Validates all calculations in code before setting up the visual Power BI dashboard.

```python
# Analytical KPI Core Computation Engine
total_revenue = df['sales'].sum()
total_units = df['quantity'].sum()
total_profit = df['profit'].sum()
net_margin = (total_profit / total_revenue) * 100
average_discount = df['discount'].mean() * 100
aov = total_revenue / df['order_id'].nunique()

print(f"Total Net Sales:       ${total_revenue:,.2f}")
print(f"Total Units Sold:      {total_units:,}")
print(f"Total Net Profit:      ${total_profit:,.2f}")
print(f"Corporate Net Margin:  {net_margin:.2f}%")
print(f"Average Discount Rate: {average_discount:.2f}%")
print(f"Average Order Value:   ${aov:.2f}")
```

---

> [!TIP]
> **Portfolio Tip:** When showcasing this project on GitHub or LinkedIn, include the Python code snippet above alongside your dashboard. This demonstrates a strong balance of **data engineering (Python)** and **business intelligence (Power BI)**, helping you stand out to hiring managers.
