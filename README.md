# KimiaFarmaAnalytics

## Project Description
This project aims to perform data analysis on product sales at Kimia Farma company. The data used includes transaction data, product data, and data on Kimia Farma branch offices. The analysis aims to provide insights into sales performance, profitability, and customer ratings of Kimia Farma branches.

## Query Usage
The provided query is used to generate data analysis of Kimia Farma product sales. This query retrieves data from three main tables: `kf_final_transaction`, `kf_kantor_cabang`, and `kf_product`. The query combines these tables using appropriate columns such as `transaction_id`, `branch_id`, and `product_id`. Additionally, the query includes subqueries (CTEs) used to calculate additional columns such as `persentase_gross_laba` and `nett_sales`.

## Usage Steps
1. Execute the query in BigQuery or any SQL-supported platform.
2. Ensure that the required tables (`kf_final_transaction`, `kf_kantor_cabang`, and `kf_product`) are available in the target database.
3. Examine the query results to obtain data analysis of Kimia Farma product sales.

## Additional Notes
- This query can be executed in BigQuery without requiring additional modifications.
- The query results will provide processed data for further analysis related to product sales at Kimia Farma.
