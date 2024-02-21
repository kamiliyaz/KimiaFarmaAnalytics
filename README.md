# KimiaFarmaAnalytics

## Deskripsi Proyek
Proyek ini bertujuan untuk melakukan analisis data penjualan produk di perusahaan Kimia Farma. Data yang digunakan meliputi data transaksi, data produk, dan data kantor cabang Kimia Farma. Analisis ini bertujuan untuk memberikan wawasan tentang performa penjualan, keuntungan, dan penilaian pelanggan terhadap cabang-cabang Kimia Farma.

## Penggunaan Query
Query yang disediakan digunakan untuk menghasilkan data analisis penjualan produk Kimia Farma. Query ini mengambil data dari tiga tabel utama: `kf_final_transaction`, `kf_kantor_cabang`, dan `kf_product`. Query tersebut menggabungkan tabel-tabel tersebut menggunakan kolom-kolom yang sesuai seperti `transaction_id`, `branch_id`, dan `product_id`. Selain itu, dalam query ini terdapat subquery (CTE) yang digunakan untuk menghitung kolom tambahan seperti `persentase_gross_laba` dan `nett_sales`.

## Langkah-langkah Penggunaan
1. Jalankan query di BigQuery atau platform yang mendukung SQL.
2. Pastikan bahwa tabel-tabel yang diperlukan (`kf_final_transaction`, `kf_kantor_cabang`, dan `kf_product`) sudah tersedia dalam database yang dituju.
3. Amati hasil query untuk mendapatkan data analisis penjualan produk Kimia Farma.

## Keterangan Tambahan
- Query ini dapat dijalankan di BigQuery tanpa perlu modifikasi tambahan.
- Hasil query akan memberikan data yang sudah diolah untuk analisis lebih lanjut terkait penjualan produk di Kimia Farma.
