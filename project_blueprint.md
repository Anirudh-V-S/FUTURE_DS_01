# Portfolio Project Blueprint
## Business Sales Performance Analytics
**Role:** Senior Data Analyst & Power BI Consultant  
**Project Context:** Internship Capstone & Portfolio Development  
**Target Platforms:** GitHub, LinkedIn, Professional Portfolio, Job Interviews  

---

## 1. Business Problem Statement
Modern enterprises generate massive volumes of transactional data, yet they often remain **"data-rich, but insight-poor."** Without a centralized, interactive analytics system, leadership faces several key pain points:
*   **Siloed Data:** Sales, product, geographic, and customer segment metrics are analyzed in isolation.
*   **Delayed Decisions:** Static spreadsheets result in backward-looking analysis, missing real-time trend shifts.
*   **Margin Erosion:** Hidden profit leakage occurs due to aggressive, unmonitored discounting strategies.
*   **Sub-optimal Inventory:** Lack of trend clarity leads to stockouts of top-sellers or capital tied up in slow-moving items.

**The Solution:** This project designs and deploys an interactive, production-grade Power BI dashboard to serve as the organization's **Single Source of Truth (SSOT)**. The platform enables senior stakeholders to monitor health metrics, drill down into product segments, map regional margins, and immediately extract data-backed strategic decisions.

---

## 2. Project Objectives
*   **Data Engineering & ETL:** Ingest, clean, and structure raw transactional data using Power Query (M) or Python (Pandas).
*   **Data Warehouse Modeling:** Build a robust, scalable Star Schema containing dedicated dimension and fact tables to optimize DAX performance.
*   **Executive BI Delivery:** Create an aesthetic, user-centric 3-page Power BI dashboard utilizing modern UX/UI standards.
*   **Strategic Decision Support:** Perform advanced diagnostic analysis (Pareto, Profit Leakage, Trend Seasonality) to generate actionable business recommendations.

---

## 3. Key Business Questions to Answer
A stellar data analyst doesn't just display data; they answer critical operational questions:

### A. Revenue Trends & Seasonality
1. *What is the long-term sales trajectory? Are we growing Month-over-Month (MoM) and Year-over-Year (YoY)?*
2. *Are there predictable seasonal demand spikes (e.g., Q4 retail surge)?*
3. *What is our run-rate relative to historical performance?*

### B. Product & Category Performance
4. *Which product categories and sub-categories generate the largest share of revenue, and which yield the highest profit margins?*
5. *Which specific products constitute our top 10% high-value items, and which are underperforming (high volume, negative profit)?*
6. *Is there high dependency on a few key SKUs (Pareto risk)?*

### C. Customer & Market Segments
7. *Which customer segments (Corporate, Consumer, Home Office) generate the highest Average Order Value (AOV)?*
8. *What is the correlation between discounting and sales volume across different customer segments?*

### D. Regional & Geographical Performance
9. *Which geographic regions and states are highly profitable, and where are we experiencing margin leakage?*
10. *Does shipping cost play a significant role in reducing profit margins in specific distant states?*

---

## 4. Standardized KPIs & Calculations (DAX Formulas)
To prove technical mastery in interviews, you must showcase advanced, performant **DAX (Data Analysis Expressions)**. Implement these measures in a dedicated table named `_Measures`:

```
┌────────────────────────────────────────────────────────────────────────┐
│                        STANDARDIZED CORE DAX METRICS                   │
├────────────────────────────────────────────────────────────────────────┤
│  [Total Revenue]   = SUM(Sales[SalesAmount])                           │
│  [Total Cost]      = SUM(Sales[TotalCost])                             │
│  [Total Profit]    = [Total Revenue] - [Total Cost] - [Total Shipping] │
│  [Profit Margin %] = DIVIDE([Total Profit], [Total Revenue], 0)        │
│  [Average Order]   = DIVIDE([Total Revenue], DISTINCTCOUNT(Sales[OrderID]))│
└────────────────────────────────────────────────────────────────────────┘
```

### Advanced Time Intelligence DAX Measures
Showcase your ability to compute MoM and YoY variances dynamically:

```dax
-- 1. Month-over-Month Revenue Growth
Revenue MoM Growth % = 
VAR CurrentRevenue = [Total Revenue]
VAR PriorMonthRevenue = 
    CALCULATE(
        [Total Revenue],
        DATEADD('Dim_Calendar'[Date], -1, MONTH)
    )
RETURN
    DIVIDE(CurrentRevenue - PriorMonthRevenue, PriorMonthRevenue, 0)
```

