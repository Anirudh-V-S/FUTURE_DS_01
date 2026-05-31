# Power BI Desktop Developer Implementation Guide
## Project: Business Sales Performance Analytics
**Role:** Senior Power BI Developer & Implementation Lead  
**Objective:** Operational step-by-step guide to build the dashboard inside Power BI Desktop.  
**Target File:** `dashboard/sales_dashboard.pbix`  

---

## Step 1: Initialize Workspace & Global Configurations
Before importing a single byte of data, we must optimize Power BI’s internal options to prevent file bloat and protect chronological calculations:

1.  Open **Power BI Desktop**.
2.  Navigate to **File -> Options and Settings -> Options**.
3.  Under the **Global** tab, select **Data Load**:
    *   *Uncheck:* "Detect column types and headers for unstructured sources" (We will cast them manually for data integrity).
4.  Under the **Current File** tab, select **Data Load**:
    *   *Uncheck:* "Auto date/time" under Time Intelligence. 
    *   *Why:* This prevents Power BI from creating hidden, duplicate auto-generated calendar tables behind the scenes.
5.  Save your project immediately as `dashboard/sales_dashboard.pbix`.

---

## Step 2: Data Import & Power Query ETL Splits
We ingest the pre-processed sales CSV and split it into normalized dimension lookups and a central fact table using the **Reference Query Strategy** (the cleanest method for maintaining query lineage).

```
          ┌─────────────────────────┐
          │  cleaned_superstore.csv │ (Raw Ingest)
          └────────────┬────────────┘
                       │
       ┌───────────────┼───────────────┬────────────────┐
       ▼               ▼               ▼                ▼
┌──────────────┐┌──────────────┐┌──────────────┐┌──────────────┐
│  Fact_Sales  ││ Dim_Customer ││ Dim_Product  ││ Dim_Location │
└──────────────┘└──────────────┘└──────────────┘└──────────────┘
```

### A. Raw Ingest
1.  Click **Home -> Get Data -> Text/CSV**. Select `data/processed/cleaned_superstore.csv`.
2.  Click **Transform Data** to launch the Power Query Editor.

### B. Create Dimension 1: `Dim_Customer`
1.  In the Queries pane (left), right-click `cleaned_superstore` and select **Reference**.
2.  Rename the new query to `Dim_Customer`.
3.  Select columns: `customer_id`, `customer_name`, `segment`.
4.  Right-click any selected header and select **Remove Other Columns**.
5.  Right-click `customer_id` and select **Remove Duplicates**.

### C. Create Dimension 2: `Dim_Product`
1.  Right-click `cleaned_superstore` and select **Reference**. Rename to `Dim_Product`.
2.  Select columns: `product_id`, `product_name`, `category`, `sub_category`.
3.  Right-click and select **Remove Other Columns**.
4.  Right-click `product_id` and select **Remove Duplicates**.

### D. Create Dimension 3: `Dim_Location`
1.  Right-click `cleaned_superstore` and select **Reference**. Rename to `Dim_Location`.
2.  Select columns: `postal_code`, `city`, `state`, `region`, `country`.
3.  Right-click and select **Remove Other Columns**.
4.  Right-click `postal_code` and select **Remove Duplicates**.
5.  Rename `postal_code` column to `Location_ID`.

### E. Configure Central Fact Table: `Fact_Sales`
1.  Select the original `cleaned_superstore` query. Rename it to `Fact_Sales`.
2.  Select and **Remove** the descriptive text columns that have been split out: `customer_name`, `product_name`, `category`, `sub_category`, `city`, `state`, `region`, `country`. Keep the key columns (`customer_id`, `product_id`, `postal_code` -> rename to `Location_ID`, `order_date`, `ship_date`) and facts (`sales`, `profit`, `quantity`, `discount`).
3.  Click **Home -> Close & Apply** in the top left to load the tables into the model.

---

