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
    CAST(t.price - (t.price * t.discount_percentage)AS INT64) AS nett_sales
  -- Selecting input columns from kf_final_transaction table (initial t)
  FROM `kimia_farma.kf_final_transaction` AS t
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
  -- Calculating nett_profit and rounding it so the profit is not decimals
  CAST(cc.nett_sales * cc.persentase_gross_laba AS INT64) AS nett_profit,
  t.rating AS rating_transaksi
-- Selecting input columns from kf_final_transaction table (initial t)
FROM `kimia_farma.kf_final_transaction` AS t
-- Performing left join between table t and k(kf_kantor_cabang) with the same branch_id connector
LEFT JOIN calculated_columns AS cc ON t.transaction_id = cc.transaction_id
-- Performing left join between table t and p (kf_product) with the same product_id connector
LEFT JOIN `kimia_farma.kf_kantor_cabang` AS k ON t.branch_id = k.branch_id
-- Performing left join between table t and p (kf_product) with the same product_id connector
LEFT JOIN `kimia_farma.kf_product` AS p ON t.product_id = p.product_id;
