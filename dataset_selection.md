# Dataset Selection & Understanding Report
## Business Sales Performance Analytics
**Role:** Senior Data Analyst & BI Consultant  
**Project Phase:** Phase 1 (Ingestion & Data Understanding)  
**Status:** Approved for Implementation  

---

## 1. Executive Recommendation: US Superstore Dataset
For a high-impact, portfolio-grade project that will be reviewed by internship evaluators, technical recruiters, and hiring managers, we recommend the **US Superstore Dataset** (also commonly referenced as the Tableau Sample Superstore Dataset).

*   **Dataset Theme:** B2B/B2C retail distribution operations of an office products, technology, and furniture wholesaler.
*   **Recommended Source/Link:** [Kaggle - US Superstore Dataset](https://www.kaggle.com/datasets/juanshishido/us-superstore-dataset) or [Tableau Community Data Share](https://community.tableau.com/s/question/0D54T00000V9ypnSAB/sample-superstore-sales-excelxls).
*   **Alternative Flat-File Mirror:** [US Superstore Sales (GitHub Raw)](https://raw.githubusercontent.com/datasets/master/data/raw/superstore.csv).

---

## 2. Competitive Analysis: Why the Superstore Dataset Wins
Before selecting a dataset, we must evaluate it against common industry alternatives. Below is our comparative audit:

| Feature Parameter | US Superstore Dataset (Recommended) | AdventureWorks DW (SQL/Power BI) | Northwind DB (SQL Standard) |
| :--- | :--- | :--- | :--- |
| **Relatability** | **High:** Standard products (Chairs, Phones, Paper) everyone understands. | **Medium:** High-specialty bicycle manufacturing components. | **Low:** Historical food distribution; dated product lists. |
| **Time Intelligence** | **High:** 4 full consecutive years of daily transactions. | **High:** Spans multiple years, but schema setup is highly complex. | **Low:** Very narrow date range (mostly 1996-1998 data). |
| **Geographic Depth** | **High:** Granular fields (Country, Region, State, City, Zip). | **Medium:** Geographies exist but require multiple joint tables. | **Low:** Minimal cities; poorly populated geographical data. |
| **Discounting Metrics** | **High:** Includes item-level dynamic discounts (0% to 80%). | **Low:** Promotional structures are complex and rarely populated. | **Medium:** Discounts exist but are simple. |
| **Setup Complexity** | **Low/Medium:** Delivered as a single wide file; ideal for proving ETL. | **High:** Over 25 interconnected tables; steep setup curve. | **Medium:** Over 10 tables; setup is slow for single-page dashboards. |
| **Interview Appeal** | **Exceptional:** Excellent for testing direct margin and discount leakage. | **High:** Good for enterprise data warehousing but slower to build. | **Low:** Considered too basic or dated by modern recruiters. |

---

## 3. Mapping Columns to Business Output
To build a highly strategic Power BI dashboard, we categorize the available dataset columns directly into their operational business functions:

```
┌────────────────────────────────────────────────────────────────────────┐
│                          COLUMN BUSINESS MAPPING                       │
├───────────────────┬───────────────────┬──────────────────┬─────────────┤
│   KPI Drivers     │  Visual Slicers   │ Geographic Maps  │ Trend Lines │
│ (Numerical Facts) │(Dimension Filters)│ (Spatial Charts) │ (Temporal)  │
├───────────────────┼───────────────────┼──────────────────┼─────────────┤
│  • Sales          │  • Segment        │  • Region        │ • Order Date│
│  • Profit         │  • Category       │  • State         │ • Ship Date │
│  • Quantity       │  • Sub-Category   │  • City          │             │
│  • Discount       │  • Customer Name  │  • Postal Code   │             │
│  • Shipping Cost  │                   │                  │             │
└───────────────────┴───────────────────┴──────────────────┴─────────────┘
```

### 1. Columns for Key Performance Indicators (KPIs)
*   `Sales`, `Profit`, and `Quantity` will be aggregated using DAX measures to compute **Total Sales**, **Total Profit**, and **Average Order Value (AOV)**.
*   `Discount` will be averaged (`AVERAGE(Superstore[Discount])`) to monitor coupon rate pressure.
*   `Profit` divided by `Sales` will drive our **Net Profit Margin %** KPI.

### 2. Columns for Dashboard Visualizations
*   `Category` and `Sub-Category` will drive stacked column charts and tree maps.
*   `Segment` (Consumer, Corporate, Home Office) will drive segment breakdowns (Donut/Pie charts).
*   `State`, `City`, and `Postal Code` will feed the spatial map bubbles and location performance matrices.
*   `Order Date` will drive line charts showing chronological sales trends, seasonality spikes, and running totals.

### 3. Columns for Strategic Insights
*   `Customer ID` and `Customer Name` allow for customer concentration analysis (Pareto 80/20 rule, identifying top high-value customers).
*   `Discount` paired with `Profit` on a scatter plot isolates where promotions are actively damaging bottom-line profitability.
*   `Ship Mode` paired with `Shipping Cost` will highlight shipping efficiency and carrier margin leakage.

---

## 4. Comprehensive Data Dictionary
Below is the definitive schema catalog for the **US Superstore Dataset**. These data types are modeled to align with modern Data Lake/Data Warehouse standards.

| Column Name | Logical Data Type | Physical Data Type | Business Description | Business Usage & Analytical Calculations |
| :--- | :--- | :--- | :--- | :--- |
| `Row ID` | Categorical ID | `INTEGER` | Sequential unique identifier for each dataset row. | Primary Key constraint check. Used to audit duplicate entries. |
| `Order ID` | Transactional ID | `VARCHAR(50)` | System-generated unique code for each customer purchase. | Used to count distinct transactions: `DISTINCTCOUNT(Order_ID)`. |
| `Order Date` | Chronological | `DATE` | Date when the order was officially placed by the customer. | Crucial filter for all Power BI Time Intelligence DAX measures (YTD, YoY, MoM). |
| `Ship Date` | Chronological | `DATE` | Date when the order left the distribution warehouse. | Paired with `Order Date` to calculate shipping latency/lag: `DATEDIFF(Order_Date, Ship_Date, DAY)`. |
| `Ship Mode` | Categorical Flag | `VARCHAR(50)` | Shipping class selected (e.g., 'Same Day', 'First Class', 'Standard Class'). | Visual slicer to evaluate logistical efficiency and cost margins by carrier class. |
| `Customer ID` | Dimensional Key | `VARCHAR(50)` | Unique identifier for each individual or corporate client. | Used to measure unique customer count, customer loyalty, and cohort analysis. |
| `Customer Name`| Dimensional Attribute| `VARCHAR(100)` | Full commercial name of the customer entity. | Used in tables to highlight high-value accounts. |
| `Segment` | Dimensional Attribute| `VARCHAR(50)` | Segment category (e.g., 'Consumer', 'Corporate', 'Home Office'). | Categorical visual slicer used to filter revenue trends by corporate account sizes. |
| `Country` | Geographic | `VARCHAR(100)` | Shipping destination country. | Global filter for mapping visuals. |
| `City` | Geographic | `VARCHAR(100)` | Shipping destination city. | High-granularity filter for spatial map models. |
| `State` | Geographic | `VARCHAR(100)` | Shipping destination state/province. | Crucial level of aggregation for regional reporting (e.g., California vs Texas). |
| `Postal Code` | Geographic / Spatial | `VARCHAR(20)` | ZIP/postal code of delivery address. | Ideal for high-precision geospatial bubble mapping inside Power BI. |
| `Region` | Geographic | `VARCHAR(50)` | Corporate sales territory (e.g., 'East', 'West', 'Central', 'South'). | Primary filter to analyze executive performance by regional sales directors. |
| `Product ID` | Dimensional Key | `VARCHAR(50)` | Unique catalog SKU for the product sold. | Primary key linking transactions to product inventory database. |
| `Category` | Dimensional Attribute| `VARCHAR(100)` | Broad product division (Furniture, Technology, Office Supplies). | High-level organizational axis for sales matrices and trend analysis. |
| `Sub-Category` | Dimensional Attribute| `VARCHAR(100)` | Sub-division under main Category (e.g., Phones, Chairs, Paper). | Medium-level granularity for catalog margin analysis. |
| `Product Name` | Dimensional Attribute| `VARCHAR(255)` | Full commercial product name. | Used to build low-level top 10/bottom 10 performance lists. |
| `Sales` | Fact Metric | `DECIMAL(12, 4)` | Net sales value of the order line after discounts. | Fact metric aggregated for **Total Revenue** calculations. |
| `Quantity` | Fact Metric | `INTEGER` | Number of units purchased in this transaction. | Numeric count aggregated for **Total Units Sold** and unit sales volume. |
| `Discount` | Fact Metric | `DECIMAL(4, 2)` | Percentage discount applied (expressed as decimal from `0.00` to `0.80`). | Metric used in scatter plots to analyze price elasticity and margin impact. |
| `Profit` | Fact Metric | `DECIMAL(12, 4)` | Net profit contributed by the order line (can be negative). | Core fact metric aggregated for **Total Net Profit** and **Profit Margin %** calculations. |

---

> [!TIP]
> **Data Validation Advice:** When reviewing the dataset for the first time, always verify that:
> 1. `Ship Date` is greater than or equal to `Order Date`.
> 2. `Sales` values align with `(Quantity * Unit Price) * (1 - Discount)` if a separate Unit Price column is available.
> 3. Sub-categories strictly map to a single main Category (i.e. 'Phones' should only map to 'Technology').
