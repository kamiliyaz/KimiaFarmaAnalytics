-- Create Transaction Details Table (Table 1)
-- Creating a Common Table Expression (CTE) to calculate additional columns
WITH calculated_columns AS (
  -- Selecting necessary columns and calculating derived columns
  SELECT
    t.transaction_id, -- Unique identifier for each transaction
    t.product_id, -- Unique identifier for each product
    t.price AS actual_price, -- The actual price of the product
    t.discount_percentage, -- The discount percentage applied to the product
    -- Calculating gross profit percentage based on price tiers
    CASE
      WHEN t.price <= 50000 THEN 0.1
      WHEN t.price <= 100000 THEN 0.15
      WHEN t.price <= 300000 THEN 0.2
      WHEN t.price <= 500000 THEN 0.25
      ELSE 0.3
    END AS persentase_gross_laba,
    -- Calculating net sales after discount
    CAST(t.price - (t.price * t.discount_percentage) AS INT64) AS nett_sales,
    -- Truncating date to month for grouping purposes
    DATE_TRUNC(t.date, MONTH) AS month
  FROM `kimia_farma.kf_final_transaction` AS t -- Selecting data from the final transaction table
)

-- Selecting columns to be displayed from the calculated columns
SELECT
  month, -- Month of the transaction
  transaction_id, -- Unique identifier for each transaction
  product_id, -- Unique identifier for each product
  actual_price, -- The actual price of the product
  discount_percentage, -- The discount percentage applied to the product
  persentase_gross_laba, -- The gross profit percentage based on price tiers
  nett_sales, -- The net sales after discount
  CAST(nett_sales * persentase_gross_laba AS INT64) AS nett_profit -- Calculating net profit
FROM calculated_columns;



-- Create Product Details Table (Table 2)
-- Creating a Common Table Expression (CTE) to calculate additional columns for each transaction
WITH calculated_columns AS (
  -- Selecting necessary columns and calculating derived columns
  SELECT
    t.transaction_id, -- Unique identifier for each transaction
    t.price AS actual_price, -- The actual price of the transaction
    t.discount_percentage, -- The discount percentage applied to the transaction
    -- Calculating gross profit percentage based on price tiers
    CASE
      WHEN t.price <= 50000 THEN 0.1
      WHEN t.price <= 100000 THEN 0.15
      WHEN t.price <= 300000 THEN 0.2
      WHEN t.price <= 500000 THEN 0.25
      ELSE 0.3
    END AS persentase_gross_laba,
    -- Calculating net sales after discount
    CAST(t.price - (t.price * t.discount_percentage) AS INT64) AS nett_sales,
    -- Truncating transaction date to month for grouping purposes
    DATE_TRUNC(t.date, MONTH) AS month
  FROM `kimia_farma.kf_final_transaction` AS t -- Selecting data from the final transaction table
),
-- Creating a CTE to calculate monthly profits and growth
monthly_calculated AS (
  -- Aggregating data for each month
  SELECT
    month, -- The month of the transaction
    SUM(nett_sales * persentase_gross_laba) AS monthly_profit, -- Total profit for the month
    LAG(SUM(nett_sales * persentase_gross_laba)) OVER (ORDER BY month) AS prev_month_profit, -- Profit from the previous month
    SUM(nett_sales * persentase_gross_laba) - LAG(SUM(nett_sales * persentase_gross_laba)) OVER (ORDER BY month) AS monthly_growth,
    ROUND((SUM(nett_sales * persentase_gross_laba) - LAG(SUM(nett_sales * persentase_gross_laba)) OVER (ORDER BY month)) / LAG(SUM(nett_sales * persentase_gross_laba)) OVER (ORDER BY month) * 100) AS monthly_growth_rate
  FROM calculated_columns
  GROUP BY month
  ORDER BY month
)
-- Selecting columns to be displayed from the monthly_calculated columns
SELECT
  month,
  prev_month_profit,
  monthly_growth,
  monthly_growth_rate
FROM monthly_calculated;

  

-- Create Transaction Metrics Table (Table 3)
-- Selecting transaction details along with branch and product information
SELECT
  t.transaction_id, -- Unique identifier for each transaction
  t.date, -- Date of the transaction
  k.branch_id, -- Unique identifier for the branch
  k.branch_name, -- Name of the branch
  k.kota, -- City of the branch
  k.provinsi, -- Province of the branch
  k.rating AS rating_cabang, -- Rating of the branch
  t.customer_name, -- Name of the customer
  t.rating AS rating_transaksi -- Rating of the transaction
FROM `kimia_farma.kf_final_transaction` AS t -- Selecting data from the final transaction table
LEFT JOIN `kimia_farma.kf_kantor_cabang` AS k ON t.branch_id = k.branch_id -- Joining with the branch table to get branch information
LEFT JOIN `kimia_farma.kf_product` AS p ON t.product_id = p.product_id;



-- Creating Product Details Table (Table 4)
-- Selecting product details along with inventory information
SELECT
  p.product_id, -- Unique identifier for each product
  p.product_name, -- Name of the product
  p.price AS actual_price, -- Actual price of the product
  i.opname_stock -- Inventory stock count
FROM `kimia_farma.kf_product` AS p -- Selecting data from the product table
LEFT JOIN `kimia_farma.kf_inventory` AS i ON p.product_id = i.product_id; -- Joining with the inventory table to get inventory information
