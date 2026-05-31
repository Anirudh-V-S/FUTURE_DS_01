-- =========================================================================
-- DATABASE SCHEMA SETUP (DDL)
-- Project: Business Sales Performance Analytics
-- Architecture: Star Schema (Dimensional Model)
-- Target RDBMS Compatibility: PostgreSQL / SQLite
-- =========================================================================

-- 1. Create Customer Dimension Table
CREATE TABLE dim_customer (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    segment VARCHAR(50) NOT NULL
);

-- 2. Create Product Dimension Table
CREATE TABLE dim_product (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    sub_category VARCHAR(100) NOT NULL
);

-- 3. Create Location Dimension Table
CREATE TABLE dim_location (
    location_id VARCHAR(50) PRIMARY KEY, -- Maps ZIP/Postal Code
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'United States'
);

-- 4. Create Calendar Dimension Table
CREATE TABLE dim_calendar (
    date_key DATE PRIMARY KEY,
    year INT NOT NULL,
    year_name VARCHAR(10) NOT NULL,
    month_no INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    month_short VARCHAR(5) NOT NULL,
    quarter_no INT NOT NULL,
    quarter_name VARCHAR(5) NOT NULL,
    quarter_year VARCHAR(10) NOT NULL,
    week_no INT NOT NULL,
    day_no INT NOT NULL,
    day_name VARCHAR(20) NOT NULL,
    day_short VARCHAR(5) NOT NULL,
    day_of_week INT NOT NULL,
    is_weekend INT NOT NULL -- 1 = Yes, 0 = No
);

-- 5. Create Central Sales Fact Table
CREATE TABLE fact_sales (
    row_id INT PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) REFERENCES dim_customer(customer_id),
    product_id VARCHAR(50) REFERENCES dim_product(product_id),
    location_id VARCHAR(50) REFERENCES dim_location(location_id),
    order_date DATE REFERENCES dim_calendar(date_key),
    ship_date DATE NOT NULL,
    ship_mode VARCHAR(50) NOT NULL,
    sales DECIMAL(12, 2) NOT NULL,
    quantity INT NOT NULL,
    discount DECIMAL(4, 2) NOT NULL DEFAULT 0.00,
    profit DECIMAL(12, 2) NOT NULL,
    
    -- Enforce basic shipping logical consistency
    CONSTRAINT chk_shipping_date CHECK (ship_date >= order_date),
    CONSTRAINT chk_quantity CHECK (quantity > 0)
);

-- Create secondary indexes for performance optimization
CREATE INDEX idx_sales_order_date ON fact_sales(order_date);
CREATE INDEX idx_sales_customer ON fact_sales(customer_id);
CREATE INDEX idx_sales_product ON fact_sales(product_id);
CREATE INDEX idx_sales_location ON fact_sales(location_id);
