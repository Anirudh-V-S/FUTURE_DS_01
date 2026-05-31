# Power BI Dashboard Front-End Visual Design & UI/UX Blueprint
## Project: Business Sales Performance Analytics
**Role:** Senior Power BI Dashboard Designer & UI/UX Lead Specialist  
**Design Standard:** Sleek Corporate Dark Mode (16:9 Canvas Ratio - 1280px × 720px)  
**Status:** Staged for Visual Implementation  

---

## 1. Global Visual Theme & Style Tokens
To stand out in placement interviews and internship evaluations, we avoid the default Power BI white-canvas themes. Instead, we implement a **Sleek Corporate Dark Mode** with high-contrast, harmonious accents that draw the reviewer's eyes directly to critical margin leakages.

### Custom JSON Theme Palette Configuration
```json
{
  "name": "Corporate Dark Mode",
  "dataColors": ["#00A8FF", "#2ECC71", "#E74C3C", "#9B59B6", "#F1C40F", "#34495E"],
  "background": "#0B0E14",
  "foreground": "#151A22",
  "tableAccent": "#00A8FF"
}
```

### Color Token Reference:
*   **Canvas Background:** Deep Charcoal (`#0B0E14`)
*   **Card Background:** Sleek Dark Slate (`#151A22` with 1px border `#1E2530` and rounded corners at 8px)
*   **Primary Accent (Sales/Volume):** Electric Neon Blue (`#00A8FF`)
*   **Secondary Accent (Profit/Growth):** Emerald Mint Green (`#2ECC71`)
*   **Alert Accent (Loss/Decline):** Crimson Coral Red (`#E74C3C`)
*   **Neutral Text (Primary Titles):** Ice White (`#F5F6FA`)
*   **Neutral Text (Secondary Labels):** Muted Slate Gray (`#8C92AC`)

---

## 2. Left-Navigation Panel (Universal on all 3 pages)
A vertical bar fixed on the far left of the canvas enables seamless, mobile-app-like page transitions.
*   **Dimensions:** Width: 80px | Height: 720px | Placement: X = 0, Y = 0
*   **Design:** Background: Dark Slate (`#151A22`) | Separator: 1px vertical line (`#1E2530`)
*   **Controls:** Three vertical icon buttons linking to each page (Executive, Product, Region) with a dynamic "Hover" state showing an Electric Blue border on the active page.

---

## 3. Page-by-Page Front-End Visual Specifications

### PAGE 1: Executive Summary
*   **Dashboard Objective:** Provide C-suite executives with an immediate visual summary of high-level financial health, highlighting revenue trends, margin thresholds, and performance targets.

```
┌────────────────────────────────────────────────────────────────────────┐
│ [NAV]  [SLICERS: Year | Region | Segment]                              │
│ ───┼───────────────────────────────────────────────────────────────────│
│    │ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌────────────┐ │
│    │ │ Revenue Card │ │ Profit Card  │ │ Margin Card  │ │ Orders Card│ │
│    │ └──────────────┘ └──────────────┘ └──────────────┘ └────────────┘ │
│    │ ┌──────────────────────────────────┐ ┌──────────────────────────┐ │
│    │ │                                  │ │                          │ │
│    │ │      Monthly Revenue Trend       │ │  Category Share (Donut)  │ │
│    │ │                                  │ │                          │ │
│    │ └──────────────────────────────────┘ └──────────────────────────┘ │
│    │ ┌──────────────────────────────────┐ ┌──────────────────────────┐ │
│    │ │                                  │ │                          │ │
│    │ │      Monthly Profit Trend        │ │  Segment Share (Donut)   │ │
│    │ │                                  │ │                          │ │
│    │ └──────────────────────────────────┘ └──────────────────────────┘ │
└────┴───────────────────────────────────────────────────────────────────┘
```

#### A. Global Slicers (Top Banner Grid: X=95, Y=10, Width=1170, Height=60)
*   **Slicer 1 (Date Selection):** Dropdown List | Field: `Dim_Calendar[Year]`
*   **Slicer 2 (Geography):** Horizontal Tile Buttons | Field: `Dim_Location[Region]`
*   **Slicer 3 (Customer Cohort):** Dropdown Checklist | Field: `Dim_Customer[Segment]`

#### B. KPI Cards Grid (Y = 80, Height = 90)
1.  **KPI 1: Gross Sales** | Type: *New Card Visual* | Width: 280px, X = 95
    *   *Metrics:* `[Total Revenue]` (formatted in large `$#,##0.00` font)
    *   *Visual indicator:* Sparkline trend of monthly sales in Electric Blue.
2.  **KPI 2: Net Earnings** | Type: *New Card Visual* | Width: 280px, X = 390
    *   *Metrics:* `[Total Profit]` (formatted in Emerald Mint Green font)
    *   *Visual indicator:* Sparkline trend of monthly profits.