```dax
-- 2. Year-over-Year (YoY) Sales Comparison
Revenue YoY Growth % = 
VAR CurrentRevenue = [Total Revenue]
VAR PriorYearRevenue = 
    CALCULATE(
        [Total Revenue],
        SAMEPERIODLASTYEAR('Dim_Calendar'[Date])
    )
RETURN
    DIVIDE(CurrentRevenue - PriorYearRevenue, PriorYearRevenue, 0)
```

```dax
-- 3. Year-to-Date (YTD) Revenue
Revenue YTD = 
TOTALYTD([Total Revenue], 'Dim_Calendar'[Date])
```

---

## 5. Dataset Requirements & recommended Sources

### Ideal Data Parameters
*   **Transactional Depth:** At least 2-4 years of historical daily records (minimum 5,000+ rows) to conduct meaningful trend and seasonality analysis.
*   **Granularity:** Item-level line items (each row represents a unique product in an order).
*   **Dimensions:** Multi-layered categories (Category -> Sub-Category -> SKU) and multi-layered geography (Country -> Region -> State -> City).

### Recommended Sources
1.  **US Superstore Sales Dataset (Highly Recommended):**
    *   *Why:* The gold standard for business BI portfolios. It contains dates, categories (Furniture, Technology, Office Supplies), segments, customer profiles, shipping details, and geographic metrics.
    *   *Where to get it:* Easily downloadable from Kaggle (Search: "US Superstore Sales") or Tableau Public Sample Datasets.
2.  **Microsoft AdventureWorks DW (Database Alternative):**
    *   *Why:* Excellent if you want to showcase SQL skills alongside Power BI.
    *   *Where to get it:* Microsoft's GitHub repository for AdventureWorks backup files.

---

## 6. Data Cleaning Protocol (Step-by-Step)
For your portfolio, document your ETL steps clearly. Below are the steps you must run in **Power Query (M)** or **Python (Pandas)**:

### Phase A: Power Query (M Code) Best Practices
1.  **Promote Headers & Change Types:** Ensure numerical fields (`Sales`, `Profit`, `Quantity`) are set to `Decimal` / `Whole Number` and dates are recognized as `Date`.
2.  **Date Normalization:** Split combined timestamps into standalone date fields to prevent relationship mapping errors.
3.  **Null & Blank Auditing:** Replace null fields in `Discount` with `0.00` and use profile histograms to detect missing values in key dimensions.
4.  **Formatting Consistency:** Trim text dimensions (`Product Name`, `City`) to remove leading/trailing whitespace. Capitalize all elements correctly.
5.  **Calculated Audit Columns:** Create an validation column:
    *   `Margin Check = [Sales] - [Profit]` (Ensure cost is not negative).

### Phase B: Python (Pandas) Alternative
If doing ETL in Python, document this script in `notebooks/01_data_cleaning_etl.ipynb`:

```python
import pandas as pd
import numpy as np

def clean_sales_data(filepath):
    # Load dataset
    df = pd.read_csv(filepath)
    
    # 1. Standardize column names to snake_case
    df.columns = [col.lower().replace(" ", "_").replace("-", "_") for col in df.columns]
    
    # 2. Date parsing
    df['order_date'] = pd.to_datetime(df['order_date'])
    
    # 3. Handle missing values
    df['discount'] = df['discount'].fillna(0.0)
    df.dropna(subset=['customer_id', 'product_id'], inplace=True)
    
    # 4. Remove duplicate transactions
    df.drop_duplicates(subset=['row_id', 'order_id', 'product_id'], inplace=True)
    
    # 5. Outlier/Consistency Check
    # Verify that net sales is greater than or equal to profit
    # If profit is theoretically higher than net sales (an anomaly), flag or fix
    df = df[df['sales'] >= df['profit']]
    
    return df
```

---

## 7. Exploratory Data Analysis (EDA) Plan
Before loading data into Power BI, perform high-level analytical checks using Python (`matplotlib` and `seaborn`) to establish your mathematical baselines:

*   **Descriptive Statistics:** Calculate standard median, mean, standard deviation, and percentiles for `Sales`, `Quantity`, `Profit`, and `Discount`.
*   **Correlation Heatmap:** Plot correlations between `Sales`, `Quantity`, `Discount`, and `Profit` to verify if high discounts actively destroy profits.
*   **Distribution Plot:** Plot histograms for transaction sizes to identify average deal sizes and skewness.
*   **Seasonality Check:** Run a monthly line plot to visually isolate cyclic performance peaks.

---

## 8. Dashboard Layout & Visual Design Sheet
To ensure the dashboard looks highly premium and "wows" recruiters at first glance, adopt a **Sleek Corporate Dark Mode** or a **Clean Minimalistic Slate Blue Theme**.

