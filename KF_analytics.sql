
-- Creating CTE to calculate additional columns
WITH calculated_columns AS (
  -- Creating calculated_column title from transaction_id, price, and discount_percentage columns from kf_final_transaction table
  SELECT
    t.transaction_id,
    t.price AS actual_price,
    t.discount_percentage,
    -- Creating persentase_gross_laba column as specified
    CASE
      WHEN t.price <= 50000 THEN 0.1
      WHEN t.price <= 100000 THEN 0.15
      WHEN t.price <= 300000 THEN 0.2
      WHEN t.price <= 500000 THEN 0.25
      ELSE 0.3
    END AS persentase_gross_laba,
    -- Creating nett_sales column by subtracting actual price from discounted price, and rounding it
    CAST(t.price - (t.price * t.discount_percentage) AS INT64) AS nett_sales,
    -- Truncating date to month
    DATE_TRUNC(t.date, MONTH) AS month
     -- Selecting input columns from kf_final_transaction table (initial t)
  FROM `kimia_farma.kf_final_transaction` AS t
),
-- Creating CTE 2 to calculate monthly profit and growth
monthly_calculated AS (
  SELECT
    cc.month,
    --creating previous month profit coloumn with window
    SUM(cc.nett_sales * cc.persentase_gross_laba) AS monthly_profit,
    LAG(SUM(cc.nett_sales * cc.persentase_gross_laba)) OVER (ORDER BY cc.month) AS prev_month_profit,
    --creating monthly growth profit coloumn 
    (SUM(cc.nett_sales * cc.persentase_gross_laba)) - LAG(SUM(cc.nett_sales * cc.persentase_gross_laba)) OVER (ORDER BY cc.month) AS monthly_growth,
    --creat monthly growth rate column and round its value
    ROUND(((SUM(cc.nett_sales * cc.persentase_gross_laba)) - LAG(SUM(cc.nett_sales * cc.persentase_gross_laba)) OVER (ORDER BY cc.month)) / LAG(SUM(cc.nett_sales * cc.persentase_gross_laba)) OVER (ORDER BY cc.month) * 100) AS monthly_growth_rate
    -- Selecting input columns from CTE table 1 (calculated_columns) (initial cc) and group the value by month
  FROM calculated_columns AS cc
  GROUP BY cc.month
)
-- Selecting columns to be displayed
SELECT
  t.transaction_id,
  t.date,
  k.branch_id,
  k.branch_name,
  k.kota,
  k.provinsi,
  k.rating AS rating_cabang,
  t.customer_name,
  t.product_id,
  p.product_name,
  cc.actual_price,
  cc.discount_percentage,
  cc.persentase_gross_laba,
  cc.nett_sales,
  mc.monthly_profit,
  mc.prev_month_profit,
  mc.monthly_growth,
  mc.monthly_growth_rate,
  -- Calculating nett_profit and rounding it so the profit is not decimals
  CAST(cc.nett_sales * cc.persentase_gross_laba AS INT64) AS nett_profit,
  t.rating AS rating_transaksi,
  i.opname_stock
  -- Selecting input columns from kf_final_transaction table (initial t)
FROM `kimia_farma.kf_final_transaction` AS t
-- Performing left join between table t and calculated_columns
LEFT JOIN calculated_columns AS cc ON t.transaction_id = cc.transaction_id
-- Performing left join between table t and kf_kantor_cabang
LEFT JOIN `kimia_farma.kf_kantor_cabang` AS k ON t.branch_id = k.branch_id
-- Performing left join between table t and kf_product
LEFT JOIN `kimia_farma.kf_product` AS p ON t.product_id = p.product_id
-- Performing left join between table t and kf_inventory
LEFT JOIN `kimia_farma.kf_inventory` AS i ON t.product_id = i.product_id
-- Joining with monthly_calculated CTE to get monthly profit and growth
LEFT JOIN monthly_calculated AS mc ON cc.month = mc.month;