3.  **KPI 3: Operating Margin** | Type: *New Card Visual* | Width: 280px, X = 685
    *   *Metrics:* `[Profit Margin %]`
    *   *Conditional Formatting:* Text turns Red if `< 10%`, Green if `>= 10%`.
4.  **KPI 4: Transaction Volume** | Type: *New Card Visual* | Width: 280px, X = 980
    *   *Metrics:* `[Total Orders]` (formatted in Ice White)

#### C. Revenue Trend (X = 95, Y = 190, Width = 600, Height = 230)
*   **Visual Type:** Area Chart
*   **Axis Columns:** `Dim_Calendar[Month_Short]` (X-Axis) sorted chronologically | `[Total Revenue]` (Y-Axis)
*   **Color Setting:** Fill Area: Neon Cyan (`#00A8FF`) with 80% transparency.
*   **Interactive Tooltip:** Custom tooltip page displaying product category sales breakdown for that specific month on hover.

#### D. Profit Trend (X = 95, Y = 440, Width = 600, Height = 230)
*   **Visual Type:** Clustered Column Chart
*   **Axis Columns:** `Dim_Calendar[Month_Short]` (X-Axis) | `[Total Profit]` (Y-Axis)
*   **Color Setting:** Positive Columns: Emerald Green (`#2ECC71`) | Negative Columns: Crimson Red (`#E74C3C`) to visually isolate profit leakages.

#### E. Sales by Category (X = 720, Y = 190, Width = 540, Height = 230)
*   **Visual Type:** Donut Chart
*   **Legend Fields:** `Dim_Product[Category]` | Values: `[Total Revenue]`
*   **User Interaction:** Clicking a category slice dynamically filters the trend line charts to isolate that category's trends.

#### F. Sales by Segment (X = 720, Y = 440, Width = 540, Height = 230)
*   **Visual Type:** Donut Chart
*   **Legend Fields:** `Dim_Customer[Segment]` | Values: `[Total Revenue]`
*   **Interaction Strategy:** Enables drill-through to Page 2 (Product Performance) focusing exclusively on the selected customer segment.

---

### PAGE 2: Product Performance Analysis
*   **Dashboard Objective:** Analyze product catalog performance, isolating high-margin items from heavily discounted, loss-making categories.

#### A. Slicers Banner (X=95, Y=10, Width=1170, Height=60)
*   **Slicers:** Dropdown Slicers for `Dim_Product[Category]` and `Dim_Customer[Segment]`.

#### B. Top 10 Products by Profit (X = 95, Y = 80, Width = 570, Height = 280)
*   **Visual Type:** Horizontal Bar Chart
*   **Fields:** `Dim_Product[Product_Name]` (Y-Axis) sorted by `[Total Profit]` | `[Total Profit]` (X-Axis)
*   **Filters:** Top N Filter: Show top 10 products by `[Total Profit]`.
*   **Color Setting:** Emerald Mint Green (`#2ECC71`)
*   **Tooltip:** Custom tooltip displaying quantity sold and average discount applied.

#### C. Bottom 10 Products by Profit (X = 690, Y = 80, Width = 570, Height = 280)
*   **Visual Type:** Horizontal Bar Chart
*   **Fields:** `Dim_Product[Product_Name]` (Y-Axis) sorted ascending by `[Total Profit]` | `[Total Profit]` (X-Axis)
*   **Filters:** Top N Filter: Show bottom 10 products by `[Total Profit]`.
*   **Color Setting:** Crimson Coral Red (`#E74C3C`)
*   **Tooltip:** Custom tooltip showing standard discount rates and the average shipping lag for these poorly performing items.

#### D. Sub-Category Performance Table (X = 95, Y = 380, Width = 570, Height = 310)
*   **Visual Type:** Matrix Visual
*   **Rows:** `Dim_Product[Category]` > `Dim_Product[Sub_Category]` | Columns: None
*   **Values:** `[Total Revenue]`, `[Total Profit]`, `[Profit Margin %]`, `[Average Discount %]`
*   **Conditional Formatting:** Soft color scales on Profit Margin % (red-to-green gradient) to easily spot margin-eroding sub-categories.

#### E. Discount vs. Profitability Scatter Plot (X = 690, Y = 380, Width = 570, Height = 310)
*   **Visual Type:** Scatter Plot
*   **Fields:** `Fact_Sales[Order_ID]` (Details) | `[Average Discount %]` (X-Axis) | `[Total Profit]` (Y-Axis)
*   **Analytical Constant Lines:** Add an X-axis constant reference line at **20% (0.20)** to show the exact discount threshold where transactions become loss-making.
*   **Color Setting:** Data points: Slate Gray (`#8C92AC`) with 40% transparency | Loss-making points: Highlighted in Red.