## Step 3: Calendar Table Generation
1.  In the Report View, navigate to the **Modeling** tab in the top ribbon.
2.  Click **New Table** and paste the following DAX formula:
    ```dax
    Dim_Calendar = 
    VAR MinDate = MIN(Fact_Sales[Order_Date])
    VAR MaxDate = MAX(Fact_Sales[Order_Date])
    RETURN
    ADDCOLUMNS(
        CALENDAR(MinDate, MaxDate),
        "Year", YEAR([Date]),
        "Year_Name", "CY " & YEAR([Date]),
        "Month_No", MONTH([Date]),
        "Month_Name", FORMAT([Date], "MMMM"),
        "Month_Short", FORMAT([Date], "MMM"),
        "Quarter_No", QUARTER([Date]),
        "Quarter_Name", "Q" & FORMAT([Date], "Q"),
        "Quarter_Year", "Q" & FORMAT([Date], "Q") & "-" & YEAR([Date]),
        "Week_No", WEEKNUM([Date]),
        "Day_No", DAY([Date]),
        "Day_Name", FORMAT([Date], "dddd"),
        "Day_Short", FORMAT([Date], "ddd"),
        "Day_Of_Week", WEEKDAY([Date]),
        "Is_Weekend", IF(WEEKDAY([Date]) IN {1, 7}, 1, 0)
    )
    ```
3.  Navigate to **Data View** -> select the `Dim_Calendar` table.
4.  Select the `Month_Name` column. In the **Column Tools** ribbon, click **Sort by Column -> Month_No**.
5.  Select the `Quarter_Name` column. Click **Sort by Column -> Quarter_No**.

---

## Step 4: Relationship Configurations
1.  Navigate to the **Model View** (third icon on the left pane).
2.  Drag primary keys to foreign keys to configure relationships exactly as follows:

| From (Dimension) | To (Fact) | Cardinality | Cross Filter | State |
| :--- | :--- | :--- | :--- | :--- |
| `Dim_Customer[Customer_ID]` | `Fact_Sales[Customer_ID]` | `1 to Many (1:*)` | Single | **Active** |
| `Dim_Product[Product_ID]` | `Fact_Sales[Product_ID]` | `1 to Many (1:*)` | Single | **Active** |
| `Dim_Location[Location_ID]` | `Fact_Sales[Location_ID]` | `1 to Many (1:*)` | Single | **Active** |
| `Dim_Calendar[Date]` | `Fact_Sales[Order_Date]` | `1 to Many (1:*)` | Single | **Active** |
| `Dim_Calendar[Date]` | `Fact_Sales[Ship_Date]` | `1 to Many (1:*)` | Single | **Inactive** |

---

## Step 5: Theme & UI Canvas Setup
1.  Navigate to **View** ribbon tab. Click the dropdown arrow on the Themes gallery and select **Browse for themes**.
2.  Create a JSON file named `dark_theme.json` with the following content, and import it:
    ```json
    {
      "name": "Corporate Dark Theme",
      "dataColors": ["#00A8FF", "#2ECC71", "#E74C3C", "#9B59B6", "#F1C40F", "#34495E"],
      "background": "#0B0E14",
      "foreground": "#151A22",
      "tableAccent": "#00A8FF"
    }
    ```
3.  Click on the empty space of the canvas. In the **Format Pane** (right), select **Canvas settings**:
    *   *Type:* 16:9 (1280px × 720px).
4.  Under **Canvas background**:
    *   *Color:* `#0B0E14` (Deep Charcoal).
    *   *Transparency:* **0%**.

---

## Step 6: Create Dedicated Measures Table
1.  On the **Home** ribbon tab, click **Enter Data**.
2.  Rename the table to `_Measures` and click **Load**.
3.  Right-click `_Measures` and select **New Measure** to enter your advanced metrics:
    *   *Example Core Measure:*
        ```dax
        Total Revenue = SUM(Fact_Sales[Sales])
        ```
4.  Once you have created your first measure, right-click the default "Column1" in the fields pane and select **Delete from Model**. The table icon will transform into a calculator, indicating a dedicated measure folder.
5.  Select a measure, go to the **Measure Tools** ribbon tab, and enter a display folder name (e.g., `1. Core Metrics`, `2. Ratios`, `3. Time Intelligence`) in the **Display folder** textbox. This organizes your measures cleanly.

---

## Step 7: Front-End UI Layout Execution

