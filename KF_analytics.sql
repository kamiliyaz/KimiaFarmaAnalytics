-- Membuat CTE untuk menghitung kolom tambahan
WITH calculated_columns AS ( -- membuat kolom judul calculated_column dari kolom transaction_id, price, dan discount_percentage dari tabel kf_final_transaction
  SELECT
  t.transaction_id,
  t.price AS actual_price,
  t.discount_percentage,
  -- membuat kolom persentase_gross_laba seperti yang ditentukan
  CASE
    WHEN t.price <= 50000 THEN t.price * 0.1
    WHEN t.price <= 100000 THEN t.price * 0.15
    WHEN t.price <= 300000 THEN t.price * 0.2
    WHEN t.price <= 500000 THEN t.price * 0.25
    ELSE t.price * 0.3
  END AS persentase_gross_laba,
 --membuat kolom nett_sales dengan mengurangi harga aktual dengan harga diskon  
  t.price - (t.price * t.discount_percentage) AS nett_sales,
-- mengambil kolom yang diinput dari tabel kf_final_transaction (inisial t)
  FROM `kimia_farma.kf_final_transaction` AS t
)
--mengambil kolom-kolom yang akan ditampilkan
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
  -- menghitung nett_profit karena sudah ada kolom nett_sales
  ((cc.nett_sales * cc.persentase_gross_laba) - cc.actual_price) AS nett_profit,
  t.rating AS rating_transaksi
-- mengambil kolom yang diinput dari tabel kf_final_transaction (inisial t)
FROM `kimia_farma.kf_final_transaction` AS t
LEFT JOIN calculated_columns AS cc ON t.transaction_id = cc.transaction_id
--melakukan left join antara tabel t dengan k(kf_kantor_cabang) dengan penghubung yang sama branch_id
LEFT JOIN `kimia_farma.kf_kantor_cabang`AS k ON t.branch_id = k.branch_id
--melakukan left join antara tabel t dengan p (kf_product) dengan penghubung yang sama product_id
LEFT JOIN `kimia_farma.kf_product` AS p ON t.product_id = p.product_id;