---

### PAGE 3: Regional Performance Analysis
*   **Dashboard Objective:** Analyze performance by geography and logistics, identifying logistics issues and regional variations in profitability.

#### A. Slicers Banner (X=95, Y=10, Width=1170, Height=60)
*   **Slicers:** Category selection, shipping modes (`Fact_Sales[Ship_Mode]`).

#### B. Geographic Map Visual (X = 95, Y = 80, Width = 570, Height = 350)
*   **Visual Type:** Azure Map / Filled Map
*   **Location:** `Dim_Location[State]` | Legend: `Dim_Location[Region]` | Bubble Size: `[Total Revenue]`
*   **Interactive Tooltip:** Displays `[Total Profit]` and `[Average Shipping Lag]` on hover.
*   **Drill-through:** Enables drilling down from State level directly to City level.

#### C. Regional Profit Matrix (X = 690, Y = 80, Width = 570, Height = 160)
*   **Visual Type:** Matrix
*   **Rows:** `Dim_Location[Region]` | Values: `[Total Revenue]`, `[Total Profit]`, `[Profit Margin %]`
*   **Formatting:** Alternating rows styled with Dark Slate colors to maintain Dark Mode consistency.

#### D. Shipping lag & Performance (X = 690, Y = 260, Width = 570, Height = 170)
*   **Visual Type:** Clustered Column & Line Chart
*   **X-Axis:** `Dim_Calendar[Month_Short]`
*   **Column Values:** `[Total Orders]` (Y-Axis Left) | Line Value: `[Average Shipping Lag]` (Y-Axis Right, formatted in Days)
*   **Target Constant Line:** Add a Y-axis target reference line on the right axis at **4.0 Days** (corporate SLA). Any month spiking above 4.0 highlights a supply-chain bottleneck.

#### E. State-wise Analysis Table (X = 95, Y = 455, Width = 1165, Height = 235)
*   **Visual Type:** Table Visual
*   **Fields:** `Dim_Location[State]`, `Dim_Location[Region]`, `[Total Revenue]`, `[Total Profit]`, `[Profit Margin %]`, `[Average Shipping Lag]`
*   **Interactive Controls:** Column headers allow users to quickly sort results (e.g., sorting ascending by margin to find underperforming states like Texas).

---

## 4. UI/UX Custom Tooltips & Drill-through Setup

### Dynamic Custom Tooltip Page: `Tooltip_Product_Breakdown`
*   *Design:* Hidden canvas page styled at 320px × 240px.
*   *Content:* Horizontal bar chart displaying `Dim_Product[Category]` sales.
*   *Trigger:* Configured on all main page trend line visuals. When a user hovers over any point on the trend line, the dynamic tooltip pops up to show a breakdown of product category sales for that specific period.

### Drill-through Pathway: Segment Deep-Dive
*   *Trigger:* Right-clicking any customer segment slice on Page 1's donut chart.
*   *Action:* Takes the user to Page 2 (Product Performance), automatically filtering all visualizations to show only the selected segment's product purchases.

---

## 5. Recruiter-Friendly Dashboard Best Practices
*   **Provide a "Reset Filters" Button:** Implement a Bookmark action button in the top right labeled "Reset Filters". This clears all user selections instantly, making the dashboard easy and intuitive to explore.
*   **Structure Your Visual Hierarchy logically:** Layout your canvas in a **Z-pattern** (KPI cards at the top, high-level summaries in the middle, and detailed tables at the bottom). This aligns with how humans naturally scan reports.
*   **Implement "Click-to-Select" cross-filtering:** Enable visual interactions across all charts. For example, clicking on a category slice in the donut chart should instantly filter the adjacent line chart, making the report feel interactive and alive.
*   **Label Custom Metrics Clearly:** Do not use raw DAX names. Ensure chart titles are descriptive (e.g., "Monthly Sales Trend" instead of "Sales by Order_Date").

---

## 6. Common BI Visual Mistakes to Avoid (The "Fail Case" Prevention)
*   **Avoid Overusing Pie Charts:** Never use pie or donut charts for dimensions with more than 3 categories. A donut chart with 15 segments is impossible to read and looks unprofessional. Use horizontal bar charts instead.
*   **Avoid Rainbow Color Schemes:** Stick to your core HSL color palette. Overusing bright, unharmonious colors creates visual noise that distracts from the actual data insights.
*   **Do Not Leave Native Auto-Date Hierarchies Active:** Power BI’s auto-date hierarchies create hidden tables that bloat your file size. Ensure auto-date hierarchies are turned off in settings, and rely solely on your custom `Dim_Calendar` table.
*   **Avoid Cluttered Layouts:** Leave **8px to 10px of margin space** between visual containers. Cramming visuals too close together looks messy and unprofessional.
