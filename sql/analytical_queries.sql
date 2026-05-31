-- =========================================================================
-- ANALYTICAL BUSINESS QUERIES (DML)
-- Project: Business Sales Performance Analytics
-- Target RDBMS Compatibility: PostgreSQL / Standard SQL
-- =========================================================================

-- 1. Executive Summary Financial KPIs
SELECT 
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_net_profit,
    COUNT(DISTINCT order_id) AS total_order_volume,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS average_order_value,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_percentage,
    ROUND(AVG(discount) * 100, 2) AS average_discount_percentage
FROM 
    fact_sales;

-- 2. Category & Sub-Category Profitability Rankings
SELECT 
    p.category,
    p.sub_category,
    ROUND(SUM(f.sales), 2) AS gross_revenue,
    ROUND(SUM(f.profit), 2) AS net_profit,
    ROUND((SUM(f.profit) / SUM(f.sales)) * 100, 2) AS profit_margin_percentage
FROM 
    fact_sales f
JOIN 
    dim_product p ON f.product_id = p.product_id
GROUP BY 
    p.category, 
    p.sub_category
ORDER BY 
    net_profit DESC;

-- 3. Customer Segment Purchasing Profiles
SELECT 
    c.segment,
    ROUND(SUM(f.sales), 2) AS total_sales,
    ROUND(SUM(f.profit), 2) AS total_profit,
    ROUND((SUM(f.profit) / SUM(f.sales)) * 100, 2) AS profit_margin_percentage,
    COUNT(DISTINCT f.order_id) AS order_count,
    ROUND(SUM(f.sales) / COUNT(DISTINCT f.order_id), 2) AS average_order_value
FROM 
    fact_sales f
JOIN 
    dim_customer c ON f.customer_id = c.customer_id
GROUP BY 
    c.segment
ORDER BY 
    total_sales DESC;

-- 4. Geographic Profit Leakage Audit (Outlining Texas / Ohio issues)
SELECT 
    l.state,
    l.region,
    ROUND(SUM(f.sales), 2) AS total_sales,
    ROUND(SUM(f.profit), 2) AS total_profit,
    ROUND((SUM(f.profit) / SUM(f.sales)) * 100, 2) AS profit_margin_percentage,
    ROUND(AVG(f.discount) * 100, 2) AS average_discount_applied
FROM 
    fact_sales f
JOIN 
    dim_location l ON f.location_id = l.location_id
GROUP BY 
    l.state, 
    l.region
ORDER BY 
    total_profit ASC -- Sorts lowest first to highlight profit drains
LIMIT 10;

-- 5. Shipping Lag & Fulfillment SLA Analysis
SELECT 
    l.region,
    COUNT(f.order_id) AS total_orders_shipped,
    ROUND(AVG(f.ship_date - f.order_date), 1) AS average_shipping_lag_days,
    SUM(CASE WHEN (f.ship_date - f.order_date) > 4 THEN 1 ELSE 0 END) AS sla_violations_count,
    ROUND((SUM(CASE WHEN (f.ship_date - f.order_date) > 4 THEN 1 ELSE 0 END) * 1.0 / COUNT(f.order_id)) * 100, 2) AS sla_violation_rate_percentage
FROM 
    fact_sales f
JOIN 
    dim_location l ON f.location_id = l.location_id
GROUP BY 
    l.region
ORDER BY 
    average_shipping_lag_days DESC;

-- 6. Promotional Discount Inflection Point Audit
-- Evaluates transaction outcomes grouped by discount intervals to prove the 20% break-even limit
SELECT 
    f.discount AS discount_rate,
    COUNT(f.order_id) AS transaction_volume,
    ROUND(SUM(f.sales), 2) AS total_sales,
    ROUND(SUM(f.profit), 2) AS net_profit,
    ROUND((SUM(f.profit) / SUM(f.sales)) * 100, 2) AS net_margin_percentage,
    SUM(CASE WHEN f.profit < 0 THEN 1 ELSE 0 END) AS unprofitable_orders_count,
    ROUND((SUM(CASE WHEN f.profit < 0 THEN 1 ELSE 0 END) * 1.0 / COUNT(f.order_id)) * 100, 2) AS unprofitable_rate_percentage
FROM 
    fact_sales f
GROUP BY 
    f.discount
ORDER BY 
    f.discount ASC;