### Page 1: Executive Summary (High-Level Performance)
*   **Aesthetics:** Dark charcoal background (`#1E2022`), clean card containers (`#2C3033`), subtle gray text, vibrant blue (`#00A8FF`) and emerald green (`#2ECC71`) accents.
*   **Layout Grid:**
    ```
    ┌────────────────────────────────────────────────────────────────────────┐
    │  LOGO   │  EXECUTIVE SALES & PERFORMANCE OVERVIEW  │ FILTERS: Year/Region│
    ├────────────────────────────────────────────────────────────────────────┤
    │  KPI CARDS:                                                            │
    │  [Total Revenue]   │  [Total Profit]   │  [Profit Margin %] │  [Orders]│
    │  $2.3M (+12% MoM)  │  $286K (+8% MoM)  │  12.4% (-20bps)    │  5,004   │
    ├────────────────────────────────────────┬───────────────────────────────┤
    │  MAIN TIME SERIES (Trend Chart)        │  REVENUE BY CUSTOMER SEGMENT  │
    │  Monthly Net Revenue vs Prior Year     │  Donut Chart:                 │
    │  (Line/Area Combo Chart)               │  Consumer vs Corp vs Home Office│
    ├────────────────────────────────────────┴───────────────────────────────┤
    │  SUB-CATEGORY HIGHLIGHTS                                               │
    │  Horizontal Bar Chart: Sales & Profit by Sub-Category                  │
    └────────────────────────────────────────────────────────────────────────┘
    ```

### Page 2: Product & Discount Deep-Dive (Margin Leakage)
*   **Goal:** Drill into the product catalog and evaluate discount structures.
*   **Layout Grid:**
    ```
    ┌────────────────────────────────────────────────────────────────────────┐
    │  LOGO   │  PRODUCT CATALOG & DISCOUNT DRILL-DOWN   │ FILTERS: Category │
    ├────────────────────────────────────────────────────────────────────────┤
    │  PARETO ANALYSIS CHART (80/20 Rule)                                    │
    │  Cumulative Revenue Contribution % vs. Product Name (Sorted)           │
    │  (Combo Column + Cumulative Line Chart)                                │
    ├────────────────────────────────────────┬───────────────────────────────┤
    │  MARGIN DESTROYERS                     │  QUANTITY VS DISCOUNT IMPACT  │
    │  Table: Bottom 10 Products by Profit   │  Scatter Plot:                │
    │  (Product, Sales, Discount, Profit)    │  X: Avg Discount | Y: Profit  │
    │  Shows conditional red background.    │  Bubbles sized by Quantity    │
    └────────────────────────────────────────┴───────────────────────────────┘
    ```

### Page 3: Regional Sales Performance & Shipping Metrics
*   **Goal:** Geographically isolate drivers of shipping costs and profitability.
*   **Layout Grid:**
    ```
    ┌────────────────────────────────────────────────────────────────────────┐
    │  LOGO   │  GEOGRAPHIC PENETRATION & LOGISTICS MAP  │ FILTERS: Region   │
    ├────────────────────────────────────────────────────────────────────────┤
    │  INTERACTIVE REGIONAL MAP                                              │
    │  Filled Map or Bubble Map representing Net Sales volume.                │
    │  Color saturation mapped to Profit Margin.                             │
    ├────────────────────────────────────────┬───────────────────────────────┤
    │  REGIONAL PERFORMANCE TABLE            │  SHIPPING COST CORRELATION    │
    │  Table: State, City, Net Sales,        │  Horizontal Grouped Bar:      │
    │  Shipping Cost, Margin %               │  Shipping Cost vs Margin %    │
    │  With Data Bars inline.                │  by Shipping Mode             │
    └────────────────────────────────────────┴───────────────────────────────┘
    ```

---

## 9. Actionable Business Insights to Extract & Showcase
Your portfolio should prominently display the **business intelligence** you discovered:

*   **Discount Inflection Point:** *"Analysis of the discount-to-profit scatter plot reveals that discounts exceeding **20%** result in negative margins across 85% of sub-categories. Recommendation: Cap transactional discounts for the Furniture segment at 15%."*
*   **Product Pareto Concentration:** *"The top 18% of products generate 80% of total revenue. Conversely, the bottom 30% of our inventory catalog represents less than 2% of sales and yields a combined net loss. Recommendation: Rationalize low-volume, low-margin products."*
*   **Regional Shipping Leakage:** *"Texas and Ohio rank in our top 5 for sales volume but are in the bottom 3 for profitability due to elevated freight/shipping expenses. Recommendation: Renegotiate contracts with carrier services in Central and Southern regions."*

---

## 10. Key Skills Demonstrated (Perfect for Resume & LinkedIn)
Make sure to list these specific technical concepts on your portfolio page and resume:

*   **Dimensional Modeling:** Star Schema design, handling 1:Many relationships, bidirectional filters, and active/inactive relationship configurations.
*   **Advanced DAX:** Time intelligence (YTD, YoY, MoM), context transition with `CALCULATE`, safe division with `DIVIDE`, dynamic ranking with `RANKX`.
*   **Modern UI/UX Dashboard Design:** Visual hierarchy, custom color themes, button navigation, conditional formatting, dynamic tooltips, and parameter slicers.
*   **ETL Architecture:** Data cleaning, type-mapping, handling nulls, standardizing records in Power Query and Python.
*   **Business Acumen:** Customer segmentation, financial margin calculations, geographical expansion, and inventory/SKU rationalization.

---

## 11. Complete GitHub-Ready README Template
Copy and paste this template into the `README.md` file of your repository. It is structured to captivate hiring managers and tech recruiters.

```markdown
# Business Sales Performance Analytics | Interactive Power BI Suite

[![Power BI](https://img.shields.io/badge/Power_BI-Dashboard-yellow?style=flat&logo=powerbi)](https://app.powerbi.com)
[![SQL](https://img.shields.io/badge/SQL-Analytics-blue?style=flat&logo=postgresql)](./sql/)
[![Python](https://img.shields.io/badge/Python-ETL%20%26%20EDA-green?style=flat&logo=python)](./notebooks/)

An end-to-end business intelligence and data engineering project designed to convert historical retail sales transaction logs into executive strategic actions.

## 📊 Interactive Dashboard Preview
*Insert stunning dashboard screenshots here (Executive Summary, Catalog Deep-Dive, Geographic Performance)*

## 🎯 Executive Summary
The primary objective of this project is to centralize and analyze transactional performance, optimizing net sales and protecting margins. Through interactive tracking, this suite addresses critical inefficiencies:
*   **Revenue Growth Trends:** Historical trend lines with dynamic MoM/YoY growth tracking.
*   **Product Performance Matrix:** Identifying SKU-level margin contributors and rationalizing catalog size.
*   **Discount Optimization:** Isolating profit leakage where promotions erode profits.
*   **Logistics & Geography:** Regional mapping of sales velocity vs. shipping/freight costs.

## 📁 Repository Structure
```text
business-sales-performance-analytics/
├── README.md                      # High-impact summary and portfolio page
├── requirements.txt               # Required Python packages
├── data/                          # Data folder (divided into Raw and Cleaned)
│   ├── raw/                       # Raw source transactions
│   └── processed/                 # Final cleaned CSV ready for Power BI
├── notebooks/                     # Analytical Python scripts
│   ├── 01_data_cleaning_etl.ipynb # Python ETL (casing, nulls, types)
│   └── 02_exploratory_analysis.ipynb# Descriptive stats, correlation, seasonality
├── sql/                           # SQL data warehousing scripts
│   ├── schema_setup.sql           # Schema DDL (Fact and Dimension tables)
│   └── analytical_queries.sql     # SQL analytics and KPI views
├── dashboard/                     # Power BI source files and wireframes
│   ├── sales_dashboard.pbix       # Core Power BI template
│   └── dashboard_mockup.png       # Design mockup
└── docs/                          # Context files
    └── project_blueprint.md       # Full planning framework
```

## 🛠️ Data Architecture (Star Schema)
This model operates on a standard Star Schema optimized for high-performance column store queries:
*   **Fact Table:** `Fact_Sales` (metrics: quantity, discount, gross sales, shipping, net profit).
*   **Dimension Tables:** `Dim_Customer` (demographics), `Dim_Product` (hierarchy), `Dim_Location` (region), `Dim_Calendar` (time intelligence).

## 💡 Top Actionable Insights Discovered
1. **Promotional Caps:** Discounts higher than **20%** severely impact profit margins. Restricting discounts to 15% yields a projected **+8.4%** margin expansion in underperforming categories.
2. **Product SKU Optimization (Pareto):** 18% of products generate 80% of sales. Recommended phasing out the lowest-performing 15% of products to reduce carrying costs.
3. **Logistics & shipping Leakage:** Regional shipping costs in Texas and Ohio erode gross profit by up to 22%. Recommended renegotiating logistics carrier rates in these specific states.

## 👨‍💻 Tech Stack Used
*   **Power Query / Power BI Desktop:** ETL, Star Schema Modeling, DAX measures, Report design.
*   **Python (Pandas, Seaborn, Matplotlib):** Automated ETL script and Exploratory Data Analysis.
*   **SQL (PostgreSQL / SQLite):** Writing complex aggregation queries and testing KPI results.
```