### A. Dynamic Left Navigation Panel
1.  Select **Insert ribbon -> Shapes -> Rectangle**.
2.  Set coordinates: X = 0, Y = 0, Width = 80px, Height = 720px.
3.  Set Formatting: Background Fill: `#151A22` | Border: None.
4.  Add three vertical **Button Visuals (Blank)** inside the navigation panel (linked to Page 1, Page 2, Page 3).
5.  In the button formatting options, navigate to **Action**:
    *   *Type:* **Page navigation**.
    *   *Destination:* Match each button to its respective page target.

### B. Visual Container Styling Rules
To maintain visual consistency across all three pages, format every card and chart container exactly as follows:
*   **Size & Position:** Align elements to a standard spacing grid (e.g. 10px margin space between adjacent visual cards).
*   **Container Background:** Set Fill to `#151A22` (Sleek Slate) and Transparency to 0%.
*   **Rounded Corners:** Enable under **Visual border -> Rounded corners: 8px** | Color: `#1E2530` (1px width).
*   **Typography:** Title Font: `Segoe UI Semibold` (14pt, color: `#F5F6FA`) | Label Font: `Segoe UI` (10pt, color: `#8C92AC`).
*   **Chart Gridlines:** Turn off all vertical and horizontal gridlines in bar/line charts to maintain a clean, professional aesthetic.

---

## Step 8: Advanced Custom Tooltip & Drill-through Setup

### A. Hidden Tooltip Page (`Tooltip_Product_Breakdown`)
1.  Click **New Page** (+ icon at the bottom). Rename to `Tooltip_Product_Breakdown`.
2.  In the Canvas properties (right pane):
    *   Set **Page information -> Allow use as tooltip: ON**.
    *   Set **Canvas settings -> Type: Tooltip (320px × 240px)**.
    *   Set **Canvas background -> Color: `#151A22`** (0% transparency).
3.  Add a **Horizontal Bar Chart**:
    *   *Y-Axis:* `Dim_Product[Category]` | *X-Axis:* `[Total Revenue]` (formatted in Cyan `#00A8FF`).
4.  Right-click page tab and select **Hide Page** (so report users only see it as a hover pop-up).
5.  Go to Page 1, click on your Monthly Revenue Trend line chart, and navigate to **Format Pane -> General -> Tooltips**:
    *   *Type:* **Report Page**.
    *   *Page:* **Tooltip_Product_Breakdown**.

### B. Visual Segment Drill-through
1.  On Page 2 (Product Performance), go to the **Build Visual** pane (right).
2.  Scroll down to the **Drill-through** bucket.
3.  Drag `Dim_Customer[Segment]` into the drill-through fields bucket.
4.  Now, when a user right-clicks any segment on Page 1's donut charts, the context menu will offer **Drill-through -> Page 2**, taking them to the detailed product page with segment filters automatically applied.

---

## Step 9: Final Dashboard Quality Assurance (QA) Checklist
Before exporting your template and pushing files to GitHub, run these five validation checks:

1.  **Date Consistency Check:** Add a matrix on a temporary page using years from `Dim_Calendar` and dynamic sales from `Fact_Sales`. Verify that the annual sales match your calculations in Python to prove that your calendar model works correctly.
2.  **No Blanks Check:** Check every visual card to ensure no metric shows `(Blank)`. If a dynamic YoY metric returns empty for the first historical year, wrap the calculation in a DAX `COALESCE` or `IF(ISBLANK())` function to display a default `0.0%` value instead.
3.  **Active Date Validation:** Verify that your core line charts are sorting chronological dates based on `Order_Date` (Active link), and check that shipped revenue metrics use the `USERELATIONSHIP(Fact_Sales[Ship_Date], Dim_Calendar[Date])` connection.
4.  **Hiding System Columns:** Navigate to Model View and check that foreign keys (`customer_id`, `product_id`, `postal_code`, `row_id`) inside the `Fact_Sales` table are hidden to prevent accidental calculation errors by report creators.
5.  **Performance Test:** Click **View ribbon -> Performance Analyzer**. Click **Start recording** and refresh your visuals. Verify that no visual takes longer than **400ms** to load, proving that your VertiPaq column-indexing is highly optimized.
